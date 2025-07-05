# 🚀 POC Hub Frontend - Guia de Produção

Este documento contém informações essenciais para gerenciar o frontend React em produção.

## 📋 Informações Rápidas

- **Aplicação**: POC Hub Frontend
- **Domínio**: tradingfordummies.site
- **Diretório**: `/var/www/poc-hub-frontend`
- **Servidor**: Nginx
- **SSL**: Let's Encrypt
- **Backup**: Automático diário

## 🚀 Comandos Rápidos

### Deploy
```bash
# Deploy completo
./deploy.sh

# Deploy com verificação
./deploy.sh --help
```

### Backup
```bash
# Fazer backup manual
./backup.sh

# Listar backups
./backup.sh list

# Restaurar backup
./backup.sh restore 20231201_143022

# Limpar backups antigos
./backup.sh cleanup
```

### Nginx
```bash
# Status do Nginx
sudo systemctl status nginx

# Testar configuração
sudo nginx -t

# Recarregar configuração
sudo systemctl reload nginx

# Ver logs
sudo tail -f /var/log/nginx/error.log
sudo tail -f /var/log/nginx/access.log
```

### SSL
```bash
# Verificar certificados
sudo certbot certificates

# Renovar certificados
sudo certbot renew --dry-run

# Renovar manualmente
sudo certbot renew
```

## 📁 Estrutura de Arquivos

```
/var/www/poc-hub-frontend/     # Aplicação React
├── index.html                 # Página principal
├── static/                    # Arquivos estáticos
│   ├── css/                   # CSS compilado
│   ├── js/                    # JavaScript compilado
│   └── media/                 # Imagens e outros recursos
└── asset-manifest.json        # Manifesto de assets

/backups/frontend/             # Backups
├── app_frontend_backup_*.tar.gz    # Backup da aplicação
├── nginx_frontend_backup_*.tar.gz  # Backup do Nginx
├── ssl_frontend_backup_*.tar.gz    # Backup SSL
└── *.metadata                 # Metadados dos backups

/etc/nginx/sites-available/    # Configurações do Nginx
└── poc-hub-frontend          # Configuração do site

/var/log/                      # Logs
├── nginx/                     # Logs do Nginx
│   ├── access.log
│   └── error.log
└── poc-hub-frontend-deploy.log # Logs de deploy
```

## 🔧 Configurações Importantes

### Variáveis de Ambiente (.env)
```env
REACT_APP_API_URL=https://tradingfordummies.site
NODE_ENV=production
GENERATE_SOURCEMAP=false
```

### Nginx (poc-hub-frontend)
- **Porta**: 80 (HTTP) → 443 (HTTPS)
- **SSL**: Let's Encrypt
- **Cache**: Arquivos estáticos por 1 ano
- **Compressão**: Gzip habilitada
- **Rate Limiting**: 10 req/s por IP

### Firewall (UFW)
- **SSH**: Permitido
- **HTTP**: Porta 80
- **HTTPS**: Porta 443

## 🔄 Processo de Deploy

1. **Verificar pré-requisitos**
   ```bash
   node --version  # Deve ser 18+
   npm --version   # Deve estar instalado
   nginx -v        # Deve estar instalado
   ```

2. **Fazer backup atual**
   ```bash
   ./backup.sh
   ```

3. **Executar deploy**
   ```bash
   ./deploy.sh
   ```

4. **Verificar funcionamento**
   ```bash
   curl -I https://tradingfordummies.site
   curl -I https://tradingfordummies.site/login
   ```

## 🚨 Troubleshooting

### Problema: Página não carrega
```bash
# Verificar status do Nginx
sudo systemctl status nginx

# Verificar logs
sudo tail -f /var/log/nginx/error.log

# Verificar permissões
ls -la /var/www/poc-hub-frontend

# Verificar configuração
sudo nginx -t
```

### Problema: Erro de SSL
```bash
# Verificar certificado
sudo certbot certificates

# Renovar certificado
sudo certbot renew --dry-run

# Verificar domínio
nslookup tradingfordummies.site
```

### Problema: Erro de build
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

### Problema: Erro de permissões
```bash
# Ajustar permissões
sudo chown -R www-data:www-data /var/www/poc-hub-frontend
sudo chmod -R 755 /var/www/poc-hub-frontend
```

## 📊 Monitoramento

### Logs Importantes
```bash
# Logs de acesso
sudo tail -f /var/log/nginx/access.log

# Logs de erro
sudo tail -f /var/log/nginx/error.log

# Logs de deploy
tail -f /var/log/poc-hub-frontend-deploy.log

# Logs de backup
tail -f /var/log/poc-hub-frontend-backup.log
```

### Status dos Serviços
```bash
# Verificar todos os serviços
sudo systemctl status nginx
sudo systemctl status ufw
sudo certbot certificates
```

### Espaço em Disco
```bash
# Verificar uso de disco
df -h /var/www/poc-hub-frontend
df -h /backups/frontend

# Verificar tamanho dos backups
du -sh /backups/frontend/*
```

## 🔐 Segurança

### Headers de Segurança (Nginx)
- `X-Frame-Options: SAMEORIGIN`
- `X-XSS-Protection: 1; mode=block`
- `X-Content-Type-Options: nosniff`
- `Strict-Transport-Security: max-age=31536000; includeSubDomains`
- `Content-Security-Policy: default-src 'self' https: data: blob: 'unsafe-inline' 'unsafe-eval'`

### Rate Limiting
- **Limite**: 10 requisições por segundo por IP
- **Burst**: 20 requisições
- **Zona**: frontend

### SSL/TLS
- **Protocolos**: TLSv1.2, TLSv1.3
- **Cipher Suites**: ECDHE-RSA-AES256-GCM-SHA512, DHE-RSA-AES256-GCM-SHA512
- **Renovação**: Automática via cron

## 🔄 Atualizações

### Atualização de Dependências
```bash
# Atualizar dependências
npm update

# Verificar vulnerabilidades
npm audit

# Fazer deploy
./deploy.sh
```

### Atualização do Sistema
```bash
# Atualizar sistema
sudo apt update && sudo apt upgrade -y

# Reiniciar serviços se necessário
sudo systemctl restart nginx
```

### Rollback
```bash
# Listar backups
./backup.sh list

# Restaurar backup específico
./backup.sh restore 20231201_143022
```

## 📞 Suporte

### Informações do Sistema
```bash
# Versões
node --version
npm --version
nginx -v
certbot --version

# Sistema
uname -a
lsb_release -a
```

### Logs de Debug
```bash
# Logs detalhados do Nginx
sudo nginx -T

# Logs do sistema
sudo journalctl -u nginx -f
sudo journalctl -u certbot -f
```

### Contatos
- **Documentação**: Ver `DEPLOY_PRODUCAO.md`
- **Scripts**: `deploy.sh`, `backup.sh`, `setup-nginx.sh`
- **Logs**: `/var/log/nginx/`, `/var/log/poc-hub-frontend-*.log`

---

**⚠️ Importante**: Sempre faça backup antes de qualquer alteração em produção! 