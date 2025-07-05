const Auth = require('../models/Auth');
const { body, validationResult } = require('express-validator');

class AuthController {
  // Login
  static async login(req, res) {
    try {
      // Validar dados de entrada
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({
          success: false,
          message: 'Dados inválidos',
          errors: errors.array()
        });
      }

      const { username, password } = req.body;

      // Autenticar usuário
      const authResult = await Auth.authenticateUser(username, password);

      if (!authResult.success) {
        return res.status(401).json({
          success: false,
          message: authResult.message
        });
      }

      // Gerar token JWT
      const token = Auth.generateToken(authResult.user);

      // Salvar sessão no banco
      await Auth.saveSession(authResult.user.id, token);

      res.json({
        success: true,
        message: 'Login realizado com sucesso',
        data: {
          token,
          user: {
            id: authResult.user.id,
            cd_usuario: authResult.user.cd_usuario,
            nm_usuario: authResult.user.nm_usuario,
            nm_login: authResult.user.nm_login,
            tp_priv: authResult.user.tp_priv,
            cd_repres: authResult.user.cd_repres
          }
        }
      });
    } catch (error) {
      console.error('Erro no login:', error);
      res.status(500).json({
        success: false,
        message: 'Erro interno do servidor'
      });
    }
  }

  // Logout
  static async logout(req, res) {
    try {
      const authHeader = req.headers['authorization'];
      const token = authHeader && authHeader.split(' ')[1];

      if (token) {
        await Auth.logout(token);
      }

      res.json({
        success: true,
        message: 'Logout realizado com sucesso'
      });
    } catch (error) {
      console.error('Erro no logout:', error);
      res.status(500).json({
        success: false,
        message: 'Erro interno do servidor'
      });
    }
  }

  // Verificar token
  static async verifyToken(req, res) {
    try {
      res.json({
        success: true,
        message: 'Token válido',
        data: {
          user: req.user
        }
      });
    } catch (error) {
      console.error('Erro ao verificar token:', error);
      res.status(500).json({
        success: false,
        message: 'Erro interno do servidor'
      });
    }
  }

  // Obter perfil do usuário
  static async getProfile(req, res) {
    try {
      const userId = req.user.id;

      const query = `
        SELECT id, cd_usuario, nm_usuario, nm_login, tp_priv, cd_repres, 
               nm_repres, created_at
        FROM login_usuario 
        WHERE id = $1
      `;

      const result = await require('../config/database').query(query, [userId]);

      if (result.rows.length === 0) {
        return res.status(404).json({
          success: false,
          message: 'Usuário não encontrado'
        });
      }

      res.json({
        success: true,
        data: result.rows[0]
      });
    } catch (error) {
      console.error('Erro ao obter perfil:', error);
      res.status(500).json({
        success: false,
        message: 'Erro interno do servidor'
      });
    }
  }

  // Registrar novo usuário
  static async register(req, res) {
    try {
      // Validar dados de entrada
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({
          success: false,
          message: 'Dados inválidos',
          errors: errors.array()
        });
      }

      const {
        cd_usuario,
        nm_usuario,
        tp_priv,
        nm_login,
        nm_senha,
        cd_repres,
        nm_repres
      } = req.body;

      const db = require('../config/database');

      // Verificar se o login já existe
      const checkQuery = `
        SELECT id FROM login_usuario 
        WHERE nm_login = $1
      `;
      
      const checkResult = await db.query(checkQuery, [nm_login]);
      
      if (checkResult.rows.length > 0) {
        return res.status(409).json({
          success: false,
          message: 'Nome de usuário já existe'
        });
      }

      // Verificar se o código de usuário já existe
      const checkCdQuery = `
        SELECT id FROM login_usuario 
        WHERE cd_usuario = $1
      `;
      
      const checkCdResult = await db.query(checkCdQuery, [cd_usuario]);
      
      if (checkCdResult.rows.length > 0) {
        return res.status(409).json({
          success: false,
          message: 'Código de usuário já existe'
        });
      }

      // Inserir novo usuário
      const insertQuery = `
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
        ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
        RETURNING id, cd_usuario, nm_usuario, nm_login, tp_priv, cd_repres, nm_repres, created_at
      `;

      const currentDate = new Date().toLocaleDateString('pt-BR');
      
      const insertResult = await db.query(insertQuery, [
        cd_usuario,
        nm_usuario,
        tp_priv || 'V', // Padrão: Vendedor
        nm_login,
        nm_senha,
        'S', // Sincronizado
        currentDate,
        currentDate,
        cd_repres || 'REP001',
        nm_repres || nm_usuario,
        'S', // Sincronizado representante
        'A' // Ativo
      ]);

      const newUser = insertResult.rows[0];

      res.status(201).json({
        success: true,
        message: 'Usuário registrado com sucesso',
        data: {
          id: newUser.id,
          cd_usuario: newUser.cd_usuario,
          nm_usuario: newUser.nm_usuario,
          nm_login: newUser.nm_login,
          tp_priv: newUser.tp_priv,
          cd_repres: newUser.cd_repres,
          nm_repres: newUser.nm_repres,
          created_at: newUser.created_at
        }
      });
    } catch (error) {
      console.error('Erro ao registrar usuário:', error);
      res.status(500).json({
        success: false,
        message: 'Erro interno do servidor'
      });
    }
  }
}

// Validações para login
const loginValidation = [
  body('username')
    .notEmpty()
    .withMessage('Nome de usuário é obrigatório')
    .isLength({ min: 3 })
    .withMessage('Nome de usuário deve ter pelo menos 3 caracteres'),
  body('password')
    .notEmpty()
    .withMessage('Senha é obrigatória')
    .isLength({ min: 1 })
    .withMessage('Senha deve ter pelo menos 1 caractere')
];

// Validações para registro
const registerValidation = [
  body('cd_usuario')
    .notEmpty()
    .withMessage('Código do usuário é obrigatório')
    .isLength({ min: 3, max: 20 })
    .withMessage('Código do usuário deve ter entre 3 e 20 caracteres')
    .matches(/^[A-Z0-9]+$/)
    .withMessage('Código do usuário deve conter apenas letras maiúsculas e números'),
  
  body('nm_usuario')
    .notEmpty()
    .withMessage('Nome do usuário é obrigatório')
    .isLength({ min: 3, max: 100 })
    .withMessage('Nome do usuário deve ter entre 3 e 100 caracteres'),
  
  body('nm_login')
    .notEmpty()
    .withMessage('Nome de login é obrigatório')
    .isLength({ min: 3, max: 50 })
    .withMessage('Nome de login deve ter entre 3 e 50 caracteres')
    .matches(/^[a-zA-Z0-9._-]+$/)
    .withMessage('Nome de login deve conter apenas letras, números, pontos, hífens e underscores'),
  
  body('nm_senha')
    .notEmpty()
    .withMessage('Senha é obrigatória')
    .isLength({ min: 6, max: 50 })
    .withMessage('Senha deve ter entre 6 e 50 caracteres'),
  
  body('tp_priv')
    .optional()
    .isIn(['A', 'V', 'G'])
    .withMessage('Tipo de privilégio deve ser A (Administrador), V (Vendedor) ou G (Gerente)'),
  
  body('cd_repres')
    .optional()
    .isLength({ min: 3, max: 20 })
    .withMessage('Código do representante deve ter entre 3 e 20 caracteres'),
  
  body('nm_repres')
    .optional()
    .isLength({ min: 3, max: 100 })
    .withMessage('Nome do representante deve ter entre 3 e 100 caracteres')
];

module.exports = {
  AuthController,
  loginValidation,
  registerValidation
}; 