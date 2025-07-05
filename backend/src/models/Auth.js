const db = require('../config/database');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

class Auth {
  // Criar tabela de sessões se não existir
  static async createSessionsTable() {
    const query = `
      CREATE TABLE IF NOT EXISTS user_sessions (
        id SERIAL PRIMARY KEY,
        user_id INTEGER NOT NULL,
        token TEXT NOT NULL,
        expires_at TIMESTAMP NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
      
      CREATE INDEX IF NOT EXISTS idx_user_sessions_token ON user_sessions(token);
      CREATE INDEX IF NOT EXISTS idx_user_sessions_user_id ON user_sessions(user_id);
      CREATE INDEX IF NOT EXISTS idx_user_sessions_expires_at ON user_sessions(expires_at);
    `;
    
    try {
      await db.query(query);
      console.log('✅ Tabela de sessões criada/verificada');
    } catch (error) {
      console.error('❌ Erro ao criar tabela de sessões:', error);
    }
  }

  // Verificar credenciais do usuário
  static async authenticateUser(username, password) {
    try {
      // Buscar usuário na tabela login_usuario
      const query = `
        SELECT id, cd_usuario, nm_usuario, nm_login, nm_senha, tp_priv, cd_repres
        FROM login_usuario 
        WHERE nm_login = $1 AND id_status_repres = 'A'
      `;
      
      const result = await db.query(query, [username]);
      
      if (result.rows.length === 0) {
        return { success: false, message: 'Usuário não encontrado' };
      }

      const user = result.rows[0];
      
      // Verificar senha (assumindo que está em texto plano no banco)
      // Em produção, deveria estar criptografada
      if (user.nm_senha !== password) {
        return { success: false, message: 'Senha incorreta' };
      }

      return {
        success: true,
        user: {
          id: user.id,
          cd_usuario: user.cd_usuario,
          nm_usuario: user.nm_usuario,
          nm_login: user.nm_login,
          tp_priv: user.tp_priv,
          cd_repres: user.cd_repres
        }
      };
    } catch (error) {
      console.error('Erro na autenticação:', error);
      return { success: false, message: 'Erro interno do servidor' };
    }
  }

  // Gerar token JWT
  static generateToken(user) {
    return jwt.sign(
      {
        id: user.id,
        cd_usuario: user.cd_usuario,
        nm_usuario: user.nm_usuario,
        nm_login: user.nm_login,
        tp_priv: user.tp_priv,
        cd_repres: user.cd_repres
      },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN || '24h' }
    );
  }

  // Salvar sessão no banco
  static async saveSession(userId, token) {
    try {
      const expiresAt = new Date();
      expiresAt.setHours(expiresAt.getHours() + 24); // 24 horas

      // Primeiro, remover sessões existentes do usuário
      const deleteQuery = 'DELETE FROM user_sessions WHERE user_id = $1';
      await db.query(deleteQuery, [userId]);

      // Depois, inserir nova sessão
      const insertQuery = `
        INSERT INTO user_sessions (user_id, token, expires_at)
        VALUES ($1, $2, $3)
      `;

      await db.query(insertQuery, [userId, token, expiresAt]);
      console.log(`✅ Sessão salva para usuário ${userId}`);
      return true;
    } catch (error) {
      console.error('Erro ao salvar sessão:', error);
      return false;
    }
  }

  // Verificar token
  static async verifyToken(token) {
    try {
      // Verificar se o token existe na tabela de sessões
      const sessionQuery = `
        SELECT user_id, expires_at 
        FROM user_sessions 
        WHERE token = $1 AND expires_at > CURRENT_TIMESTAMP
      `;
      
      const sessionResult = await db.query(sessionQuery, [token]);
      
      if (sessionResult.rows.length === 0) {
        return { valid: false, message: 'Sessão expirada ou inválida' };
      }

      // Verificar JWT
      const decoded = jwt.verify(token, process.env.JWT_SECRET);
      
      return {
        valid: true,
        user: decoded
      };
    } catch (error) {
      if (error.name === 'JsonWebTokenError') {
        return { valid: false, message: 'Token inválido' };
      }
      if (error.name === 'TokenExpiredError') {
        return { valid: false, message: 'Token expirado' };
      }
      return { valid: false, message: 'Erro ao verificar token' };
    }
  }

  // Logout (remover sessão)
  static async logout(token) {
    try {
      const query = 'DELETE FROM user_sessions WHERE token = $1';
      await db.query(query, [token]);
      return true;
    } catch (error) {
      console.error('Erro ao fazer logout:', error);
      return false;
    }
  }

  // Limpar sessões expiradas
  static async cleanExpiredSessions() {
    try {
      const query = 'DELETE FROM user_sessions WHERE expires_at < CURRENT_TIMESTAMP';
      const result = await db.query(query);
      console.log(`🧹 ${result.rowCount} sessões expiradas removidas`);
    } catch (error) {
      console.error('Erro ao limpar sessões expiradas:', error);
    }
  }
}

module.exports = Auth; 