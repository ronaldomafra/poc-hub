#!/bin/bash

# 💾 Script de Backup - POC Hub Frontend
# Este script faz backup da aplicação, configurações e logs

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configurações
APP_NAME="poc-hub-frontend"
DEPLOY_DIR="/var/www/poc-hub-frontend"
BACKUP_DIR="/backups/frontend"
NGINX_CONFIG="/etc/nginx/sites-available/poc-hub-frontend"
SSL_CERTS="/etc/letsencrypt/live/tradingfordummies.site"
RETENTION_DAYS=7
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="frontend_backup_$DATE.tar.gz"
METADATA_FILE="frontend_backup_$DATE.metadata"

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

# Função para verificar se diretório existe
dir_exists() {
    [ -d "$1" ]
}

# Função para verificar se arquivo existe
file_exists() {
    [ -f "$1" ]
}

# Função para criar diretório de backup
create_backup_directory() {
    log "Criando diretório de backup..."
    
    if ! dir_exists "$BACKUP_DIR"; then
        sudo mkdir -p "$BACKUP_DIR"
        sudo chown $USER:$USER "$BACKUP_DIR"
        log "Diretório de backup criado: $BACKUP_DIR"
    else
        log "Diretório de backup já existe: $BACKUP_DIR"
    fi
}

# Função para fazer backup da aplicação
backup_application() {
    log "Fazendo backup da aplicação..."
    
    if dir_exists "$DEPLOY_DIR"; then
        # Backup da aplicação
        tar -czf "$BACKUP_DIR/app_$BACKUP_FILE" -C /var/www poc-hub-frontend 2>/dev/null || warning "Não foi possível fazer backup da aplicação"
        log "Backup da aplicação criado: app_$BACKUP_FILE"
    else
        warning "Diretório da aplicação não encontrado: $DEPLOY_DIR"
    fi
}

# Função para fazer backup das configurações do Nginx
backup_nginx_config() {
    log "Fazendo backup das configurações do Nginx..."
    
    if file_exists "$NGINX_CONFIG"; then
        # Backup da configuração do Nginx
        tar -czf "$BACKUP_DIR/nginx_$BACKUP_FILE" -C /etc/nginx sites-available/poc-hub-frontend 2>/dev/null || warning "Não foi possível fazer backup da configuração do Nginx"
        log "Backup da configuração do Nginx criado: nginx_$BACKUP_FILE"
    else
        warning "Configuração do Nginx não encontrada: $NGINX_CONFIG"
    fi
}

# Função para fazer backup dos certificados SSL
backup_ssl_certs() {
    log "Fazendo backup dos certificados SSL..."
    
    if dir_exists "$SSL_CERTS"; then
        # Backup dos certificados SSL
        sudo tar -czf "$BACKUP_DIR/ssl_$BACKUP_FILE" -C /etc/letsencrypt live/tradingfordummies.site 2>/dev/null || warning "Não foi possível fazer backup dos certificados SSL"
        sudo chown $USER:$USER "$BACKUP_DIR/ssl_$BACKUP_FILE"
        log "Backup dos certificados SSL criado: ssl_$BACKUP_FILE"
    else
        warning "Certificados SSL não encontrados: $SSL_CERTS"
    fi
}

# Função para fazer backup dos logs
backup_logs() {
    log "Fazendo backup dos logs..."
    
    # Backup dos logs do Nginx
    if file_exists "/var/log/nginx/access.log"; then
        cp /var/log/nginx/access.log "$BACKUP_DIR/nginx_access_$DATE.log" 2>/dev/null || warning "Não foi possível fazer backup do log de acesso"
    fi
    
    if file_exists "/var/log/nginx/error.log"; then
        cp /var/log/nginx/error.log "$BACKUP_DIR/nginx_error_$DATE.log" 2>/dev/null || warning "Não foi possível fazer backup do log de erro"
    fi
    
    # Backup dos logs de deploy
    if file_exists "/var/log/poc-hub-frontend-deploy.log"; then
        cp /var/log/poc-hub-frontend-deploy.log "$BACKUP_DIR/deploy_$DATE.log" 2>/dev/null || warning "Não foi possível fazer backup do log de deploy"
    fi
    
    log "Backup dos logs criado"
}

# Função para criar arquivo de metadados
create_metadata() {
    log "Criando arquivo de metadados..."
    
    cat > "$BACKUP_DIR/$METADATA_FILE" << EOF
# Metadados do Backup - POC Hub Frontend
Data: $(date)
Versão: 1.0.0
Aplicação: $APP_NAME

## Informações do Sistema
Sistema Operacional: $(uname -a)
Node.js: $(node --version 2>/dev/null || echo "Não instalado")
NPM: $(npm --version 2>/dev/null || echo "Não instalado")
Nginx: $(nginx -v 2>&1 | head -1 || echo "Não instalado")

## Status dos Serviços
Nginx: $(systemctl is-active nginx 2>/dev/null || echo "Desconhecido")

## Arquivos de Backup
- app_$BACKUP_FILE: Aplicação React
- nginx_$BACKUP_FILE: Configuração do Nginx
- ssl_$BACKUP_FILE: Certificados SSL
- nginx_access_$DATE.log: Log de acesso do Nginx
- nginx_error_$DATE.log: Log de erro do Nginx
- deploy_$DATE.log: Log de deploy

## Tamanho dos Arquivos
$(du -h "$BACKUP_DIR"/*$DATE* 2>/dev/null || echo "Arquivos não encontrados")

## Configurações
Domínio: tradingfordummies.site
Diretório de Deploy: $DEPLOY_DIR
Retenção: $RETENTION_DAYS dias

## Comandos de Restauração
# Restaurar aplicação:
# sudo rm -rf $DEPLOY_DIR/*
# sudo tar -xzf $BACKUP_DIR/app_$BACKUP_FILE -C /var/www/

# Restaurar configuração do Nginx:
# sudo tar -xzf $BACKUP_DIR/nginx_$BACKUP_FILE -C /etc/nginx/sites-available/

# Restaurar certificados SSL:
# sudo tar -xzf $BACKUP_DIR/ssl_$BACKUP_FILE -C /etc/letsencrypt/live/

# Recarregar Nginx após restauração:
# sudo nginx -t && sudo systemctl reload nginx
EOF
    
    log "Arquivo de metadados criado: $METADATA_FILE"
}

# Função para limpar backups antigos
cleanup_old_backups() {
    log "Limpando backups antigos..."
    
    if dir_exists "$BACKUP_DIR"; then
        # Remover backups mais antigos que RETENTION_DAYS
        find "$BACKUP_DIR" -name "*.tar.gz" -mtime +$RETENTION_DAYS -delete 2>/dev/null || true
        find "$BACKUP_DIR" -name "*.log" -mtime +$RETENTION_DAYS -delete 2>/dev/null || true
        find "$BACKUP_DIR" -name "*.metadata" -mtime +$RETENTION_DAYS -delete 2>/dev/null || true
        
        log "Backups antigos removidos (retenção: $RETENTION_DAYS dias)"
    fi
}

# Função para verificar espaço em disco
check_disk_space() {
    log "Verificando espaço em disco..."
    
    # Verificar espaço disponível no diretório de backup
    AVAILABLE_SPACE=$(df "$BACKUP_DIR" | awk 'NR==2 {print $4}')
    AVAILABLE_SPACE_MB=$((AVAILABLE_SPACE / 1024))
    
    if [ "$AVAILABLE_SPACE_MB" -lt 100 ]; then
        warning "Pouco espaço em disco disponível: ${AVAILABLE_SPACE_MB}MB"
    else
        log "Espaço em disco disponível: ${AVAILABLE_SPACE_MB}MB"
    fi
}

# Função para mostrar informações do backup
show_backup_info() {
    log "=== BACKUP CONCLUÍDO ==="
    echo
    echo -e "${GREEN}✅ Data: $(date)${NC}"
    echo -e "${GREEN}✅ Diretório: $BACKUP_DIR${NC}"
    echo -e "${GREEN}✅ Retenção: $RETENTION_DAYS dias${NC}"
    echo
    echo -e "${BLUE}📁 Arquivos criados:${NC}"
    
    if dir_exists "$BACKUP_DIR"; then
        ls -lh "$BACKUP_DIR"/*$DATE* 2>/dev/null || echo "Nenhum arquivo encontrado"
    fi
    
    echo
    echo -e "${BLUE}💾 Tamanho total:${NC}"
    if dir_exists "$BACKUP_DIR"; then
        du -sh "$BACKUP_DIR"/*$DATE* 2>/dev/null | awk '{sum += $1} END {print sum " total"}'
    fi
    
    echo
    echo -e "${YELLOW}⚠️  Comandos úteis:${NC}"
    echo -e "  ls -la $BACKUP_DIR/          # Listar backups"
    echo -e "  cat $BACKUP_DIR/$METADATA_FILE  # Ver metadados"
    echo -e "  ./restore.sh $DATE           # Restaurar backup (se existir)"
}

# Função para restaurar backup
restore_backup() {
    local backup_date="$1"
    
    if [ -z "$backup_date" ]; then
        error "Data do backup não fornecida. Uso: $0 restore YYYYMMDD_HHMMSS"
    fi
    
    log "Iniciando restauração do backup $backup_date..."
    
    # Verificar se arquivos de backup existem
    local app_backup="$BACKUP_DIR/app_frontend_backup_$backup_date.tar.gz"
    local nginx_backup="$BACKUP_DIR/nginx_frontend_backup_$backup_date.tar.gz"
    local ssl_backup="$BACKUP_DIR/ssl_frontend_backup_$backup_date.tar.gz"
    
    if ! file_exists "$app_backup"; then
        error "Arquivo de backup da aplicação não encontrado: $app_backup"
    fi
    
    # Fazer backup atual antes da restauração
    log "Criando backup de segurança antes da restauração..."
    create_backup_directory
    backup_application
    
    # Restaurar aplicação
    log "Restaurando aplicação..."
    sudo rm -rf "$DEPLOY_DIR"/*
    sudo tar -xzf "$app_backup" -C /var/www/ || error "Erro ao restaurar aplicação"
    sudo chown -R www-data:www-data "$DEPLOY_DIR"
    sudo chmod -R 755 "$DEPLOY_DIR"
    
    # Restaurar configuração do Nginx se existir
    if file_exists "$nginx_backup"; then
        log "Restaurando configuração do Nginx..."
        sudo tar -xzf "$nginx_backup" -C /etc/nginx/sites-available/ || warning "Erro ao restaurar configuração do Nginx"
    fi
    
    # Restaurar certificados SSL se existir
    if file_exists "$ssl_backup"; then
        log "Restaurando certificados SSL..."
        sudo tar -xzf "$ssl_backup" -C /etc/letsencrypt/live/ || warning "Erro ao restaurar certificados SSL"
    fi
    
    # Recarregar Nginx
    log "Recarregando Nginx..."
    if sudo nginx -t; then
        sudo systemctl reload nginx
        log "Nginx recarregado com sucesso"
    else
        error "Configuração do Nginx inválida após restauração"
    fi
    
    log "Restauração concluída com sucesso!"
}

# Função para listar backups
list_backups() {
    log "Listando backups disponíveis..."
    
    if ! dir_exists "$BACKUP_DIR"; then
        warning "Diretório de backup não existe: $BACKUP_DIR"
        return
    fi
    
    echo -e "${BLUE}📁 Backups disponíveis:${NC}"
    echo
    
    # Listar backups por data
    for backup in "$BACKUP_DIR"/frontend_backup_*.tar.gz; do
        if [ -f "$backup" ]; then
            filename=$(basename "$backup")
            date_part=$(echo "$filename" | sed 's/frontend_backup_\(.*\)\.tar\.gz/\1/')
            size=$(du -h "$backup" | cut -f1)
            mod_time=$(stat -c %y "$backup" | cut -d' ' -f1,2)
            echo -e "  📅 $date_part"
            echo -e "     📦 Tamanho: $size"
            echo -e "     🕒 Modificado: $mod_time"
            echo
        fi
    done
    
    if [ ! -f "$BACKUP_DIR"/frontend_backup_*.tar.gz ]; then
        echo "Nenhum backup encontrado"
    fi
}

# Função principal
main() {
    case "${1:-backup}" in
        backup)
            log "Iniciando backup da aplicação $APP_NAME..."
            create_backup_directory
            check_disk_space
            backup_application
            backup_nginx_config
            backup_ssl_certs
            backup_logs
            create_metadata
            cleanup_old_backups
            show_backup_info
            log "Backup concluído com sucesso!"
            ;;
        restore)
            restore_backup "$2"
            ;;
        list)
            list_backups
            ;;
        cleanup)
            log "Limpando backups antigos..."
            create_backup_directory
            cleanup_old_backups
            log "Limpeza concluída!"
            ;;
        -h|--help)
            echo "Uso: $0 [COMANDO] [ARGUMENTOS]"
            echo
            echo "Comandos:"
            echo "  backup              Fazer backup completo (padrão)"
            echo "  restore DATA        Restaurar backup específico"
            echo "  list                Listar backups disponíveis"
            echo "  cleanup             Limpar backups antigos"
            echo "  -h, --help          Mostrar esta ajuda"
            echo
            echo "Exemplos:"
            echo "  $0                  # Fazer backup"
            echo "  $0 backup           # Fazer backup"
            echo "  $0 restore 20231201_143022  # Restaurar backup"
            echo "  $0 list             # Listar backups"
            echo "  $0 cleanup          # Limpar backups antigos"
            ;;
        *)
            error "Comando inválido: $1. Use --help para ver os comandos disponíveis"
            ;;
    esac
}

# Executar função principal
main "$@" 