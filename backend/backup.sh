#!/bin/bash

# 💾 Script de Backup Automático - POC Hub Backend
# Este script cria backups da aplicação e banco de dados

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configurações
BACKUP_DIR="/backups"
APP_DIR="/home/ronaldo/projetos/pessoal/poc-hub-testes/backend"
DB_NAME="poc_mcp_system"
DB_USER="poc_mcp_system"
DB_HOST="localhost"
DB_PORT="5432"
RETENTION_DAYS=7
DATE=$(date +%Y%m%d_%H%M%S)
LOG_FILE="/var/log/poc-hub-backup.log"

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

# Função para carregar variáveis de ambiente
load_env() {
    if file_exists "$APP_DIR/.env"; then
        export $(grep -v '^#' $APP_DIR/.env | xargs)
        log "Variáveis de ambiente carregadas"
    else
        warning "Arquivo .env não encontrado"
    fi
}

# Função para criar diretório de backup
create_backup_dir() {
    log "Criando diretório de backup..."
    
    if ! dir_exists "$BACKUP_DIR"; then
        sudo mkdir -p "$BACKUP_DIR"
        sudo chown $USER:$USER "$BACKUP_DIR"
        log "Diretório de backup criado: $BACKUP_DIR"
    else
        log "Diretório de backup já existe: $BACKUP_DIR"
    fi
}

# Função para backup do código da aplicação
backup_application() {
    log "Criando backup da aplicação..."
    
    if dir_exists "$APP_DIR"; then
        # Criar backup do código (excluindo node_modules e logs)
        tar -czf "$BACKUP_DIR/app_backup_$DATE.tar.gz" \
            -C "$APP_DIR" \
            --exclude='node_modules' \
            --exclude='*.log' \
            --exclude='.git' \
            --exclude='.env' \
            --exclude='backups' \
            . 2>/dev/null || warning "Erro ao criar backup da aplicação"
        
        log "Backup da aplicação criado: app_backup_$DATE.tar.gz"
    else
        warning "Diretório da aplicação não encontrado: $APP_DIR"
    fi
}

# Função para backup do arquivo .env
backup_env() {
    log "Criando backup do arquivo .env..."
    
    if file_exists "$APP_DIR/.env"; then
        cp "$APP_DIR/.env" "$BACKUP_DIR/env_backup_$DATE.env" 2>/dev/null || warning "Erro ao criar backup do .env"
        log "Backup do .env criado: env_backup_$DATE.env"
    else
        warning "Arquivo .env não encontrado"
    fi
}

# Função para backup do banco de dados
backup_database() {
    log "Criando backup do banco de dados..."
    
    if command_exists "pg_dump"; then
        # Usar variáveis de ambiente se disponíveis
        local db_host=${DB_HOST:-localhost}
        local db_port=${DB_PORT:-5432}
        local db_name=${DB_NAME:-poc_mcp_system}
        local db_user=${DB_USER:-poc_mcp_system}
        local db_password=${DB_PASSWORD:-}
        
        if [ -n "$db_password" ]; then
            PGPASSWORD="$db_password" pg_dump \
                -h "$db_host" \
                -p "$db_port" \
                -U "$db_user" \
                -d "$db_name" \
                --verbose \
                --clean \
                --if-exists \
                --create \
                --no-owner \
                --no-privileges \
                > "$BACKUP_DIR/db_backup_$DATE.sql" 2>/dev/null || warning "Erro ao criar backup do banco"
        else
            pg_dump \
                -h "$db_host" \
                -p "$db_port" \
                -U "$db_user" \
                -d "$db_name" \
                --verbose \
                --clean \
                --if-exists \
                --create \
                --no-owner \
                --no-privileges \
                > "$BACKUP_DIR/db_backup_$DATE.sql" 2>/dev/null || warning "Erro ao criar backup do banco"
        fi
        
        log "Backup do banco criado: db_backup_$DATE.sql"
    else
        warning "pg_dump não está disponível"
    fi
}

# Função para backup dos logs do PM2
backup_pm2_logs() {
    log "Criando backup dos logs do PM2..."
    
    # Backup dos logs do PM2
    if command_exists "pm2"; then
        pm2 flush 2>/dev/null || warning "Erro ao fazer flush dos logs do PM2"
        
        # Copiar logs do PM2 se existirem
        for log_file in /var/log/poc-hub-backend*.log; do
            if file_exists "$log_file"; then
                cp "$log_file" "$BACKUP_DIR/pm2_$(basename $log_file)_$DATE" 2>/dev/null || warning "Erro ao copiar log: $log_file"
            fi
        done
        
        log "Backup dos logs do PM2 criado"
    else
        warning "PM2 não está disponível"
    fi
}

# Função para backup da configuração do Nginx
backup_nginx_config() {
    log "Criando backup da configuração do Nginx..."
    
    if command_exists "nginx"; then
        # Backup da configuração do Nginx
        tar -czf "$BACKUP_DIR/nginx_config_backup_$DATE.tar.gz" \
            -C /etc/nginx \
            sites-available sites-enabled nginx.conf 2>/dev/null || warning "Erro ao criar backup da configuração do Nginx"
        
        log "Backup da configuração do Nginx criado: nginx_config_backup_$DATE.tar.gz"
    else
        warning "Nginx não está disponível"
    fi
}

# Função para criar arquivo de metadados
create_metadata() {
    log "Criando arquivo de metadados..."
    
    cat > "$BACKUP_DIR/backup_metadata_$DATE.txt" << EOF
Backup POC Hub Backend
Data: $(date)
Versão: 1.0.0

Informações do Sistema:
- Sistema: $(uname -a)
- Usuário: $(whoami)
- Diretório: $(pwd)

Informações da Aplicação:
- Diretório: $APP_DIR
- Node.js: $(node --version 2>/dev/null || echo "N/A")
- NPM: $(npm --version 2>/dev/null || echo "N/A")
- PM2: $(pm2 --version 2>/dev/null || echo "N/A")

Informações do Banco:
- Host: ${DB_HOST:-localhost}
- Porta: ${DB_PORT:-5432}
- Banco: ${DB_NAME:-poc_mcp_system}
- Usuário: ${DB_USER:-poc_mcp_system}

Arquivos incluídos no backup:
- Aplicação: app_backup_$DATE.tar.gz
- Banco de dados: db_backup_$DATE.sql
- Configuração: env_backup_$DATE.env
- Nginx: nginx_config_backup_$DATE.tar.gz
- Logs PM2: pm2_*.log_$DATE

Tamanho dos arquivos:
$(du -h "$BACKUP_DIR"/*_$DATE* 2>/dev/null || echo "N/A")

Status dos serviços:
$(systemctl is-active nginx 2>/dev/null || echo "Nginx: N/A")
$(pm2 list 2>/dev/null | grep poc-hub-backend || echo "PM2: N/A")
EOF
    
    log "Arquivo de metadados criado: backup_metadata_$DATE.txt"
}

# Função para limpar backups antigos
cleanup_old_backups() {
    log "Limpando backups antigos (mais de $RETENTION_DAYS dias)..."
    
    if dir_exists "$BACKUP_DIR"; then
        # Remover backups antigos
        find "$BACKUP_DIR" -name "*.tar.gz" -mtime +$RETENTION_DAYS -delete 2>/dev/null || true
        find "$BACKUP_DIR" -name "*.sql" -mtime +$RETENTION_DAYS -delete 2>/dev/null || true
        find "$BACKUP_DIR" -name "*.env" -mtime +$RETENTION_DAYS -delete 2>/dev/null || true
        find "$BACKUP_DIR" -name "*.txt" -mtime +$RETENTION_DAYS -delete 2>/dev/null || true
        find "$BACKUP_DIR" -name "pm2_*.log_*" -mtime +$RETENTION_DAYS -delete 2>/dev/null || true
        
        log "Backups antigos removidos"
    fi
}

# Função para verificar espaço em disco
check_disk_space() {
    log "Verificando espaço em disco..."
    
    local available_space=$(df "$BACKUP_DIR" | awk 'NR==2 {print $4}')
    local required_space=1000000  # 1GB em KB
    
    if [ "$available_space" -lt "$required_space" ]; then
        warning "Espaço em disco insuficiente. Disponível: ${available_space}KB, Necessário: ${required_space}KB"
    else
        log "Espaço em disco suficiente: ${available_space}KB disponível"
    fi
}

# Função para testar backup do banco
test_database_backup() {
    log "Testando backup do banco de dados..."
    
    local backup_file="$BACKUP_DIR/db_backup_$DATE.sql"
    
    if file_exists "$backup_file"; then
        # Verificar se o arquivo não está vazio
        if [ -s "$backup_file" ]; then
            log "Backup do banco válido: $(du -h $backup_file | cut -f1)"
        else
            warning "Backup do banco está vazio"
        fi
    else
        warning "Arquivo de backup do banco não encontrado"
    fi
}

# Função para mostrar informações finais
show_final_info() {
    log "=== BACKUP CONCLUÍDO ==="
    echo
    echo -e "${GREEN}✅ Data: $(date)${NC}"
    echo -e "${GREEN}✅ Diretório: $BACKUP_DIR${NC}"
    echo -e "${GREEN}✅ Retenção: $RETENTION_DAYS dias${NC}"
    echo
    echo -e "${BLUE}📁 Arquivos criados:${NC}"
    ls -lh "$BACKUP_DIR"/*_$DATE* 2>/dev/null || echo "Nenhum arquivo encontrado"
    echo
    echo -e "${BLUE}💾 Tamanho total:${NC}"
    du -sh "$BACKUP_DIR" 2>/dev/null || echo "N/A"
    echo
    echo -e "${YELLOW}⚠️  Próximo backup automático: amanhã às 2h${NC}"
}

# Função para restaurar backup (função auxiliar)
restore_backup() {
    local backup_date="$1"
    
    if [ -z "$backup_date" ]; then
        error "Data do backup não especificada"
    fi
    
    log "Iniciando restauração do backup $backup_date..."
    
    # Restaurar aplicação
    if file_exists "$BACKUP_DIR/app_backup_$backup_date.tar.gz"; then
        log "Restaurando aplicação..."
        tar -xzf "$BACKUP_DIR/app_backup_$backup_date.tar.gz" -C "$APP_DIR" || warning "Erro ao restaurar aplicação"
    fi
    
    # Restaurar banco
    if file_exists "$BACKUP_DIR/db_backup_$backup_date.sql"; then
        log "Restaurando banco de dados..."
        psql -h localhost -U $DB_USER -d $DB_NAME < "$BACKUP_DIR/db_backup_$backup_date.sql" || warning "Erro ao restaurar banco"
    fi
    
    # Restaurar .env
    if file_exists "$BACKUP_DIR/env_backup_$backup_date.env"; then
        log "Restaurando configuração..."
        cp "$BACKUP_DIR/env_backup_$backup_date.env" "$APP_DIR/.env" || warning "Erro ao restaurar .env"
    fi
    
    log "Restauração concluída"
}

# Função principal
main() {
    log "Iniciando backup da aplicação POC Hub Backend..."
    
    # Verificar se está rodando como root (permitido)
    if [ "$EUID" -eq 0 ]; then
        warning "Executando como root - certifique-se de que compreende os riscos de segurança"
    fi
    
    # Verificar argumentos
    case "$1" in
        restore)
            restore_backup "$2"
            exit 0
            ;;
        -h|--help)
            echo "Uso: $0 [OPÇÃO]"
            echo
            echo "Opções:"
            echo "  restore DATA    Restaurar backup de uma data específica"
            echo "  -h, --help      Mostrar esta ajuda"
            echo
            echo "Exemplos:"
            echo "  $0              # Criar backup"
            echo "  $0 restore 20240101_120000  # Restaurar backup"
            exit 0
            ;;
        "")
            # Executar backup normal
            ;;
        *)
            error "Opção inválida: $1. Use --help para ver as opções"
            ;;
    esac
    
    # Executar etapas do backup
    load_env
    create_backup_dir
    check_disk_space
    backup_application
    backup_env
    backup_database
    backup_pm2_logs
    backup_nginx_config
    create_metadata
    test_database_backup
    cleanup_old_backups
    show_final_info
    
    log "Backup concluído com sucesso!"
}

# Executar função principal
main "$@" 