const express = require('express');
const { AuthController, loginValidation, registerValidation } = require('../controllers/authController');
const { authenticateToken } = require('../middleware/auth');

const router = express.Router();

// Login
router.post('/login', loginValidation, AuthController.login);

// Registrar novo usuário
router.post('/register', registerValidation, AuthController.register);

// Logout (requer autenticação)
router.post('/logout', authenticateToken, AuthController.logout);

// Verificar token
router.get('/verify', authenticateToken, AuthController.verifyToken);

// Obter perfil do usuário
router.get('/profile', authenticateToken, AuthController.getProfile);

module.exports = router; 