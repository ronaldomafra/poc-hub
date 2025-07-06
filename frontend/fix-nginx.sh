#!/bin/bash

# Script para corrigir configuração do Nginx

set -e

echo "🔧 Corrigindo configuração do Nginx..."

# Remover configuração problemática
echo "🗑️ Removendo configuração atual..."
sudo rm -f /etc/nginx/sites-enabled/poc-hub-frontend

# Criar configuração simplificada
echo "📝 Criando nova configuração..."
cat > /tmp/nginx-simple.conf << 'EOF'
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

# Copiar nova configuração
sudo cp /tmp/nginx-simple.conf /etc/nginx/sites-available/poc-hub-frontend
sudo ln -sf /etc/nginx/sites-available/poc-hub-frontend /etc/nginx/sites-enabled/

# Remover site padrão se existir
if [ -L /etc/nginx/sites-enabled/default ]; then
    sudo rm /etc/nginx/sites-enabled/default
fi

# Testar configuração
echo "🧪 Testando configuração..."
if sudo nginx -t; then
    echo "✅ Configuração válida"
    
    # Recarregar Nginx
    echo "🔄 Recarregando Nginx..."
    sudo systemctl reload nginx
    echo "✅ Nginx recarregado com sucesso"
else
    echo "❌ Configuração inválida"
    exit 1
fi

echo "🎉 Configuração do Nginx corrigida!" 