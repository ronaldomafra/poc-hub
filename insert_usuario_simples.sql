-- INSERT SIMPLES PARA CRIAR USUÁRIO ADMIN
INSERT INTO login_usuario (
    cd_usuario, nm_usuario, tp_priv, nm_login, nm_senha, 
    sincronizado, dt_inclusao, dt_alteracao, cd_repres, 
    nm_repres, sincronizado_repres, id_status_repres
) VALUES (
    'ADMIN001', 'Administrador', 'A', 'admin', 'admin123',
    'S', TO_CHAR(CURRENT_DATE, 'DD/MM/YYYY'), TO_CHAR(CURRENT_DATE, 'DD/MM/YYYY'),
    'REP001', 'Admin', 'S', 'A'
); 