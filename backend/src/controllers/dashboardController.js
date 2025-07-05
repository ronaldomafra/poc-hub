const db = require('../config/database');

class DashboardController {
  // Obter estatísticas gerais do dashboard
  static async getEstatisticasGerais(req, res) {
    try {
      const queries = {
        // Estatísticas de Produtos
        totalProdutos: 'SELECT COUNT(*) as total FROM produtos',
        produtosAtivos: 'SELECT COUNT(*) as total FROM produtos WHERE id_status = \'A\'',
        produtosInativos: 'SELECT COUNT(*) as total FROM produtos WHERE id_status = \'I\'',
        
        // Estatísticas de Pedidos
        totalPedidos: 'SELECT COUNT(*) as total FROM consulta_pedido',
        pedidosHoje: `
          SELECT COUNT(*) as total 
          FROM consulta_pedido 
          WHERE dt_inclusao = TO_CHAR(CURRENT_DATE, 'YYYY-MM-DD')
        `,
        pedidosMes: `
          SELECT COUNT(*) as total 
          FROM consulta_pedido 
          WHERE dt_inclusao >= TO_CHAR(DATE_TRUNC('month', CURRENT_DATE), 'YYYY-MM-DD')
        `,
        valorTotalPedidos: `
          SELECT COALESCE(SUM(CAST(vl_pedido AS DECIMAL)), 0) as total 
          FROM consulta_pedido 
          WHERE vl_pedido IS NOT NULL AND vl_pedido != ''
        `,
        valorPedidosMes: `
          SELECT COALESCE(SUM(CAST(vl_pedido AS DECIMAL)), 0) as total 
          FROM consulta_pedido 
          WHERE dt_inclusao >= TO_CHAR(DATE_TRUNC('month', CURRENT_DATE), 'YYYY-MM-DD')
          AND vl_pedido IS NOT NULL AND vl_pedido != ''
        `,
        
        // Estatísticas de Clientes
        totalClientes: 'SELECT COUNT(*) as total FROM clientes',
        clientesAtivos: 'SELECT COUNT(*) as total FROM clientes WHERE id_status = \'A\'',
        
        // Estatísticas de Representantes
        totalRepresentantes: 'SELECT COUNT(*) as total FROM repres',
        representantesAtivos: 'SELECT COUNT(*) as total FROM repres WHERE id_status = \'A\'',
        
        // Pedidos por Status
        pedidosPorStatus: `
          SELECT id_status, COUNT(*) as total 
          FROM consulta_pedido 
          GROUP BY id_status 
          ORDER BY total DESC
        `,
        
        // Top 5 Clientes
        topClientes: `
          SELECT cp.cd_cliente, c.nm_cliente, c.nm_fantasia,
                 COUNT(*) as total_pedidos,
                 COALESCE(SUM(CAST(cp.vl_pedido AS DECIMAL)), 0) as valor_total
          FROM consulta_pedido cp
          LEFT JOIN clientes c ON cp.cd_cliente = c.cd_cliente
          GROUP BY cp.cd_cliente, c.nm_cliente, c.nm_fantasia
          ORDER BY valor_total DESC
          LIMIT 5
        `,
        
        // Top 5 Representantes
        topRepresentantes: `
          SELECT cp.cd_repres, r.nm_repres,
                 COUNT(*) as total_pedidos,
                 COALESCE(SUM(CAST(cp.vl_pedido AS DECIMAL)), 0) as valor_total
          FROM consulta_pedido cp
          LEFT JOIN repres r ON cp.cd_repres = r.cd_repres
          GROUP BY cp.cd_repres, r.nm_repres
          ORDER BY valor_total DESC
          LIMIT 5
        `,
        
        // Produtos mais vendidos
        produtosMaisVendidos: `
          SELECT cpi.cd_produto, p.nm_produto, p.ds_fabr,
                 COUNT(*) as total_pedidos,
                 SUM(CAST(cpi.nr_quantidade AS INTEGER)) as quantidade_total
          FROM consulta_pedido_itens cpi
          LEFT JOIN produtos p ON cpi.cd_produto = p.cd_produto
          GROUP BY cpi.cd_produto, p.nm_produto, p.ds_fabr
          ORDER BY quantidade_total DESC
          LIMIT 10
        `,
        
        // Vendas por mês (últimos 12 meses)
        vendasPorMes: `
          SELECT 
            TO_CHAR(DATE_TRUNC('month', CAST(dt_inclusao AS DATE)), 'YYYY-MM') as mes,
            COUNT(*) as total_pedidos,
            COALESCE(SUM(CAST(vl_pedido AS DECIMAL)), 0) as valor_total
          FROM consulta_pedido
          WHERE dt_inclusao >= TO_CHAR(CURRENT_DATE - INTERVAL '12 months', 'YYYY-MM-DD')
          GROUP BY TO_CHAR(DATE_TRUNC('month', CAST(dt_inclusao AS DATE)), 'YYYY-MM')
          ORDER BY mes DESC
          LIMIT 12
        `,
        
        // Pedidos recentes
        pedidosRecentes: `
          SELECT cp.id, cp.cd_pedido, cp.cd_cliente, cp.id_status, cp.vl_pedido,
                 cp.dt_inclusao, cp.hr_inclusao, c.nm_cliente, c.nm_fantasia
          FROM consulta_pedido cp
          LEFT JOIN clientes c ON cp.cd_cliente = c.cd_cliente
          ORDER BY cp.dt_inclusao DESC, cp.hr_inclusao DESC
          LIMIT 10
        `
      };

      const results = {};
      
      for (const [key, query] of Object.entries(queries)) {
        const result = await db.query(query);
        
        if (key.includes('Por') || key.includes('top') || key.includes('recentes') || key.includes('vendas')) {
          results[key] = result.rows;
        } else {
          results[key] = parseFloat(result.rows[0].total);
        }
      }

      res.json({
        success: true,
        data: results
      });
    } catch (error) {
      console.error('Erro ao obter estatísticas do dashboard:', error);
      res.status(500).json({
        success: false,
        message: 'Erro interno do servidor'
      });
    }
  }

  // Obter dados para gráficos
  static async getDadosGraficos(req, res) {
    try {
      const { tipo } = req.query;

      let query = '';
      let params = [];

      switch (tipo) {
        case 'vendas_mensal':
          query = `
            SELECT 
              TO_CHAR(DATE_TRUNC('month', CAST(dt_inclusao AS DATE)), 'YYYY-MM') as mes,
              COUNT(*) as total_pedidos,
              COALESCE(SUM(CAST(vl_pedido AS DECIMAL)), 0) as valor_total
            FROM consulta_pedido
            WHERE dt_inclusao >= TO_CHAR(CURRENT_DATE - INTERVAL '12 months', 'YYYY-MM-DD')
            GROUP BY TO_CHAR(DATE_TRUNC('month', CAST(dt_inclusao AS DATE)), 'YYYY-MM')
            ORDER BY mes ASC
          `;
          break;

        case 'pedidos_status':
          query = `
            SELECT id_status, COUNT(*) as total 
            FROM consulta_pedido 
            GROUP BY id_status 
            ORDER BY total DESC
          `;
          break;

        case 'produtos_grupo':
          query = `
            SELECT cd_grupo, COUNT(*) as total 
            FROM produtos 
            GROUP BY cd_grupo 
            ORDER BY total DESC 
            LIMIT 10
          `;
          break;

        case 'produtos_fabricante':
          query = `
            SELECT cd_fabr, COUNT(*) as total 
            FROM produtos 
            GROUP BY cd_fabr 
            ORDER BY total DESC 
            LIMIT 10
          `;
          break;

        default:
          return res.status(400).json({
            success: false,
            message: 'Tipo de gráfico não especificado'
          });
      }

      const result = await db.query(query, params);

      res.json({
        success: true,
        data: result.rows
      });
    } catch (error) {
      console.error('Erro ao obter dados para gráficos:', error);
      res.status(500).json({
        success: false,
        message: 'Erro interno do servidor'
      });
    }
  }

  // Obter alertas e notificações
  static async getAlertas(req, res) {
    try {
      const alertas = [];

      // Verificar produtos com estoque baixo (se houver campo de estoque)
      const produtosEstoqueBaixo = await db.query(`
        SELECT cd_produto, nm_produto, qtd_min
        FROM produtos 
        WHERE qtd_min IS NOT NULL AND qtd_min != ''
        LIMIT 5
      `);

      if (produtosEstoqueBaixo.rows.length > 0) {
        alertas.push({
          tipo: 'estoque',
          titulo: 'Produtos com estoque mínimo',
          descricao: `${produtosEstoqueBaixo.rows.length} produtos atingiram o estoque mínimo`,
          dados: produtosEstoqueBaixo.rows
        });
      }

      // Verificar pedidos pendentes
      const pedidosPendentes = await db.query(`
        SELECT COUNT(*) as total
        FROM consulta_pedido 
        WHERE id_status IN ('P', 'A') AND dt_inclusao = TO_CHAR(CURRENT_DATE, 'YYYY-MM-DD')
      `);

      const totalPendentes = parseInt(pedidosPendentes.rows[0].total);
      if (totalPendentes > 0) {
        alertas.push({
          tipo: 'pedidos',
          titulo: 'Pedidos pendentes',
          descricao: `${totalPendentes} pedidos pendentes hoje`,
          dados: { total: totalPendentes }
        });
      }

      // Verificar produtos inativos
      const produtosInativos = await db.query(`
        SELECT COUNT(*) as total
        FROM produtos 
        WHERE id_status = 'I'
      `);

      const totalInativos = parseInt(produtosInativos.rows[0].total);
      if (totalInativos > 0) {
        alertas.push({
          tipo: 'produtos',
          titulo: 'Produtos inativos',
          descricao: `${totalInativos} produtos estão inativos`,
          dados: { total: totalInativos }
        });
      }

      res.json({
        success: true,
        data: alertas
      });
    } catch (error) {
      console.error('Erro ao obter alertas:', error);
      res.status(500).json({
        success: false,
        message: 'Erro interno do servidor'
      });
    }
  }
}

module.exports = DashboardController; 