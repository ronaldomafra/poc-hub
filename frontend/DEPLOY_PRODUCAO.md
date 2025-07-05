# 🚀 Guia de Deploy em Produção - POC Hub Frontend

Este documento contém as instruções completas para publicar o frontend React em produção usando Nginx.

## 📋 Pré-requisitos

### Servidor Linux (Ubuntu/Debian recomendado)
- Ubuntu 20.04+ ou Debian 11+
- Node.js 18+ instalado
- Nginx instalado
- Git instalado

### Instalação dos Pré-requisitos

```bash
# Atualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar Node.js 18+
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Instalar Nginx
sudo apt install nginx -y

# Instalar Git
sudo apt install git -y

# Verificar instalações
node --version
npm --version
nginx -v
git --version
```

## ⚙️ Configuração do Ambiente

### 1. Configurar Variáveis de Ambiente

Criar arquivo `.env` na raiz do projeto:

```bash
# Copiar arquivo de exemplo (se existir)
cp .env.example .env

# Ou criar manualmente
nano .env
```

### 2. Configurações de Produção (.env)

```env
# URL da API Backend
REACT_APP_API_URL=https://tradingfordummies.site

# Configurações do Ambiente
NODE_ENV=production
GENERATE_SOURCEMAP=false

# Configurações de Build
REACT_APP_VERSION=1.0.0
REACT_APP_NAME=POC Hub Frontend
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

# Verificar status
sudo ufw status
```

### 2. Configurar Nginx como Servidor Web

Criar arquivo de configuração do Nginx:

```bash
sudo nano /etc/nginx/sites-available/poc-hub-frontend
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
    root /var/www/poc-hub-frontend/build;
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
    limit_req_zone $binary_remote_addr zone=frontend:10m rate=10r/s;
    limit_req zone=frontend burst=20 nodelay;

    # Rota principal - servir index.html para SPA
    location / {
        try_files $uri $uri/ /index.html;
        add_header Cache-Control "no-cache, no-store, must-revalidate";
        add_header Pragma "no-cache";
        add_header Expires "0";
    }

    # Configurações específicas para API (proxy para backend)
    location /api/ {
        proxy_pass https://tradingfordummies.site;
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
```

Habilitar o site:

```bash
# Criar link simbólico
sudo ln -s /etc/nginx/sites-available/poc-hub-frontend /etc/nginx/sites-enabled/

# Remover site padrão se existir
sudo rm -f /etc/nginx/sites-enabled/default

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

## 🚀 Deploy com Scripts Automatizados

### 1. Executar Script de Deploy

```bash
# Dar permissão de execução
chmod +x deploy.sh

# Executar deploy
./deploy.sh
```

### 2. Comandos Úteis

```bash
# Verificar status do Nginx
sudo systemctl status nginx

# Ver logs do Nginx
sudo tail -f /var/log/nginx/error.log
sudo tail -f /var/log/nginx/access.log

# Recarregar Nginx
sudo systemctl reload nginx

# Testar configuração
sudo nginx -t
```

## 📊 Monitoramento

### 1. Logs

```bash
# Logs de acesso
sudo tail -f /var/log/nginx/access.log

# Logs de erro
sudo tail -f /var/log/nginx/error.log

# Logs de deploy
tail -f /var/log/poc-hub-frontend-deploy.log
```

### 2. Status dos Serviços

```bash
# Verificar status do Nginx
sudo systemctl status nginx

# Verificar certificado SSL
sudo certbot certificates

# Verificar uso de disco
df -h /var/www/poc-hub-frontend
```

## 🔄 Atualizações

### 1. Deploy de Atualizações

```bash
# Fazer pull das mudanças
git pull origin main

# Executar deploy
./deploy.sh
```

### 2. Rollback

```bash
# Voltar para versão anterior
git checkout HEAD~1

# Executar deploy
./deploy.sh
```

## 🧪 Testes Pós-Deploy

### 1. Testes Básicos

```bash
# Testar acesso HTTP (deve redirecionar para HTTPS)
curl -I http://tradingfordummies.site

# Testar acesso HTTPS
curl -I https://tradingfordummies.site

# Testar arquivos estáticos
curl -I https://tradingfordummies.site/static/js/main.js
curl -I https://tradingfordummies.site/static/css/main.css
```

### 2. Testes de Funcionalidade

```bash
# Testar roteamento SPA
curl -I https://tradingfordummies.site/login
curl -I https://tradingfordummies.site/dashboard

# Testar API (deve fazer proxy para backend)
curl -I https://tradingfordummies.site/api/health
```

## 🚨 Troubleshooting

### Problemas Comuns

1. **Página não carrega**
   ```bash
   # Verificar status do Nginx
   sudo systemctl status nginx
   
   # Verificar logs
   sudo tail -f /var/log/nginx/error.log
   
   # Verificar permissões
   ls -la /var/www/poc-hub-frontend/build
   ```

2. **Erro de SSL**
   ```bash
   # Verificar certificado
   sudo certbot certificates
   
   # Renovar certificado
   sudo certbot renew --dry-run
   ```

3. **Erro de build**
   ```bash
   # Verificar Node.js
   node --version
   npm --version
   
   # Limpar cache
   npm cache clean --force
   
   # Reinstalar dependências
   rm -rf node_modules package-lock.json
   npm install
   ```

4. **Erro de permissões**
   ```bash
   # Verificar permissões dos arquivos
   ls -la /var/www/poc-hub-frontend
   
   # Ajustar permissões
   sudo chown -R www-data:www-data /var/www/poc-hub-frontend
   sudo chmod -R 755 /var/www/poc-hub-frontend
   ```

## 📞 Suporte

Em caso de problemas:

1. Verificar logs do Nginx: `sudo tail -f /var/log/nginx/error.log`
2. Verificar status do Nginx: `sudo systemctl status nginx`
3. Verificar certificado SSL: `sudo certbot certificates`
4. Verificar logs de deploy: `tail -f /var/log/poc-hub-frontend-deploy.log`

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
BACKUP_DIR="/backups/frontend"

# Criar diretório de backup
mkdir -p $BACKUP_DIR

# Backup dos arquivos
tar -czf $BACKUP_DIR/frontend_backup_$DATE.tar.gz /var/www/poc-hub-frontend

# Manter apenas últimos 7 backups
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