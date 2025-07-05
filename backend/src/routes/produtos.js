const express = require('express');
const ProdutosController = require('../controllers/produtosController');
const { authenticateToken } = require('../middleware/auth');

const router = express.Router();

// Todas as rotas requerem autenticação
router.use(authenticateToken);

// Listar produtos com paginação e filtros
router.get('/', ProdutosController.listarProdutos);

// Obter produto por ID
router.get('/:id', ProdutosController.obterProduto);

// Atualizar produto
router.put('/:id', ProdutosController.atualizarProduto);

// Obter estatísticas de produtos
router.get('/estatisticas/geral', ProdutosController.getEstatisticas);

// Buscar produtos (autocomplete)
router.get('/buscar/autocomplete', ProdutosController.buscarProdutos);

module.exports = router; 