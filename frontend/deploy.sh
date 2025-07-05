#!/bin/bash

# 🚀 Script de Deploy em Produção - POC Hub Frontend
# Este script automatiza o processo de deploy da aplicação React em produção

set -e  # Parar execução em caso de erro

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configurações
APP_NAME="poc-hub-frontend"
BUILD_DIR="build"
DEPLOY_DIR="/var/www/poc-hub-frontend"
BACKUP_DIR="/backups/frontend"
LOG_FILE="/var/log/poc-hub-frontend-deploy.log"
DOMAIN="tradingfordummies.site"

# Função para logging
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}" | tee -a $LOG_FILE
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERRO: $1${NC}" | tee -a $LOG_FILE
    exit 1
}

warning() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] AVISO: $1${NC}" | tee -a $LOG_FILE
}

info() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')] INFO: $1${NC}" | tee -a $LOG_FILE
}

# Função para verificar se comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Função para verificar se arquivo existe
file_exists() {
    [ -f "$1" ]
}

# Função para verificar se diretório existe
dir_exists() {
    [ -d "$1" ]
}

# Função para criar backup
create_backup() {
    log "Criando backup da aplicação atual..."
    
    if ! dir_exists "$BACKUP_DIR"; then
        sudo mkdir -p "$BACKUP_DIR"
        sudo chown $USER:$USER "$BACKUP_DIR"
    fi
    
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    
    # Backup da aplicação atual se existir
    if dir_exists "$DEPLOY_DIR"; then
        tar -czf "$BACKUP_DIR/frontend_backup_$TIMESTAMP.tar.gz" -C /var/www poc-hub-frontend 2>/dev/null || warning "Não foi possível criar backup da aplicação"
        log "Backup da aplicação criado: frontend_backup_$TIMESTAMP.tar.gz"
    else
        log "Nenhuma aplicação anterior encontrada para backup"
    fi
}

# Função para verificar pré-requisitos
check_prerequisites() {
    log "Verificando pré-requisitos..."
    
    # Verificar Node.js
    if ! command_exists "node"; then
        error "Node.js não está instalado. Execute: curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - && sudo apt-get install -y nodejs"
    fi
    
    # Verificar npm
    if ! command_exists "npm"; then
        error "npm não está instalado"
    fi
    
    # Verificar Nginx
    if ! command_exists "nginx"; then
        error "Nginx não está instalado. Execute: sudo apt install nginx -y"
    fi
    
    # Verificar package.json
    if ! file_exists "package.json"; then
        error "package.json não encontrado"
    fi
    
    # Verificar se é um projeto React
    if ! grep -q "react-scripts" package.json; then
        error "Este não parece ser um projeto React (react-scripts não encontrado)"
    fi
    
    log "Todos os pré-requisitos estão atendidos"
}

# Função para verificar variáveis de ambiente
check_environment() {
    log "Verificando variáveis de ambiente..."
    
    # Verificar se arquivo .env existe
    if ! file_exists ".env"; then
        warning "Arquivo .env não encontrado. Criando arquivo padrão..."
        create_env_file
    fi
    
    # Verificar se REACT_APP_API_URL está configurado
    if ! grep -q "REACT_APP_API_URL" .env; then
        warning "REACT_APP_API_URL não configurado no .env"
    fi
    
    log "Variáveis de ambiente verificadas"
}

# Função para criar arquivo .env padrão
create_env_file() {
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
    
    log "Arquivo .env criado com configurações padrão"
}

# Função para instalar dependências
install_dependencies() {
    log "Instalando dependências..."
    
    # Limpar cache do npm
    npm cache clean --force
    
    # Instalar dependências
    npm ci --only=production || error "Erro ao instalar dependências"
    
    log "Dependências instaladas com sucesso"
}

# Função para fazer build da aplicação
build_application() {
    log "Fazendo build da aplicação..."
    
    # Limpar build anterior se existir
    if dir_exists "$BUILD_DIR"; then
        rm -rf "$BUILD_DIR"
        log "Build anterior removido"
    fi
    
    # Fazer build
    npm run build || error "Erro ao fazer build da aplicação"
    
    # Verificar se build foi criado
    if ! dir_exists "$BUILD_DIR"; then
        error "Build não foi criado"
    fi
    
    log "Build da aplicação criado com sucesso"
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

# Função para fazer deploy
deploy_application() {
    log "Fazendo deploy da aplicação..."
    
    # Limpar diretório de deploy
    sudo rm -rf "$DEPLOY_DIR"/*
    
    # Copiar arquivos do build
    cp -r "$BUILD_DIR"/* "$DEPLOY_DIR/" || error "Erro ao copiar arquivos para deploy"
    
    # Ajustar permissões
    sudo chown -R www-data:www-data "$DEPLOY_DIR"
    sudo chmod -R 755 "$DEPLOY_DIR"
    
    log "Deploy da aplicação concluído"
}

# Função para configurar Nginx
setup_nginx() {
    log "Configurando Nginx..."
    
    # Verificar se configuração do Nginx existe
    if ! file_exists "/etc/nginx/sites-available/poc-hub-frontend"; then
        warning "Configuração do Nginx não encontrada. Execute setup-nginx.sh primeiro"
        return
    fi
    
    # Verificar se site está habilitado
    if ! file_exists "/etc/nginx/sites-enabled/poc-hub-frontend"; then
        sudo ln -s /etc/nginx/sites-available/poc-hub-frontend /etc/nginx/sites-enabled/
        log "Site habilitado no Nginx"
    fi
    
    # Remover site padrão se existir
    if file_exists "/etc/nginx/sites-enabled/default"; then
        sudo rm /etc/nginx/sites-enabled/default
        log "Site padrão removido"
    fi
    
    # Testar configuração
    if sudo nginx -t; then
        log "Configuração do Nginx está válida"
    else
        error "Configuração do Nginx inválida"
    fi
    
    # Recarregar Nginx
    sudo systemctl reload nginx
    
    if systemctl is-active --quiet nginx; then
        log "Nginx recarregado com sucesso"
    else
        error "Erro ao recarregar Nginx"
    fi
}

# Função para verificar se aplicação está funcionando
check_application() {
    log "Verificando se aplicação está funcionando..."
    
    # Aguardar um pouco para o Nginx processar
    sleep 3
    
    # Testar acesso HTTP (deve redirecionar para HTTPS)
    if curl -f -s -I http://$DOMAIN >/dev/null 2>&1; then
        log "✅ Redirecionamento HTTP → HTTPS OK"
    else
        warning "⚠️  Redirecionamento HTTP não está funcionando"
    fi
    
    # Testar acesso HTTPS
    if curl -f -s -I https://$DOMAIN >/dev/null 2>&1; then
        log "✅ Acesso HTTPS OK"
    else
        warning "⚠️  Acesso HTTPS não está funcionando"
    fi
    
    # Testar arquivos estáticos
    if curl -f -s -I https://$DOMAIN/static/js/main.js >/dev/null 2>&1; then
        log "✅ Arquivos estáticos OK"
    else
        warning "⚠️  Arquivos estáticos não estão acessíveis"
    fi
    
    # Testar roteamento SPA
    if curl -f -s -I https://$DOMAIN/login >/dev/null 2>&1; then
        log "✅ Roteamento SPA OK"
    else
        warning "⚠️  Roteamento SPA não está funcionando"
    fi
}

# Função para limpar backups antigos
cleanup_old_backups() {
    log "Limpando backups antigos..."
    
    if dir_exists "$BACKUP_DIR"; then
        # Manter apenas últimos 5 backups
        find "$BACKUP_DIR" -name "*.tar.gz" -mtime +7 -delete 2>/dev/null || true
        log "Backups antigos removidos"
    fi
}

# Função para mostrar informações finais
show_final_info() {
    log "=== DEPLOY CONCLUÍDO COM SUCESSO ==="
    echo
    echo -e "${GREEN}✅ Aplicação: $APP_NAME${NC}"
    echo -e "${GREEN}✅ Domínio: $DOMAIN${NC}"
    echo -e "${GREEN}✅ Diretório: $DEPLOY_DIR${NC}"
    echo -e "${GREEN}✅ Nginx: $(systemctl is-active nginx)${NC}"
    echo
    echo -e "${BLUE}🔗 URLs:${NC}"
    echo -e "  HTTP: http://$DOMAIN (redireciona para HTTPS)"
    echo -e "  HTTPS: https://$DOMAIN"
    echo -e "  Login: https://$DOMAIN/login"
    echo -e "  Dashboard: https://$DOMAIN/dashboard"
    echo
    echo -e "${BLUE}📊 Comandos úteis:${NC}"
    echo -e "  sudo systemctl status nginx      # Status do Nginx"
    echo -e "  sudo nginx -t                    # Testar configuração"
    echo -e "  sudo systemctl reload nginx      # Recarregar Nginx"
    echo -e "  sudo tail -f /var/log/nginx/error.log  # Logs de erro"
    echo -e "  sudo tail -f /var/log/nginx/access.log # Logs de acesso"
    echo
    echo -e "${YELLOW}⚠️  Próximos passos:${NC}"
    echo -e "  1. Testar todas as funcionalidades da aplicação"
    echo -e "  2. Verificar se a API está funcionando corretamente"
    echo -e "  3. Configurar monitoramento se necessário"
    echo -e "  4. Configurar backup automático"
}

# Função principal
main() {
    log "Iniciando deploy da aplicação $APP_NAME..."
    
    # Verificar se está rodando como root (permitido)
    if [ "$EUID" -eq 0 ]; then
        warning "Executando como root - certifique-se de que compreende os riscos de segurança"
    fi
    
    # Verificar se está no diretório correto
    if ! file_exists "package.json"; then
        error "Execute este script no diretório raiz do projeto"
    fi
    
    # Executar etapas do deploy
    check_prerequisites
    check_environment
    create_backup
    install_dependencies
    build_application
    create_deploy_directory
    deploy_application
    setup_nginx
    check_application
    cleanup_old_backups
    show_final_info
    
    log "Deploy concluído com sucesso!"
}

# Função de ajuda
show_help() {
    echo "Uso: $0 [OPÇÃO]"
    echo
    echo "Opções:"
    echo "  -h, --help     Mostrar esta ajuda"
    echo "  -v, --version  Mostrar versão"
    echo
    echo "Exemplos:"
    echo "  $0              # Executar deploy completo"
    echo "  $0 --help       # Mostrar ajuda"
}

# Função de versão
show_version() {
    echo "Script de Deploy POC Hub Frontend v1.0.0"
}

# Processar argumentos
case "$1" in
    -h|--help)
        show_help
        exit 0
        ;;
    -v|--version)
        show_version
        exit 0
        ;;
    "")
        main
        ;;
    *)
        error "Opção inválida: $1. Use --help para ver as opções disponíveis"
        ;;
esac 