#!/bin/bash

# Script para corrigir problemas de dependências do npm

set -e

echo "🔧 Corrigindo dependências do npm..."

# Remover node_modules e package-lock.json
echo "🗑️ Removendo node_modules e package-lock.json..."
rm -rf node_modules
rm -f package-lock.json

# Limpar cache do npm
echo "🧹 Limpando cache do npm..."
npm cache clean --force

# Instalar dependências do zero
echo "📦 Instalando dependências..."
npm install

# Verificar se a instalação foi bem-sucedida
if [ -d "node_modules" ] && [ -f "package-lock.json" ]; then
    echo "✅ Dependências corrigidas com sucesso!"
    echo "📊 Informações:"
    echo "   - node_modules: $(du -sh node_modules | cut -f1)"
    echo "   - package-lock.json: $(ls -lh package-lock.json | awk '{print $5}')"
else
    echo "❌ Erro ao corrigir dependências"
    exit 1
fi 