#!/bin/bash

# Script de teste para PM2
echo "=== Teste do PM2 ==="

# Verificar se PM2 está instalado
if command -v pm2 >/dev/null 2>&1; then
    echo "✅ PM2 está instalado"
    pm2 --version
else
    echo "❌ PM2 não está instalado"
    exit 1
fi

# Verificar status atual
echo ""
echo "=== Status atual do PM2 ==="
pm2 list

# Testar criação de diretório de logs
echo ""
echo "=== Criando diretório de logs ==="
sudo mkdir -p /var/log
sudo touch /var/log/poc-hub-backend.log
sudo touch /var/log/poc-hub-backend-error.log
sudo chmod 666 /var/log/poc-hub-backend*.log
echo "✅ Diretório de logs criado"

# Testar variáveis de ambiente
echo ""
echo "=== Variáveis de ambiente ==="
export NODE_ENV=production
export PORT=3001
echo "NODE_ENV: $NODE_ENV"
echo "PORT: $PORT"

# Testar comando PM2 com ecosystem
echo ""
echo "=== Testando comando PM2 com ecosystem ==="
if [ -f "ecosystem.config.js" ]; then
    echo "✅ Arquivo ecosystem.config.js encontrado"
    
    if pm2 start ecosystem.config.js --env production; then
        echo "✅ PM2 iniciou com sucesso usando ecosystem"
        pm2 list
        pm2 stop ecosystem.config.js --env production
        pm2 delete ecosystem.config.js --env production
        echo "✅ Teste concluído com sucesso"
    else
        echo "❌ Erro ao iniciar PM2 com ecosystem"
        echo "Verificando logs..."
        tail -n 10 /var/log/poc-hub-backend-error.log 2>/dev/null || echo "Log de erro não encontrado"
    fi
else
    echo "❌ Arquivo ecosystem.config.js não encontrado"
    echo "Testando comando PM2 simples..."
    if pm2 start src/server.js --name "test-app" --log /var/log/poc-hub-backend.log --error /var/log/poc-hub-backend-error.log --time; then
        echo "✅ PM2 iniciou com sucesso"
        pm2 list
        pm2 stop test-app
        pm2 delete test-app
        echo "✅ Teste concluído com sucesso"
    else
        echo "❌ Erro ao iniciar PM2"
        echo "Verificando logs..."
        tail -n 10 /var/log/poc-hub-backend-error.log 2>/dev/null || echo "Log de erro não encontrado"
    fi
fi 