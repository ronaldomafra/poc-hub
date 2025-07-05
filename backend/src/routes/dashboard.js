const express = require('express');
const DashboardController = require('../controllers/dashboardController');
const { authenticateToken } = require('../middleware/auth');

const router = express.Router();

// Todas as rotas requerem autenticação
router.use(authenticateToken);

// Estatísticas gerais do dashboard
router.get('/estatisticas', DashboardController.getEstatisticasGerais);

// Dados para gráficos
router.get('/graficos', DashboardController.getDadosGraficos);

// Alertas e notificações
router.get('/alertas', DashboardController.getAlertas);

module.exports = router; 