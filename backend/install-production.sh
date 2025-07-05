#!/bin/bash

# 🚀 Script de Instalação Rápida para Produção - POC Hub Backend
# Este script automatiza todo o processo de instalação em produção

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configurações
DOMAIN=""
SSL_EMAIL=""
DB_PASSWORD=""
JWT_SECRET=""

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

# Função para obter entrada do usuário
get_user_input() {
    echo -n "$1: "
    read -r input
    echo "$input"
}

# Função para gerar senha aleatória
generate_random_password() {
    openssl rand -base64 32 | tr -d "=+/" | cut -c1-25
}

# Função para gerar JWT secret
generate_jwt_secret() {
    openssl rand -base64 64 | tr -d "=+/"
}

# Função para verificar se comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Função para instalar dependências do sistema
install_system_dependencies() {
    log "Instalando dependências do sistema..."
    
    # Atualizar sistema
    sudo apt update && sudo apt upgrade -y
    
    # Instalar curl
    sudo apt install curl -y
    
    # Instalar Node.js 18+
    if ! command_exists "node"; then
        log "Instalando Node.js..."
        curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
        sudo apt-get install -y nodejs
    fi
    
    # Instalar PostgreSQL
    if ! command_exists "psql"; then
        log "Instalando PostgreSQL..."
        sudo apt install postgresql postgresql-contrib -y
    fi
    
    # Instalar Nginx
    if ! command_exists "nginx"; then
        log "Instalando Nginx..."
        sudo apt install nginx -y
    fi
    
    # Instalar PM2
    if ! command_exists "pm2"; then
        log "Instalando PM2..."
        sudo npm install -g pm2
    fi
    
    # Instalar Certbot
    if ! command_exists "certbot"; then
        log "Instalando Certbot..."
        sudo apt install certbot python3-certbot-nginx -y
    fi
    
    log "Dependências do sistema instaladas"
}

# Função para verificar PostgreSQL
check_postgresql() {
    log "Verificando PostgreSQL..."
    
    # Verificar se PostgreSQL está rodando
    if ! systemctl is-active --quiet postgresql; then
        warning "PostgreSQL não está rodando. Iniciando..."
        sudo systemctl start postgresql
        sudo systemctl enable postgresql
    fi
    
    # Testar conexão com banco (assumindo que já está configurado)
    if command_exists "psql"; then
        if PGPASSWORD=$DB_PASSWORD psql -h localhost -U poc_mcp_system -d poc_mcp_system -c "SELECT 1;" >/dev/null 2>&1; then
            log "✅ Conexão com PostgreSQL OK"
        else
            warning "⚠️  Não foi possível conectar ao PostgreSQL. Verifique as configurações no .env"
        fi
    else
        warning "⚠️  PostgreSQL não está instalado"
    fi
}

# Função para configurar arquivo .env
setup_env_file() {
    log "Configurando arquivo .env..."
    
    # Gerar JWT secret se não fornecido
    if [ -z "$JWT_SECRET" ]; then
        JWT_SECRET=$(generate_jwt_secret)
        log "JWT secret gerado"
    fi
    
    # Criar arquivo .env
    cat > .env << EOF
# Configurações do Banco de Dados
DB_HOST=localhost
DB_PORT=5432
DB_NAME=poc_mcp_system
DB_USER=poc_mcp_system
DB_PASSWORD=sua_senha_do_banco_aqui

# Configurações do JWT
JWT_SECRET=$JWT_SECRET
JWT_EXPIRES_IN=24h

# Configurações do Servidor
PORT=3001
NODE_ENV=production

# Configurações de Segurança
BCRYPT_ROUNDS=12
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100

# Configurações de CORS
ALLOWED_ORIGINS=https://tradingfordummies.site,https://www.tradingfordummies.site
EOF
    
    log "Arquivo .env configurado"
}

# Função para instalar dependências do Node.js
install_node_dependencies() {
    log "Instalando dependências do Node.js..."
    
    # Limpar cache
    npm cache clean --force
    
    # Instalar dependências de produção
    npm ci --only=production || error "Erro ao instalar dependências"
    
    log "Dependências do Node.js instaladas"
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
        
        # Permitir porta da API (se necessário)
        sudo ufw allow 3001
        
        log "Firewall configurado"
    else
        warning "UFW não está instalado. Configure o firewall manualmente."
    fi
}

# Função para executar deploy
run_deploy() {
    log "Executando deploy da aplicação..."
    
    # Executar script de deploy
    if [ -f "deploy.sh" ]; then
        chmod +x deploy.sh
        ./deploy.sh || error "Erro no deploy"
    else
        error "Script de deploy não encontrado"
    fi
    
    log "Deploy concluído"
}

# Função para configurar Nginx
setup_nginx() {
    log "Configurando Nginx..."
    
    if [ -n "$DOMAIN" ] && [ -n "$SSL_EMAIL" ]; then
        # Executar script de configuração do Nginx
        if [ -f "setup-nginx.sh" ]; then
            chmod +x setup-nginx.sh
            ./setup-nginx.sh -d "$DOMAIN" -e "$SSL_EMAIL" || warning "Erro na configuração do Nginx"
        fi
    else
        warning "Domínio ou email não fornecidos. Configure Nginx manualmente."
    fi
    
    log "Nginx configurado"
}

# Função para configurar backup automático
setup_backup() {
    log "Configurando backup automático..."
    
    # Criar diretório de backup
    sudo mkdir -p /backups
    sudo chown $USER:$USER /backups
    
    # Configurar cron para backup diário
    if [ -f "backup.sh" ]; then
        chmod +x backup.sh
        (crontab -l 2>/dev/null; echo "0 2 * * * $(pwd)/backup.sh") | crontab -
        log "Backup automático configurado para 2h da manhã"
    fi
    
    log "Backup configurado"
}

# Função para testar instalação
test_installation() {
    log "Testando instalação..."
    
    # Testar se a aplicação está rodando
    sleep 5
    if curl -f -s http://localhost:3001/health >/dev/null 2>&1; then
        log "✅ Aplicação está respondendo"
    else
        warning "⚠️  Aplicação não está respondendo"
    fi
    
    # Testar PostgreSQL
    if PGPASSWORD=$DB_PASSWORD psql -h localhost -U poc_mcp_system -d poc_mcp_system -c "SELECT 1;" >/dev/null 2>&1; then
        log "✅ Banco de dados está funcionando"
    else
        warning "⚠️  Banco de dados não está funcionando"
    fi
    
    # Testar Nginx
    if systemctl is-active --quiet nginx; then
        log "✅ Nginx está funcionando"
    else
        warning "⚠️  Nginx não está funcionando"
    fi
    
    log "Testes concluídos"
}

# Função para mostrar informações finais
show_final_info() {
    log "=== INSTALAÇÃO CONCLUÍDA ==="
    echo
    echo -e "${GREEN}✅ Sistema instalado com sucesso!${NC}"
    echo
    echo -e "${BLUE}📊 Informações da Instalação:${NC}"
    echo -e "  Domínio: $DOMAIN"
    echo -e "  Porta da API: 3001"
    echo -e "  Banco: poc_mcp_system (já configurado)"
    echo -e "  Usuário do banco: poc_mcp_system"
    echo -e "  Senha do banco: configurada no .env"
    echo
    echo -e "${BLUE}🔗 URLs:${NC}"
    echo -e "  Local: http://localhost:3001"
    echo -e "  Health: http://localhost:3001/health"
    if [ -n "$DOMAIN" ]; then
        echo -e "  Externa: https://$DOMAIN"
        echo -e "  Health Externa: https://$DOMAIN/health"
    fi
    echo
    echo -e "${BLUE}📊 Comandos úteis:${NC}"
    echo -e "  pm2 status                    # Ver status da aplicação"
    echo -e "  pm2 logs poc-hub-backend      # Ver logs"
    echo -e "  sudo systemctl status nginx   # Status do Nginx"
    echo -e "  ./backup.sh                   # Backup manual"
    echo
    echo -e "${YELLOW}⚠️  Próximos passos:${NC}"
    echo -e "  1. Configurar DNS para apontar para este servidor"
    echo -e "  2. Testar todos os endpoints da API"
    echo -e "  3. Configurar monitoramento"
    echo -e "  4. Documentar credenciais"
    echo
    echo -e "${RED}🔐 IMPORTANTE:${NC}"
    echo -e "  - Configure a senha do banco no arquivo .env"
    echo -e "  - Guarde o JWT secret: $JWT_SECRET"
    echo -e "  - Configure backup externo"
    echo -e "  - Monitore logs regularmente"
}

# Função principal
main() {
    log "Iniciando instalação completa do POC Hub Backend..."
    
    # Verificar se está rodando como root
    if [ "$EUID" -eq 0 ]; then
        error "Não execute este script como root"
    fi
    
    # Verificar argumentos
    while [[ $# -gt 0 ]]; do
        case $1 in
            -d|--domain)
                DOMAIN="$2"
                shift 2
                ;;
            -e|--email)
                SSL_EMAIL="$2"
                shift 2
                ;;
            -p|--password)
                DB_PASSWORD="$2"
                shift 2
                ;;
            -j|--jwt-secret)
                JWT_SECRET="$2"
                shift 2
                ;;
            -h|--help)
                echo "Uso: $0 [OPÇÕES]"
                echo
                echo "Opções:"
                echo "  -d, --domain DOMAIN      Domínio para SSL"
                echo "  -e, --email EMAIL        Email para certificado SSL"
                echo "  -p, --password PASSWORD  Senha do banco (opcional)"
                echo "  -j, --jwt-secret SECRET  JWT secret (opcional)"
                echo "  -h, --help               Mostrar esta ajuda"
                echo
                echo "Exemplos:"
                echo "  $0 -d api.seudominio.com -e seu@email.com"
                echo "  $0 --domain api.seudominio.com --email seu@email.com"
                exit 0
                ;;
            *)
                error "Opção inválida: $1. Use --help para ver as opções"
                ;;
        esac
    done
    
    # Configurar domínio fixo
    DOMAIN="tradingfordummies.site"
    
    # Obter email se não fornecido
    if [ -z "$SSL_EMAIL" ]; then
        SSL_EMAIL=$(get_user_input "Digite o email para certificado SSL")
    fi
    
    # Executar etapas da instalação
    install_system_dependencies
    setup_env_file
    check_postgresql
    install_node_dependencies
    setup_firewall
    run_deploy
    setup_nginx
    setup_backup
    test_installation
    show_final_info
    
    log "Instalação concluída com sucesso!"
}

# Executar função principal
main "$@" 