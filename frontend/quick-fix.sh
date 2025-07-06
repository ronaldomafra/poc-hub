#!/bin/bash

# Script de correção rápida para problemas de dependências e Nginx

set -e

echo "🚀 Iniciando correção rápida..."

# 1. Corrigir dependências
echo "📦 Corrigindo dependências..."
rm -rf node_modules
rm -f package-lock.json
npm cache clean --force
npm install

# 2. Fazer build
echo "🔨 Fazendo build..."
npm run build

# 3. Fazer deploy
echo "🚀 Fazendo deploy..."
sudo rm -rf /var/www/poc-hub-frontend/*
cp -r build/* /var/www/poc-hub-frontend/
sudo chown -R www-data:www-data /var/www/poc-hub-frontend
sudo chmod -R 755 /var/www/poc-hub-frontend

# 4. Corrigir Nginx
echo "🔧 Corrigindo Nginx..."
sudo rm -f /etc/nginx/sites-enabled/poc-hub-frontend

cat > /tmp/nginx-fixed.conf << 'EOF'
server {
    listen 80;
    server_name tradingfordummies.site www.tradingfordummies.site;
    
    root /var/www/poc-hub-frontend;
    index index.html;
    
    # Configurações de cache para arquivos estáticos
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # Rota principal - servir index.html para SPA
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    # Configurações específicas para API (proxy para backend)
    location /api/ {
        proxy_pass http://localhost:3001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
EOF

sudo cp /tmp/nginx-fixed.conf /etc/nginx/sites-available/poc-hub-frontend
sudo ln -sf /etc/nginx/sites-available/poc-hub-frontend /etc/nginx/sites-enabled/

# Remover site padrão
if [ -L /etc/nginx/sites-enabled/default ]; then
    sudo rm /etc/nginx/sites-enabled/default
fi

# Testar e recarregar Nginx
if sudo nginx -t; then
    sudo systemctl reload nginx
    echo "✅ Nginx corrigido e recarregado"
else
    echo "❌ Erro na configuração do Nginx"
    exit 1
fi

echo "🎉 Correção concluída com sucesso!"
echo "🌐 Aplicação disponível em: http://tradingfordummies.site" 