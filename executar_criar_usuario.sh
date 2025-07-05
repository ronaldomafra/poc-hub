#!/bin/bash

# =====================================================
# SCRIPT PARA CRIAR USUÁRIO NO SISTEMA POC HUB
# =====================================================

echo "🚀 Criando usuário de teste no sistema POC Hub..."

# Configurações do banco (ajuste conforme necessário)
DB_HOST="localhost"
DB_PORT="5432"
DB_NAME="poc_hub_db"
DB_USER="poc_mcp_system"

# Verificar se o psql está instalado
if ! command -v psql &> /dev/null; then
    echo "❌ PostgreSQL client (psql) não encontrado!"
    echo "Instale o PostgreSQL client para continuar."
    exit 1
fi

# Executar o script SQL
echo "📝 Executando script SQL..."
psql -h $DB_HOST -p $DB_PORT -d $DB_NAME -U $DB_USER -f criar_usuario.sql

if [ $? -eq 0 ]; then
    echo "✅ Usuário criado com sucesso!"
    echo ""
    echo "🎯 CREDENCIAIS PARA ACESSO:"
    echo "   Login: admin"
    echo "   Senha: admin123"
    echo "   Tipo: Administrador"
    echo ""
    echo "🌐 PRÓXIMOS PASSOS:"
    echo "   1. Inicie o backend: cd backend && npm start"
    echo "   2. Inicie o frontend: cd frontend && npm start"
    echo "   3. Acesse: http://localhost:3000"
    echo "   4. Faça login com as credenciais acima"
    echo ""
    echo "🎉 Sistema pronto para uso!"
else
    echo "❌ Erro ao criar usuário!"
    echo "Verifique as configurações do banco de dados."
    exit 1
fi 