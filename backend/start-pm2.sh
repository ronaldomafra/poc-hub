#!/bin/bash

# Script simples para iniciar PM2
# Atualiza o diretório no ecosystem.config.js e inicia

echo "🔧 Atualizando diretório no ecosystem.config.js..."
CURRENT_DIR=$(pwd)
sed -i "s|cwd:.*|cwd: '$CURRENT_DIR',|" ecosystem.config.js

echo "🚀 Iniciando PM2..."
pm2 start ecosystem.config.js --env production

echo "✅ PM2 iniciado!"
pm2 status 