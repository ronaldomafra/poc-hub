# 🚀 POC Hub Backend - Produção

Este é o guia rápido para deploy em produção do backend POC Hub.

## 📋 Checklist Rápido

### ✅ Pré-requisitos
- [ ] Servidor Linux (Ubuntu 20.04+)
- [ ] Node.js 18+
- [ ] PostgreSQL 13+
- [ ] Nginx
- [ ] PM2
- [ ] Domínio configurado

### ✅ Configuração Inicial
- [ ] Instalar dependências do sistema
- [ ] Configurar PostgreSQL
- [ ] Criar arquivo `.env`
- [ ] Executar scripts SQL

### ✅ Deploy
- [ ] Executar script de deploy
- [ ] Configurar Nginx
- [ ] Configurar SSL
- [ ] Testar aplicação

## 🚀 Deploy Rápido

### 1. Instalar Pré-requisitos
```bash
# Atualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Instalar PostgreSQL
sudo apt install postgresql postgresql-contrib -y

# Instalar Nginx
sudo apt install nginx -y

# Instalar PM2
sudo npm install -g pm2
```

### 2. Verificar Banco de Dados
```bash
# Verificar se PostgreSQL está rodando
sudo systemctl status postgresql

# Testar conexão (assumindo que banco já está configurado)
psql -h localhost -U poc_mcp_system -d poc_mcp_system
```

### 3. Configurar Ambiente
```bash
# Copiar arquivo de exemplo
cp env.example .env

# Editar configurações
nano .env
```

### 4. Executar Deploy
```bash
# Dar permissão aos scripts
chmod +x deploy.sh setup-nginx.sh backup.sh

# Executar deploy
./deploy.sh
```

### 5. Configurar Nginx
```bash
# Configurar Nginx com domínio (apenas HTTPS)
./setup-nginx.sh -e seu@email.com
```

## 📊 Comandos Úteis

### PM2
```bash
# Ver status
pm2 status

# Ver logs
pm2 logs poc-hub-backend

# Reiniciar
pm2 restart poc-hub-backend

# Parar
pm2 stop poc-hub-backend

# Monitor
pm2 monit
```

### Nginx
```bash
# Testar configuração
sudo nginx -t

# Recarregar
sudo systemctl reload nginx

# Ver status
sudo systemctl status nginx

# Ver logs
sudo tail -f /var/log/nginx/error.log
```

### Backup
```bash
# Criar backup manual
./backup.sh

# Restaurar backup
./backup.sh restore 20240101_120000

# Configurar backup automático
crontab -e
# Adicionar: 0 2 * * * /caminho/para/backup.sh
```

## 🔧 Configurações Importantes

### Variáveis de Ambiente (.env)
```env
# Produção
NODE_ENV=production
PORT=3001
JWT_SECRET=chave_super_secreta_muito_longa_e_complexa
DB_PASSWORD=sua_senha_do_banco_aqui
ALLOWED_ORIGINS=https://tradingfordummies.site,https://www.tradingfordummies.site
```

### Firewall
```bash
# Configurar UFW
sudo ufw enable
sudo ufw allow ssh
sudo ufw allow 80
sudo ufw allow 443
sudo ufw allow 3001  # Se necessário acesso direto
```

### SSL
```bash
# Instalar Certbot
sudo apt install certbot python3-certbot-nginx -y

# Obter certificado
sudo certbot --nginx -d tradingfordummies.site

# Renovação automática
sudo crontab -e
# Adicionar: 0 12 * * * /usr/bin/certbot renew --quiet
```

## 🧪 Testes

### Health Check
```bash
# Local
curl http://localhost:3001/health

# Via Nginx
curl https://tradingfordummies.site/health
```

### API Endpoints
```bash
# Login
curl -X POST https://tradingfordummies.site/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@exemplo.com","password":"senha123"}'

# Produtos
curl https://tradingfordummies.site/api/produtos

# Dashboard
curl https://tradingfordummies.site/api/dashboard
```

## 🚨 Troubleshooting

### Problemas Comuns

1. **Aplicação não inicia**
   ```bash
   pm2 logs poc-hub-backend
   pm2 env poc-hub-backend
   ```

2. **Erro de banco**
   ```bash
   sudo systemctl status postgresql
   psql -h localhost -U poc_mcp_system -d poc_mcp_system
   ```

3. **Nginx não funciona**
   ```bash
   sudo nginx -t
   sudo systemctl status nginx
   sudo tail -f /var/log/nginx/error.log
   ```

4. **SSL não funciona**
   ```bash
   sudo certbot certificates
   sudo certbot renew --dry-run
   ```

## 📞 Suporte

### Logs Importantes
- PM2: `/var/log/poc-hub-backend.log`
- Nginx: `/var/log/nginx/error.log`
- PostgreSQL: `/var/log/postgresql/postgresql-*.log`
- Deploy: `/var/log/poc-hub-deploy.log`
- Backup: `/var/log/poc-hub-backup.log`

### Status dos Serviços
```bash
# Verificar todos os serviços
sudo systemctl status nginx postgresql
pm2 status
```

## 🔄 Atualizações

### Deploy de Atualização
```bash
# Parar aplicação
pm2 stop poc-hub-backend

# Fazer pull
git pull origin main

# Instalar dependências
npm install --production

# Reiniciar
pm2 restart poc-hub-backend
```

### Rollback
```bash
# Voltar versão anterior
git checkout HEAD~1
npm install --production
pm2 restart poc-hub-backend
```

---

**⚠️ Importante:** Sempre teste em staging antes de aplicar em produção! 