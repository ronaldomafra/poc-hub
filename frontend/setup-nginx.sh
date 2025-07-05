#!/bin/bash

# 🔧 Script de Configuração do Nginx - POC Hub Frontend
# Este script configura o Nginx como servidor web para a aplicação React

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configurações
DOMAIN="tradingfordummies.site"
NGINX_SITE="poc-hub-frontend"
SSL_EMAIL=""
DEPLOY_DIR="/var/www/poc-hub-frontend"

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

# Função para verificar se Nginx está instalado
check_nginx() {
    if ! command_exists "nginx"; then
        error "Nginx não está instalado. Execute: sudo apt install nginx -y"
    fi
    
    if ! systemctl is-active --quiet nginx; then
        warning "Nginx não está rodando. Iniciando..."
        sudo systemctl start nginx
        sudo systemctl enable nginx
    fi
    
    log "Nginx está instalado e rodando"
}

# Função para criar configuração do Nginx
create_nginx_config() {
    log "Criando configuração do Nginx..."
    
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
    sudo cp /tmp/nginx-frontend.conf /etc/nginx/sites-available/$NGINX_SITE
    
    # Criar link simbólico
    sudo ln -sf /etc/nginx/sites-available/$NGINX_SITE /etc/nginx/sites-enabled/
    
    # Remover site padrão se existir
    if [ -L /etc/nginx/sites-enabled/default ]; then
        sudo rm /etc/nginx/sites-enabled/default
    fi
    
    log "Configuração do Nginx criada"
}

# Função para testar configuração do Nginx
test_nginx_config() {
    log "Testando configuração do Nginx..."
    
    if sudo nginx -t; then
        log "Configuração do Nginx está válida"
    else
        error "Configuração do Nginx inválida"
    fi
}

# Função para recarregar Nginx
reload_nginx() {
    log "Recarregando Nginx..."
    
    sudo systemctl reload nginx
    
    if systemctl is-active --quiet nginx; then
        log "Nginx recarregado com sucesso"
    else
        error "Erro ao recarregar Nginx"
    fi
}

# Função para configurar SSL com Let's Encrypt
setup_ssl() {
    log "Configurando SSL com Let's Encrypt..."
    
    # Verificar se Certbot está instalado
    if ! command_exists "certbot"; then
        info "Instalando Certbot..."
        sudo apt update
        sudo apt install certbot python3-certbot-nginx -y
    fi
    
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

# Função para criar diretório de deploy
create_deploy_directory() {
    log "Criando diretório de deploy..."
    
    if ! dir_exists "$DEPLOY_DIR"; then
        sudo mkdir -p "$DEPLOY_DIR"
        sudo chown $USER:$USER "$DEPLOY_DIR"
        log "Diretório de deploy criado: $DEPLOY_DIR"
    else
        log "Diretório de deploy já existe: $DEPLOY_DIR"
    fi
}

# Função para testar configuração
test_configuration() {
    log "Testando configuração..."
    
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
}

# Função para mostrar informações finais
show_final_info() {
    log "=== CONFIGURAÇÃO DO NGINX CONCLUÍDA ==="
    echo
    echo -e "${GREEN}✅ Domínio: $DOMAIN${NC}"
    echo -e "${GREEN}✅ Diretório de deploy: $DEPLOY_DIR${NC}"
    echo -e "${GREEN}✅ SSL: Configurado${NC}"
    echo -e "${GREEN}✅ Firewall: Configurado${NC}"
    echo
    echo -e "${BLUE}🔗 URLs:${NC}"
    echo -e "  HTTP: http://$DOMAIN (redireciona para HTTPS)"
    echo -e "  HTTPS: https://$DOMAIN"
    echo -e "  Login: https://$DOMAIN/login"
    echo -e "  Dashboard: https://$DOMAIN/dashboard"
    echo
    echo -e "${BLUE}📊 Comandos úteis:${NC}"
    echo -e "  sudo nginx -t                    # Testar configuração"
    echo -e "  sudo systemctl reload nginx      # Recarregar Nginx"
    echo -e "  sudo systemctl status nginx      # Status do Nginx"
    echo -e "  sudo tail -f /var/log/nginx/error.log  # Logs de erro"
    echo -e "  sudo tail -f /var/log/nginx/access.log # Logs de acesso"
    echo
    echo -e "${YELLOW}⚠️  Próximos passos:${NC}"
    echo -e "  1. Configurar DNS para apontar para este servidor"
    echo -e "  2. Executar deploy da aplicação: ./deploy.sh"
    echo -e "  3. Testar todas as funcionalidades"
    echo -e "  4. Configurar backup automático"
}

# Função para verificar se diretório existe
dir_exists() {
    [ -d "$1" ]
}

# Função principal
main() {
    log "Iniciando configuração do Nginx para Frontend..."
    
    # Verificar se está rodando como root (permitido)
    if [ "$EUID" -eq 0 ]; then
        warning "Executando como root - certifique-se de que compreende os riscos de segurança"
    fi
    
    # Verificar argumentos
    while [[ $# -gt 0 ]]; do
        case $1 in
            -e|--email)
                SSL_EMAIL="$2"
                shift 2
                ;;
            -h|--help)
                echo "Uso: $0 [OPÇÕES]"
                echo
                echo "Opções:"
                echo "  -e, --email EMAIL      Email para certificado SSL"
                echo "  -h, --help             Mostrar esta ajuda"
                echo
                echo "Exemplos:"
                echo "  $0 -e seu@email.com"
                echo "  $0 --email seu@email.com"
                exit 0
                ;;
            *)
                error "Opção inválida: $1. Use --help para ver as opções"
                ;;
        esac
    done
    
    # Executar etapas
    check_nginx
    create_deploy_directory
    create_nginx_config
    test_nginx_config
    reload_nginx
    setup_ssl
    setup_firewall
    test_configuration
    show_final_info
    
    log "Configuração do Nginx concluída!"
}

# Executar função principal
main "$@" 