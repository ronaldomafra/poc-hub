# 🚀 Guia de Deploy em Produção - POC Hub Backend

Este documento contém as instruções completas para publicar o backend em produção usando PM2.

## 📋 Pré-requisitos

### Servidor Linux (Ubuntu/Debian recomendado)
- Ubuntu 20.04+ ou Debian 11+
- Node.js 18+ instalado
- PostgreSQL 13+ instalado e configurado
- Nginx instalado (para proxy reverso)
- PM2 instalado globalmente

### Instalação dos Pré-requisitos

```bash
# Atualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar Node.js 18+
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Instalar PostgreSQL
sudo apt install postgresql postgresql-contrib -y

# Instalar Nginx
sudo apt install nginx -y

# Instalar PM2 globalmente
sudo npm install -g pm2

# Verificar instalações
node --version
npm --version
pm2 --version
postgres --version
nginx -v
```

## 🔧 Configuração do Banco de Dados

### 1. Configurar PostgreSQL

```bash
# Acessar PostgreSQL como superusuário
sudo -u postgres psql

# Criar banco de dados e usuário
CREATE DATABASE poc_mcp_system;
CREATE USER poc_mcp_system WITH ENCRYPTED PASSWORD 'sua_senha_segura_aqui';
GRANT ALL PRIVILEGES ON DATABASE poc_mcp_system TO poc_mcp_system;
\q
```

### 2. Executar Scripts SQL

```bash
# Executar schema principal
psql -h localhost -U poc_mcp_system -d poc_mcp_system -f schema.sql

# Executar script de criação de usuário (se necessário)
psql -h localhost -U poc_mcp_system -d poc_mcp_system -f criar_usuario.sql
```

## ⚙️ Configuração do Ambiente

### 1. Criar arquivo .env

```bash
# Copiar arquivo de exemplo
cp env.example .env

# Editar configurações
nano .env
```

### 2. Configurações de Produção (.env)

```env
# Configurações do Banco de Dados
DB_HOST=localhost
DB_PORT=5432
DB_NAME=poc_mcp_system
DB_USER=poc_mcp_system
DB_PASSWORD=sua_senha_do_banco_aqui

# Configurações do JWT
JWT_SECRET=chave_super_secreta_muito_longa_e_complexa_para_producao
JWT_EXPIRES_IN=24h

# Configurações do Servidor
PORT=3001
NODE_ENV=production

# Configurações de Segurança
BCRYPT_ROUNDS=12
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100

# Configurações de CORS (apenas HTTPS)
ALLOWED_ORIGINS=https://tradingfordummies.site,https://www.tradingfordummies.site
```

## 🔒 Configuração de Segurança

### 1. Firewall (UFW)

```bash
# Habilitar firewall
sudo ufw enable

# Permitir SSH
sudo ufw allow ssh

# Permitir HTTP e HTTPS
sudo ufw allow 80
sudo ufw allow 443

# Permitir porta da API (se necessário acesso direto)
sudo ufw allow 3001

# Verificar status
sudo ufw status
```

### 2. Configurar Nginx como Proxy Reverso

Criar arquivo de configuração do Nginx:

```bash
sudo nano /etc/nginx/sites-available/poc-hub-api
```

Conteúdo do arquivo:

```nginx
server {
    listen 80;
    server_name tradingfordummies.site www.tradingfordummies.site;

    # Redirecionar HTTP para HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name tradingfordummies.site www.tradingfordummies.site;

    # Configurações SSL (ajustar caminhos)
    ssl_certificate /etc/letsencrypt/live/tradingfordummies.site/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/tradingfordummies.site/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers off;

    # Headers de segurança
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;

    # Proxy para a API
    location / {
        proxy_pass http://localhost:3001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        proxy_read_timeout 86400;
    }

    # Health check
    location /health {
        proxy_pass http://localhost:3001/health;
        access_log off;
    }
}
```

Habilitar o site:

```bash
# Criar link simbólico
sudo ln -s /etc/nginx/sites-available/poc-hub-api /etc/nginx/sites-enabled/

# Testar configuração
sudo nginx -t

# Recarregar Nginx
sudo systemctl reload nginx
```

### 3. SSL com Let's Encrypt

```bash
# Instalar Certbot
sudo apt install certbot python3-certbot-nginx -y

# Obter certificado SSL
sudo certbot --nginx -d tradingfordummies.site -d www.tradingfordummies.site

# Configurar renovação automática
sudo crontab -e
# Adicionar linha: 0 12 * * * /usr/bin/certbot renew --quiet
```

## 🚀 Deploy com PM2

### 1. Executar Script de Deploy

```bash
# Dar permissão de execução
chmod +x deploy.sh

# Executar deploy
./deploy.sh
```

### 2. Comandos PM2 Úteis

```bash
# Ver status das aplicações
pm2 status

# Ver logs
pm2 logs poc-hub-backend

# Reiniciar aplicação
pm2 restart poc-hub-backend

# Parar aplicação
pm2 stop poc-hub-backend

# Deletar aplicação
pm2 delete poc-hub-backend

# Salvar configuração atual
pm2 save

# Configurar startup automático
pm2 startup
```

## 📊 Monitoramento

### 1. PM2 Monitor

```bash
# Interface web do PM2
pm2 monit

# Dashboard web (porta 9615)
pm2 web
```

### 2. Logs

```bash
# Ver logs em tempo real
pm2 logs poc-hub-backend --lines 100

# Ver logs de erro
pm2 logs poc-hub-backend --err --lines 50
```

## 🔄 Atualizações

### 1. Deploy de Atualizações

```bash
# Parar aplicação
pm2 stop poc-hub-backend

# Fazer pull das mudanças
git pull origin main

# Instalar dependências
npm install --production

# Reiniciar aplicação
pm2 restart poc-hub-backend
```

### 2. Rollback

```bash
# Voltar para versão anterior
git checkout HEAD~1

# Reinstalar dependências
npm install --production

# Reiniciar aplicação
pm2 restart poc-hub-backend
```

## 🧪 Testes Pós-Deploy

### 1. Health Check

```bash
# Testar endpoint de saúde
curl https://tradingfordummies.site/health

# Resposta esperada:
# {
#   "success": true,
#   "message": "API funcionando corretamente",
#   "timestamp": "2024-01-01T00:00:00.000Z",
#   "environment": "production"
# }
```

### 2. Testar Endpoints da API

```bash
# Testar autenticação
curl -X POST https://tradingfordummies.site/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@exemplo.com","password":"senha123"}'

# Testar produtos
curl https://tradingfordummies.site/api/produtos

# Testar dashboard
curl https://tradingfordummies.site/api/dashboard
```

## 🚨 Troubleshooting

### Problemas Comuns

1. **Aplicação não inicia**
   ```bash
   # Verificar logs
   pm2 logs poc-hub-backend
   
   # Verificar variáveis de ambiente
   pm2 env poc-hub-backend
   ```

2. **Erro de conexão com banco**
   ```bash
   # Testar conexão PostgreSQL
   psql -h localhost -U poc_mcp_system -d poc_mcp_system
   
   # Verificar status do PostgreSQL
   sudo systemctl status postgresql
   ```

3. **Erro de permissões**
   ```bash
   # Verificar permissões dos arquivos
   ls -la
   
   # Ajustar permissões se necessário
   chmod 755 deploy.sh
   ```

4. **Nginx não funciona**
   ```bash
   # Verificar status
   sudo systemctl status nginx
   
   # Verificar logs
   sudo tail -f /var/log/nginx/error.log
   ```

## 📞 Suporte

Em caso de problemas:

1. Verificar logs do PM2: `pm2 logs poc-hub-backend`
2. Verificar logs do Nginx: `sudo tail -f /var/log/nginx/error.log`
3. Verificar logs do PostgreSQL: `sudo tail -f /var/log/postgresql/postgresql-*.log`
4. Verificar status dos serviços: `sudo systemctl status nginx postgresql`

## 🔐 Segurança Adicional

### 1. Fail2ban (Proteção contra ataques)

```bash
# Instalar Fail2ban
sudo apt install fail2ban -y

# Configurar
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```

### 2. Backup Automático

```bash
# Criar script de backup
nano backup.sh
```

Conteúdo do script:

```bash
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backups"
DB_NAME="poc_mcp_system"

# Criar diretório de backup
mkdir -p $BACKUP_DIR

# Backup do banco
pg_dump -h localhost -U poc_mcp_system $DB_NAME > $BACKUP_DIR/db_backup_$DATE.sql

# Backup dos arquivos
tar -czf $BACKUP_DIR/app_backup_$DATE.tar.gz /caminho/para/aplicacao

# Manter apenas últimos 7 backups
find $BACKUP_DIR -name "*.sql" -mtime +7 -delete
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete
```

Configurar cron para backup diário:

```bash
# Adicionar ao crontab
crontab -e
# Adicionar: 0 2 * * * /caminho/para/backup.sh
```

---

**⚠️ Importante:** Sempre teste o deploy em um ambiente de staging antes de aplicar em produção! 