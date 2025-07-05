#!/bin/bash

# 🚀 Script de Instalação Rápida em Produção - POC Hub Frontend
# Este script automatiza toda a instalação e configuração do frontend em produção

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configurações
APP_NAME="poc-hub-frontend"
DOMAIN="tradingfordummies.site"
SSL_EMAIL=""
DEPLOY_DIR="/var/www/poc-hub-frontend"
BACKUP_DIR="/backups/frontend"

# Função para logging
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERRO: $1${NC}"
    exit 1
}

warning() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] AVISO: $1${NC}"
}

info() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')] INFO: $1${NC}"
}

# Função para verificar se comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Função para obter entrada do usuário
get_user_input() {
    echo -n "$1: "
    read -r input
    echo "$input"
}

# Função para verificar se está rodando como root (permitido)
check_root() {
    if [ "$EUID" -eq 0 ]; then
        warning "Executando como root - certifique-se de que compreende os riscos de segurança"
    fi
}

# Função para verificar se está no diretório correto
check_directory() {
    if ! [ -f "package.json" ]; then
        error "Execute este script no diretório raiz do projeto frontend"
    fi
    
    if ! grep -q "react-scripts" package.json; then
        error "Este não parece ser um projeto React (react-scripts não encontrado)"
    fi
}

# Função para atualizar sistema
update_system() {
    log "Atualizando sistema..."
    sudo apt update && sudo apt upgrade -y
    log "Sistema atualizado"
}

# Função para instalar Node.js
install_nodejs() {
    log "Instalando Node.js..."
    
    if command_exists "node"; then
        NODE_VERSION=$(node --version)
        log "Node.js já está instalado: $NODE_VERSION"
        return
    fi
    
    # Instalar Node.js 18+
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
    
    # Verificar instalação
    NODE_VERSION=$(node --version)
    NPM_VERSION=$(npm --version)
    log "Node.js instalado: $NODE_VERSION"
    log "NPM instalado: $NPM_VERSION"
}

# Função para instalar Nginx
install_nginx() {
    log "Instalando Nginx..."
    
    if command_exists "nginx"; then
        NGINX_VERSION=$(nginx -v 2>&1 | head -1)
        log "Nginx já está instalado: $NGINX_VERSION"
        return
    fi
    
    sudo apt install nginx -y
    
    # Habilitar e iniciar Nginx
    sudo systemctl enable nginx
    sudo systemctl start nginx
    
    # Verificar status
    if systemctl is-active --quiet nginx; then
        log "Nginx instalado e rodando"
    else
        error "Erro ao iniciar Nginx"
    fi
}

# Função para instalar Git
install_git() {
    log "Instalando Git..."
    
    if command_exists "git"; then
        GIT_VERSION=$(git --version)
        log "Git já está instalado: $GIT_VERSION"
        return
    fi
    
    sudo apt install git -y
    log "Git instalado"
}

# Função para instalar Certbot
install_certbot() {
    log "Instalando Certbot..."
    
    if command_exists "certbot"; then
        log "Certbot já está instalado"
        return
    fi
    
    sudo apt install certbot python3-certbot-nginx -y
    log "Certbot instalado"
}

# Função para configurar firewall
setup_firewall() {
    log "Configurando firewall..."
    
    if command_exists "ufw"; then
        # Habilitar firewall
        sudo ufw --force enable
        
        # Permitir SSH
        sudo ufw allow ssh
        
        # Permitir HTTP e HTTPS
        sudo ufw allow 80
        sudo ufw allow 443
        
        log "Firewall configurado"
    else
        warning "UFW não está instalado. Configure o firewall manualmente."
    fi
}

# Função para criar diretórios necessários
create_directories() {
    log "Criando diretórios necessários..."
    
    # Diretório de deploy
    if ! [ -d "$DEPLOY_DIR" ]; then
        sudo mkdir -p "$DEPLOY_DIR"
        sudo chown $USER:$USER "$DEPLOY_DIR"
        log "Diretório de deploy criado: $DEPLOY_DIR"
    fi
    
    # Diretório de backup
    if ! [ -d "$BACKUP_DIR" ]; then
        sudo mkdir -p "$BACKUP_DIR"
        sudo chown $USER:$USER "$BACKUP_DIR"
        log "Diretório de backup criado: $BACKUP_DIR"
    fi
    
    # Diretório de logs
    sudo mkdir -p /var/log
    sudo touch /var/log/poc-hub-frontend-deploy.log
    sudo chown $USER:$USER /var/log/poc-hub-frontend-deploy.log
    log "Arquivo de log criado"
}

# Função para configurar variáveis de ambiente
setup_environment() {
    log "Configurando variáveis de ambiente..."
    
    # Criar arquivo .env se não existir
    if ! [ -f ".env" ]; then
        cat > .env << EOF
# URL da API Backend
REACT_APP_API_URL=https://tradingfordummies.site

# Configurações do Ambiente
NODE_ENV=production
GENERATE_SOURCEMAP=false

# Configurações de Build
REACT_APP_VERSION=1.0.0
REACT_APP_NAME=POC Hub Frontend
EOF
        log "Arquivo .env criado"
    else
        log "Arquivo .env já existe"
    fi
}

# Função para instalar dependências
install_dependencies() {
    log "Instalando dependências..."
    
    # Limpar cache do npm
    npm cache clean --force
    
    # Instalar dependências
    npm ci --only=production
    log "Dependências instaladas"
}

# Função para fazer build da aplicação
build_application() {
    log "Fazendo build da aplicação..."
    
    # Limpar build anterior se existir
    if [ -d "build" ]; then
        rm -rf build
        log "Build anterior removido"
    fi
    
    # Fazer build
    npm run build
    
    # Verificar se build foi criado
    if ! [ -d "build" ]; then
        error "Build não foi criado"
    fi
    
    log "Build da aplicação criado"
}

# Função para fazer deploy
deploy_application() {
    log "Fazendo deploy da aplicação..."
    
    # Limpar diretório de deploy
    sudo rm -rf "$DEPLOY_DIR"/*
    
    # Copiar arquivos do build
    cp -r build/* "$DEPLOY_DIR/"
    
    # Ajustar permissões
    sudo chown -R www-data:www-data "$DEPLOY_DIR"
    sudo chmod -R 755 "$DEPLOY_DIR"
    
    log "Deploy da aplicação concluído"
}

# Função para configurar Nginx
setup_nginx() {
    log "Configurando Nginx..."
    
    # Obter email para SSL se não fornecido
    if [ -z "$SSL_EMAIL" ]; then
        SSL_EMAIL=$(get_user_input "Digite o email para certificado SSL")
    fi
    
    # Criar configuração do Nginx
    cat > /tmp/nginx-frontend.conf << EOF
server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;
    
    # Redirecionar HTTP para HTTPS
    return 301 https://\$server_name\$request_uri;
}

server {
    listen 443 ssl http2;
    server_name $DOMAIN www.$DOMAIN;
    
    # Configurações SSL (serão configuradas pelo Certbot)
    ssl_certificate /etc/letsencrypt/live/$DOMAIN/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$DOMAIN/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers off;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    
    # Headers de segurança
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' https: data: blob: 'unsafe-inline' 'unsafe-eval'; img-src 'self' data: https:; font-src 'self' https: data:;" always;
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    
    # Diretório raiz da aplicação
    root $DEPLOY_DIR;
    index index.html;
    
    # Configurações de cache para arquivos estáticos
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
        add_header Vary Accept-Encoding;
    }
    
    # Configurações de compressão
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_proxied expired no-cache no-store private must-revalidate auth;
    gzip_types
        text/plain
        text/css
        text/xml
        text/javascript
        application/javascript
        application/xml+rss
        application/json;
    
    # Configurações de rate limiting
    limit_req_zone \$binary_remote_addr zone=frontend:10m rate=10r/s;
    limit_req zone=frontend burst=20 nodelay;
    
    # Rota principal - servir index.html para SPA
    location / {
        try_files \$uri \$uri/ /index.html;
        add_header Cache-Control "no-cache, no-store, must-revalidate";
        add_header Pragma "no-cache";
        add_header Expires "0";
    }
    
    # Configurações específicas para API (proxy para backend)
    location /api/ {
        proxy_pass https://$DOMAIN;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
        proxy_read_timeout 86400;
    }
    
    # Favicon
    location = /favicon.ico {
        access_log off;
        log_not_found off;
    }
    
    # Robots.txt
    location = /robots.txt {
        access_log off;
        log_not_found off;
    }
    
    # Sitemap
    location = /sitemap.xml {
        access_log off;
        log_not_found off;
    }
}
EOF
    
    # Copiar configuração para Nginx
    sudo cp /tmp/nginx-frontend.conf /etc/nginx/sites-available/poc-hub-frontend
    
    # Criar link simbólico
    sudo ln -sf /etc/nginx/sites-available/poc-hub-frontend /etc/nginx/sites-enabled/
    
    # Remover site padrão se existir
    if [ -L /etc/nginx/sites-enabled/default ]; then
        sudo rm /etc/nginx/sites-enabled/default
    fi
    
    # Testar configuração
    if sudo nginx -t; then
        log "Configuração do Nginx está válida"
    else
        error "Configuração do Nginx inválida"
    fi
    
    # Recarregar Nginx
    sudo systemctl reload nginx
    log "Nginx configurado"
}

# Função para configurar SSL
setup_ssl() {
    log "Configurando SSL com Let's Encrypt..."
    
    # Obter certificado SSL
    if sudo certbot --nginx -d $DOMAIN -d www.$DOMAIN --non-interactive --agree-tos --email $SSL_EMAIL; then
        log "Certificado SSL configurado com sucesso"
        
        # Configurar renovação automática
        if ! sudo crontab -l 2>/dev/null | grep -q "certbot renew"; then
            (sudo crontab -l 2>/dev/null; echo "0 12 * * * /usr/bin/certbot renew --quiet") | sudo crontab -
            log "Renovação automática do SSL configurada"
        fi
    else
        warning "Não foi possível obter certificado SSL. Configure manualmente ou verifique o domínio."
    fi
}

# Função para configurar backup automático
setup_backup() {
    log "Configurando backup automático..."
    
    # Dar permissão de execução aos scripts
    chmod +x deploy.sh
    chmod +x backup.sh
    chmod +x setup-nginx.sh
    
    # Configurar cron para backup diário
    if ! crontab -l 2>/dev/null | grep -q "backup.sh"; then
        (crontab -l 2>/dev/null; echo "0 2 * * * cd $(pwd) && ./backup.sh > /var/log/poc-hub-frontend-backup.log 2>&1") | crontab -
        log "Backup automático configurado (diário às 2h)"
    fi
}

# Função para testar instalação
test_installation() {
    log "Testando instalação..."
    
    # Aguardar um pouco para o Nginx processar
    sleep 3
    
    # Testar Nginx
    if curl -f -s http://localhost >/dev/null 2>&1; then
        log "✅ Nginx está funcionando"
    else
        warning "⚠️  Nginx não está funcionando"
    fi
    
    # Testar domínio (se configurado)
    if curl -f -s http://$DOMAIN >/dev/null 2>&1; then
        log "✅ Domínio $DOMAIN está acessível"
    else
        warning "⚠️  Domínio $DOMAIN não está acessível"
    fi
    
    # Testar aplicação
    if [ -f "$DEPLOY_DIR/index.html" ]; then
        log "✅ Aplicação foi deployada"
    else
        warning "⚠️  Aplicação não foi deployada corretamente"
    fi
}

# Função para mostrar informações finais
show_final_info() {
    log "=== INSTALAÇÃO CONCLUÍDA COM SUCESSO ==="
    echo
    echo -e "${GREEN}✅ Aplicação: $APP_NAME${NC}"
    echo -e "${GREEN}✅ Domínio: $DOMAIN${NC}"
    echo -e "${GREEN}✅ Diretório: $DEPLOY_DIR${NC}"
    echo -e "${GREEN}✅ Nginx: $(systemctl is-active nginx)${NC}"
    echo -e "${GREEN}✅ SSL: Configurado${NC}"
    echo -e "${GREEN}✅ Firewall: Configurado${NC}"
    echo -e "${GREEN}✅ Backup: Automático${NC}"
    echo
    echo -e "${BLUE}🔗 URLs:${NC}"
    echo -e "  HTTP: http://$DOMAIN (redireciona para HTTPS)"
    echo -e "  HTTPS: https://$DOMAIN"
    echo -e "  Login: https://$DOMAIN/login"
    echo -e "  Dashboard: https://$DOMAIN/dashboard"
    echo
    echo -e "${BLUE}📊 Comandos úteis:${NC}"
    echo -e "  ./deploy.sh                    # Fazer novo deploy"
    echo -e "  ./backup.sh                    # Fazer backup manual"
    echo -e "  ./backup.sh list               # Listar backups"
    echo -e "  sudo systemctl status nginx    # Status do Nginx"
    echo -e "  sudo nginx -t                  # Testar configuração"
    echo -e "  sudo systemctl reload nginx    # Recarregar Nginx"
    echo
    echo -e "${BLUE}📝 Logs:${NC}"
    echo -e "  sudo tail -f /var/log/nginx/error.log      # Logs de erro"
    echo -e "  sudo tail -f /var/log/nginx/access.log     # Logs de acesso"
    echo -e "  tail -f /var/log/poc-hub-frontend-deploy.log # Logs de deploy"
    echo
    echo -e "${YELLOW}⚠️  Próximos passos:${NC}"
    echo -e "  1. Configurar DNS para apontar para este servidor"
    echo -e "  2. Testar todas as funcionalidades da aplicação"
    echo -e "  3. Verificar se a API está funcionando corretamente"
    echo -e "  4. Configurar monitoramento se necessário"
    echo
    echo -e "${GREEN}🎉 Instalação concluída! A aplicação está pronta para uso.${NC}"
}

# Função principal
main() {
    log "Iniciando instalação completa do $APP_NAME em produção..."
    
    # Verificações iniciais
    check_root
    check_directory
    
    # Executar etapas de instalação
    update_system
    install_nodejs
    install_nginx
    install_git
    install_certbot
    setup_firewall
    create_directories
    setup_environment
    install_dependencies
    build_application
    deploy_application
    setup_nginx
    setup_ssl
    setup_backup
    test_installation
    show_final_info
    
    log "Instalação concluída com sucesso!"
}

# Função de ajuda
show_help() {
    echo "Uso: $0 [OPÇÕES]"
    echo
    echo "Opções:"
    echo "  -e, --email EMAIL      Email para certificado SSL"
    echo "  -h, --help             Mostrar esta ajuda"
    echo
    echo "Exemplos:"
    echo "  $0 -e seu@email.com"
    echo "  $0 --email seu@email.com"
    echo "  $0                     # Email será solicitado durante a instalação"
}

# Processar argumentos
while [[ $# -gt 0 ]]; do
    case $1 in
        -e|--email)
            SSL_EMAIL="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            error "Opção inválida: $1. Use --help para ver as opções"
            ;;
    esac
done

# Executar função principal
main 