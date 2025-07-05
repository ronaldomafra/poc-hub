#!/bin/bash

# Script de Deploy para Produção
# Detecta automaticamente o diretório e configura o PM2

set -e

echo "🚀 Iniciando deploy de produção..."

# Detectar diretório atual
CURRENT_DIR=$(pwd)
echo "📁 Diretório atual: $CURRENT_DIR"

# Verificar se estamos no diretório correto
if [[ ! -f "ecosystem.config.js" ]]; then
    echo "❌ Erro: ecosystem.config.js não encontrado no diretório atual"
    echo "💡 Certifique-se de estar no diretório backend do projeto"
    exit 1
fi

# Verificar se o arquivo server.js existe
if [[ ! -f "src/server.js" ]]; then
    echo "❌ Erro: src/server.js não encontrado"
    echo "💡 Verifique se o arquivo existe no diretório src/"
    exit 1
fi

# Atualizar o ecosystem.config.js com o diretório correto
echo "🔧 Atualizando configuração do PM2..."
sed -i "s|cwd:.*|cwd: '$CURRENT_DIR',|" ecosystem.config.js

# Parar aplicação se estiver rodando
echo "🛑 Parando aplicação anterior..."
pm2 stop poc-hub-backend 2>/dev/null || true
pm2 delete poc-hub-backend 2>/dev/null || true

# Instalar dependências
echo "📦 Instalando dependências..."
npm install --production

# Iniciar aplicação com PM2
echo "🚀 Iniciando aplicação com PM2..."
pm2 start ecosystem.config.js --env production

# Verificar status
echo "📊 Status da aplicação:"
pm2 status

# Salvar configuração do PM2
echo "💾 Salvando configuração do PM2..."
pm2 save

# Configurar startup automático
echo "⚙️ Configurando startup automático..."
pm2 startup 2>/dev/null || echo "⚠️ Execute 'pm2 startup' manualmente se necessário"

echo "✅ Deploy concluído com sucesso!"
echo "🌐 Aplicação rodando em: http://localhost:3001"
echo "📋 Comandos úteis:"
echo "   pm2 status          - Ver status"
echo "   pm2 logs            - Ver logs"
echo "   pm2 restart all     - Reiniciar aplicação"
echo "   pm2 stop all        - Parar aplicação" 