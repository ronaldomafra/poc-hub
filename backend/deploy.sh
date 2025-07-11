#!/bin/bash

# 🚀 Script de Deploy em Produção - POC Hub Backend
# Este script automatiza o processo de deploy da aplicação em produção

set -e  # Parar execução em caso de erro

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configurações
APP_NAME="poc-hub-backend"
APP_PORT=3001
NODE_ENV="production"
BACKUP_DIR="/backups"
LOG_FILE="/var/log/poc-hub-deploy.log"

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
    
    # Backup do código atual
    if dir_exists "src"; then
        tar -czf "$BACKUP_DIR/code_backup_$TIMESTAMP.tar.gz" src/ package.json package-lock.json .env 2>/dev/null || warning "Não foi possível criar backup do código"
    fi
    
    # Backup do banco de dados
    if command_exists "pg_dump"; then
        if [ -n "$DB_NAME" ]; then
            pg_dump -h localhost -U $DB_USER $DB_NAME > "$BACKUP_DIR/db_backup_$TIMESTAMP.sql" 2>/dev/null || warning "Não foi possível criar backup do banco"
        fi
    fi
    
    log "Backup criado com sucesso"
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
    
    # Verificar PM2
    if ! command_exists "pm2"; then
        error "PM2 não está instalado. Execute: sudo npm install -g pm2"
    fi
    
    # Verificar PostgreSQL
    if ! command_exists "psql"; then
        error "PostgreSQL não está instalado. Execute: sudo apt install postgresql postgresql-contrib -y"
    fi
    
    # Verificar arquivo .env
    if ! file_exists ".env"; then
        error "Arquivo .env não encontrado. Copie env.example para .env e configure as variáveis"
    fi
    
    # Verificar package.json
    if ! file_exists "package.json"; then
        error "package.json não encontrado"
    fi
    
    log "Todos os pré-requisitos estão atendidos"
}

# Função para carregar variáveis de ambiente
load_env() {
    log "Carregando variáveis de ambiente..."
    
    if file_exists ".env"; then
        # Carregar variáveis de forma segura
        set -a
        source .env
        set +a
        log "Variáveis de ambiente carregadas"
    else
        warning "Arquivo .env não encontrado - usando variáveis padrão"
    fi
}



# Função para instalar dependências
install_dependencies() {
    log "Instalando dependências..."
    
    # Limpar cache do npm
    npm cache clean --force
    
    # Instalar dependências de produção
    npm ci --only=production || error "Erro ao instalar dependências"
    
    log "Dependências instaladas com sucesso"
}

# Função para parar aplicação atual
stop_application() {
    log "Parando aplicação atual..."
    
    # Parar aplicação usando ecosystem
    if [ -f "ecosystem.config.js" ]; then
        pm2 stop ecosystem.config.js --env production || warning "Não foi possível parar a aplicação"
        pm2 delete ecosystem.config.js --env production || warning "Não foi possível deletar a aplicação"
        log "Aplicação parada e removida do PM2"
    else
        # Fallback para parar por nome
        if pm2 list | grep -q "$APP_NAME"; then
            pm2 stop "$APP_NAME" || warning "Não foi possível parar a aplicação"
            pm2 delete "$APP_NAME" || warning "Não foi possível deletar a aplicação"
            log "Aplicação parada e removida do PM2"
        else
            log "Aplicação não estava rodando no PM2"
        fi
    fi
}

# Função para iniciar aplicação
start_application() {
    log "Iniciando aplicação..."
    
    # Criar diretório de logs se não existir
    sudo mkdir -p /var/log
    sudo touch /var/log/poc-hub-backend.log
    sudo touch /var/log/poc-hub-backend-error.log
    sudo touch /var/log/poc-hub-backend-out.log
    sudo chmod 666 /var/log/poc-hub-backend*.log
    
    # Verificar se ecosystem.config.js existe
    if [ ! -f "ecosystem.config.js" ]; then
        error "Arquivo ecosystem.config.js não encontrado"
    fi
    
    # Iniciar com PM2 usando ecosystem
    pm2 start ecosystem.config.js --env production || error "Erro ao iniciar aplicação com PM2"
    
    # Salvar configuração do PM2
    pm2 save || warning "Não foi possível salvar configuração do PM2"
    
    log "Aplicação iniciada com sucesso usando ecosystem"
}

# Função para verificar se aplicação está funcionando
check_application() {
    log "Verificando se aplicação está funcionando..."
    
    # Aguardar um pouco para a aplicação inicializar
    sleep 5
    
    # Verificar status no PM2 usando ecosystem
    if pm2 list | grep -q "$APP_NAME"; then
        log "Aplicação está registrada no PM2"
        
        # Verificar se está online
        if pm2 list | grep -q "$APP_NAME.*online"; then
            log "✅ Aplicação está online no PM2"
        else
            warning "⚠️  Aplicação não está online no PM2"
            log "Verificando logs de erro..."
            tail -n 10 /var/log/poc-hub-backend-error.log 2>/dev/null || echo "Log de erro não encontrado"
        fi
    else
        error "Aplicação não está registrada no PM2"
    fi
    
    # Testar health check (opcional)
    local port=3001
    for i in {1..5}; do
        if curl -f -s http://localhost:$port/health >/dev/null 2>&1; then
            log "✅ Health check OK - Aplicação está respondendo"
            return 0
        fi
        warning "Tentativa $i: Health check falhou, aguardando..."
        sleep 3
    done
    
    warning "⚠️  Health check falhou - verificar logs manualmente"
    log "Logs disponíveis em: /var/log/poc-hub-backend*.log"
}

# Função para configurar startup automático
setup_autostart() {
    log "Configurando startup automático..."
    
    # Configurar startup automático (versão simplificada)
    pm2 startup || warning "Não foi possível configurar startup automático"
    log "Startup automático configurado"
}

# Função para limpar backups antigos
cleanup_old_backups() {
    log "Limpando backups antigos..."
    
    if dir_exists "$BACKUP_DIR"; then
        # Manter apenas últimos 5 backups
        find "$BACKUP_DIR" -name "*.tar.gz" -mtime +7 -delete 2>/dev/null || true
        find "$BACKUP_DIR" -name "*.sql" -mtime +7 -delete 2>/dev/null || true
        log "Backups antigos removidos"
    fi
}

# Função para mostrar informações finais
show_final_info() {
    log "=== DEPLOY CONCLUÍDO COM SUCESSO ==="
    echo
    echo -e "${GREEN}✅ Aplicação: $APP_NAME${NC}"
    echo -e "${GREEN}✅ Porta: $APP_PORT${NC}"
    echo -e "${GREEN}✅ Ambiente: $NODE_ENV${NC}"
    echo -e "${GREEN}✅ Status: $(pm2 list | grep $APP_NAME | awk '{print $10}')${NC}"
    echo
    echo -e "${BLUE}📊 Comandos úteis:${NC}"
    echo -e "  pm2 status                    # Ver status"
    echo -e "  pm2 logs $APP_NAME           # Ver logs"
    echo -e "  pm2 restart $APP_NAME        # Reiniciar"
    echo -e "  pm2 stop $APP_NAME           # Parar"
    echo -e "  pm2 monit                    # Monitor"
    echo
    echo -e "${BLUE}🔗 URLs:${NC}"
    echo -e "  Local: http://localhost:$APP_PORT"
    echo -e "  Health: http://localhost:$APP_PORT/health"
    echo
    echo -e "${YELLOW}⚠️  Lembre-se de configurar o Nginx como proxy reverso para acesso externo${NC}"
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
    load_env
    create_backup
    stop_application
    install_dependencies
    start_application
    check_application
    setup_autostart
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
    echo "Script de Deploy POC Hub Backend v1.0.0"
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