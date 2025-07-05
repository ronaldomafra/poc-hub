-- =====================================================
-- SCRIPT PARA CRIAR USUÁRIO DE TESTE NO SISTEMA POC HUB
-- =====================================================

-- 1. Inserir usuário na tabela login_usuario (usada para autenticação)
INSERT INTO login_usuario (
    cd_usuario,
    nm_usuario,
    tp_priv,
    nm_login,
    nm_senha,
    sincronizado,
    dt_inclusao,
    dt_alteracao,
    cd_repres,
    nm_repres,
    sincronizado_repres,
    id_status_repres
) VALUES (
    'ADMIN001',
    'Administrador do Sistema',
    'A', -- A = Administrador
    'admin',
    'admin123',
    'S',
    TO_CHAR(CURRENT_DATE, 'DD/MM/YYYY'),
    TO_CHAR(CURRENT_DATE, 'DD/MM/YYYY'),
    'REP001',
    'Administrador Principal',
    'S',
    'A' -- A = Ativo
);

-- 2. Inserir usuário na tabela usuarios (tabela geral)
INSERT INTO usuarios (
    cd_usuario,
    nm_usuario,
    cd_repres,
    tp_priv,
    nm_login,
    nm_senha,
    sincronizado,
    dt_inclusao,
    dt_alteracao
) VALUES (
    'ADMIN001',
    'Administrador do Sistema',
    'REP001',
    'A',
    'admin',
    'admin123',
    'S',
    TO_CHAR(CURRENT_DATE, 'DD/MM/YYYY'),
    TO_CHAR(CURRENT_DATE, 'DD/MM/YYYY')
);

-- 3. Verificar se o usuário foi criado
SELECT 
    'Usuário criado com sucesso!' as status,
    id,
    cd_usuario,
    nm_usuario,
    tp_priv,
    nm_login,
    cd_repres,
    nm_repres,
    id_status_repres,
    created_at
FROM login_usuario 
WHERE nm_login = 'admin';

-- =====================================================
-- CREDENCIAIS PARA ACESSO:
-- =====================================================
-- Login: admin
-- Senha: admin123
-- Tipo: Administrador
-- Status: Ativo
-- =====================================================

-- 4. Verificar se a tabela user_sessions existe (criada automaticamente)
SELECT 
    'Tabela user_sessions existe' as status,
    COUNT(*) as total_sessoes
FROM user_sessions;

-- 5. Limpar sessões antigas (se houver)
DELETE FROM user_sessions WHERE expires_at < CURRENT_TIMESTAMP;

-- =====================================================
-- INSTRUÇÕES PARA USAR O SISTEMA:
-- =====================================================
-- 1. Execute este script no banco de dados PostgreSQL
-- 2. Inicie o backend: cd backend && npm start
-- 3. Inicie o frontend: cd frontend && npm start
-- 4. Acesse: http://localhost:3000
-- 5. Faça login com as credenciais acima
-- ===================================================== 