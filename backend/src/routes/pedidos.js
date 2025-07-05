const express = require('express');
const PedidosController = require('../controllers/pedidosController');
const { authenticateToken } = require('../middleware/auth');

const router = express.Router();

// Todas as rotas requerem autenticação
router.use(authenticateToken);

// Listar pedidos com paginação e filtros
router.get('/', PedidosController.listarPedidos);

// Obter pedido por ID com itens
router.get('/:id', PedidosController.obterPedido);

// Atualizar status do pedido
router.put('/:id/status', PedidosController.atualizarStatusPedido);

// Obter estatísticas de pedidos
router.get('/estatisticas/geral', PedidosController.getEstatisticas);

// Buscar pedidos (autocomplete)
router.get('/buscar/autocomplete', PedidosController.buscarPedidos);

module.exports = router; 