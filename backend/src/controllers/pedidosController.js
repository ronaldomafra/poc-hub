const db = require('../config/database');

class PedidosController {
  // Listar pedidos com paginação e busca
  static async listarPedidos(req, res) {
    try {
      const { 
        page = 1, 
        limit = 10, 
        search = '', 
        cd_cliente = '',
        cd_repres = '',
        id_status = '',
        dt_inclusao_inicio = '',
        dt_inclusao_fim = ''
      } = req.query;

      const offset = (page - 1) * limit;
      
      // Construir query base
      let whereConditions = [];
      let queryParams = [];
      let paramIndex = 1;

      if (search) {
        whereConditions.push(`cd_pedido ILIKE $${paramIndex}`);
        queryParams.push(`%${search}%`);
        paramIndex++;
      }

      if (cd_cliente) {
        whereConditions.push(`cd_cliente = $${paramIndex}`);
        queryParams.push(cd_cliente);
        paramIndex++;
      }

      if (cd_repres) {
        whereConditions.push(`cd_repres = $${paramIndex}`);
        queryParams.push(cd_repres);
        paramIndex++;
      }

      if (id_status) {
        whereConditions.push(`id_status = $${paramIndex}`);
        queryParams.push(id_status);
        paramIndex++;
      }

      if (dt_inclusao_inicio) {
        whereConditions.push(`dt_inclusao >= $${paramIndex}`);
        queryParams.push(dt_inclusao_inicio);
        paramIndex++;
      }

      if (dt_inclusao_fim) {
        whereConditions.push(`dt_inclusao <= $${paramIndex}`);
        queryParams.push(dt_inclusao_fim);
        paramIndex++;
      }

      const whereClause = whereConditions.length > 0 ? `WHERE ${whereConditions.join(' AND ')}` : '';

      // Query para contar total
      const countQuery = `
        SELECT COUNT(*) as total 
        FROM consulta_pedido 
        ${whereClause}
      `;
      
      const countResult = await db.query(countQuery, queryParams);
      const total = parseInt(countResult.rows[0].total);

      // Query para buscar pedidos com dados do cliente
      const pedidosQuery = `
        SELECT 
          cp.id, cp.cd_pedido, cp.cd_cliente, cp.cd_repres, cp.id_status,
          cp.dt_alteracao, cp.hr_alteracao, cp.vl_pedido, cp.dt_envio,
          cp.dt_inclusao, cp.hr_inclusao, cp.dt_aprova, cp.dt_canc,
          cp.tip_ped, cp.dt_envio_bosch, cp.mensagem, cp.dt_fatu,
          cp.obs_pagto, cp.cd_pagto, cp.cd_usu_atual, cp.created_at, cp.updated_at,
          c.nm_cliente, c.nm_fantasia, c.nr_documento,
          r.nm_repres
        FROM consulta_pedido cp
        LEFT JOIN clientes c ON cp.cd_cliente = c.cd_cliente
        LEFT JOIN repres r ON cp.cd_repres = r.cd_repres
        ${whereClause}
        ORDER BY cp.dt_inclusao DESC, cp.hr_inclusao DESC
        LIMIT $${paramIndex} OFFSET $${paramIndex + 1}
      `;

      queryParams.push(limit, offset);
      const pedidosResult = await db.query(pedidosQuery, queryParams);

      const totalPages = Math.ceil(total / limit);

      res.json({
        success: true,
        data: {
          pedidos: pedidosResult.rows,
          pagination: {
            page: parseInt(page),
            limit: parseInt(limit),
            total,
            totalPages,
            hasNext: page < totalPages,
            hasPrev: page > 1
          }
        }
      });
    } catch (error) {
      console.error('Erro ao listar pedidos:', error);
      res.status(500).json({
        success: false,
        message: 'Erro interno do servidor'
      });
    }
  }

  // Obter pedido por ID com itens
  static async obterPedido(req, res) {
    try {
      const { id } = req.params;

      // Buscar dados do pedido
      const pedidoQuery = `
        SELECT 
          cp.id, cp.cd_pedido, cp.cd_cliente, cp.cd_repres, cp.id_status,
          cp.dt_alteracao, cp.hr_alteracao, cp.vl_pedido, cp.dt_envio,
          cp.dt_inclusao, cp.hr_inclusao, cp.dt_aprova, cp.dt_canc,
          cp.tip_ped, cp.dt_envio_bosch, cp.mensagem, cp.dt_fatu,
          cp.obs_pagto, cp.cd_pagto, cp.cd_usu_atual, cp.created_at, cp.updated_at,
          c.nm_cliente, c.nm_fantasia, c.nr_documento, c.nm_email, c.nr_telefone,
          r.nm_repres
        FROM consulta_pedido cp
        LEFT JOIN clientes c ON cp.cd_cliente = c.cd_cliente
        LEFT JOIN repres r ON cp.cd_repres = r.cd_repres
        WHERE cp.id = $1
      `;

      const pedidoResult = await db.query(pedidoQuery, [id]);

      if (pedidoResult.rows.length === 0) {
        return res.status(404).json({
          success: false,
          message: 'Pedido não encontrado'
        });
      }

      const pedido = pedidoResult.rows[0];

      // Buscar itens do pedido
      const itensQuery = `
        SELECT 
          cpi.id, cpi.cd_pedido, cpi.cd_repres, cpi.cd_produto,
          cpi.desc_neg, cpi.tp_produto, cpi.cd_combo, cpi.nr_quantidade,
          cpi.nr_qtd_ant, cpi.vl_venda_pedido, cpi.vl_venda_pedido_sesp,
          cpi.vl_venda_pedido_sfreud, cpi.vl_icms_st, cpi.nr_qt_irmaos,
          cpi.op_preco, cpi.cd_grupdesc, cpi.cd_gruposel, cpi.cd_gruporede,
          cpi.uso_sele, cpi.uso_rede, cpi.vl_liquido, cpi.pc_desc_class_cli,
          cpi.cd_dc, cpi.pc_desc_avista, cpi.vl_lista, cpi.vl_desc_class_cli,
          cpi.vl_desc_avista, cpi.pc_desc_tabela, cpi.vl_desc_tabela,
          cpi.pc_desc_adicional, cpi.vl_desc_adicional, cpi.pc_desc_lq,
          cpi.vl_desc_lq, cpi.pc_desc_lqpl, cpi.vl_desc_lqpl, cpi.pc_desc_qt,
          cpi.vl_desc_qt, cpi.pc_desc_ad_cli_a, cpi.vl_desc_ad_cli_a,
          cpi.pc_desc_ad_cli_aa, cpi.vl_desc_ad_cli_aa, cpi.pc_desc_prog,
          cpi.vl_desc_prog, cpi.pc_desc_est, cpi.vl_desc_est, cpi.pc_desc_esp,
          cpi.vl_desc_esp, cpi.pc_desc_combo, cpi.vl_desc_combo, cpi.pc_desc_freud,
          cpi.vl_desc_freud, cpi.vl_desc_neg, cpi.vl_base, cpi.pc_icms,
          cpi.vl_icms, cpi.vl_base_ipi, cpi.pc_ipi, cpi.vl_ipi, cpi.vl_base_st,
          cpi.pc_mva, cpi.pc_icms_int, cpi.vl_icms_subs, cpi.vl_precosuframa,
          cpi.pc_ipi_suframa, cpi.vl_ipi_suframa, cpi.pc_icms_suframa,
          cpi.vl_icms_suframa, cpi.vl_piscofins_suframa, cpi.pc_piscofins_suframa,
          cpi.vl_liqlista_suframa, cpi.pc_redu_sp, cpi.vl_redu_sp, cpi.pc_red,
          cpi.vl_red, cpi.vl_mva, cpi.leg, cpi.pr_negociado, cpi.negociado1,
          cpi.negociado2, cpi.negociado3, cpi.dt_log, cpi.hr_log, cpi.qt_cancelada,
          cpi.op_cancelado, cpi.dt_cancelado, cpi.pc_desc_extra, cpi.vl_desc_extra,
          cpi.cd_grupomadeira, cpi.uso_madeira, cpi.created_at, cpi.updated_at,
          p.nm_produto, p.ds_fabr, p.cd_barras
        FROM consulta_pedido_itens cpi
        LEFT JOIN produtos p ON cpi.cd_produto = p.cd_produto
        WHERE cpi.cd_pedido = $1
        ORDER BY cpi.id ASC
      `;

      const itensResult = await db.query(itensQuery, [pedido.cd_pedido]);

      res.json({
        success: true,
        data: {
          pedido,
          itens: itensResult.rows
        }
      });
    } catch (error) {
      console.error('Erro ao obter pedido:', error);
      res.status(500).json({
        success: false,
        message: 'Erro interno do servidor'
      });
    }
  }

  // Atualizar status do pedido
  static async atualizarStatusPedido(req, res) {
    try {
      const { id } = req.params;
      const { id_status, mensagem } = req.body;

      if (!id_status) {
        return res.status(400).json({
          success: false,
          message: 'Status é obrigatório'
        });
      }

      const query = `
        UPDATE consulta_pedido 
        SET id_status = $1, 
            mensagem = $2,
            dt_alteracao = CURRENT_DATE,
            hr_alteracao = CURRENT_TIME,
            updated_at = CURRENT_TIMESTAMP
        WHERE id = $3
        RETURNING *
      `;

      const result = await db.query(query, [id_status, mensagem, id]);

      if (result.rows.length === 0) {
        return res.status(404).json({
          success: false,
          message: 'Pedido não encontrado'
        });
      }

      res.json({
        success: true,
        message: 'Status do pedido atualizado com sucesso',
        data: result.rows[0]
      });
    } catch (error) {
      console.error('Erro ao atualizar status do pedido:', error);
      res.status(500).json({
        success: false,
        message: 'Erro interno do servidor'
      });
    }
  }

  // Obter estatísticas de pedidos
  static async getEstatisticas(req, res) {
    try {
      const queries = {
        total: 'SELECT COUNT(*) as total FROM consulta_pedido',
        porStatus: `
          SELECT id_status, COUNT(*) as total 
          FROM consulta_pedido 
          GROUP BY id_status 
          ORDER BY total DESC
        `,
        valorTotal: 'SELECT COALESCE(SUM(CAST(vl_pedido AS DECIMAL)), 0) as total FROM consulta_pedido WHERE vl_pedido IS NOT NULL',
        pedidosHoje: `
          SELECT COUNT(*) as total 
          FROM consulta_pedido 
          WHERE dt_inclusao = CURRENT_DATE
        `,
        pedidosMes: `
          SELECT COUNT(*) as total 
          FROM consulta_pedido 
          WHERE dt_inclusao >= DATE_TRUNC('month', CURRENT_DATE)
        `,
        topClientes: `
          SELECT cp.cd_cliente, c.nm_cliente, COUNT(*) as total_pedidos,
                 COALESCE(SUM(CAST(cp.vl_pedido AS DECIMAL)), 0) as valor_total
          FROM consulta_pedido cp
          LEFT JOIN clientes c ON cp.cd_cliente = c.cd_cliente
          GROUP BY cp.cd_cliente, c.nm_cliente
          ORDER BY total_pedidos DESC
          LIMIT 10
        `,
        topRepresentantes: `
          SELECT cp.cd_repres, r.nm_repres, COUNT(*) as total_pedidos,
                 COALESCE(SUM(CAST(cp.vl_pedido AS DECIMAL)), 0) as valor_total
          FROM consulta_pedido cp
          LEFT JOIN repres r ON cp.cd_repres = r.cd_repres
          GROUP BY cp.cd_repres, r.nm_repres
          ORDER BY total_pedidos DESC
          LIMIT 10
        `
      };

      const results = {};
      
      for (const [key, query] of Object.entries(queries)) {
        const result = await db.query(query);
        results[key] = key.includes('por') || key.includes('top') ? result.rows : parseFloat(result.rows[0].total);
      }

      res.json({
        success: true,
        data: results
      });
    } catch (error) {
      console.error('Erro ao obter estatísticas:', error);
      res.status(500).json({
        success: false,
        message: 'Erro interno do servidor'
      });
    }
  }

  // Buscar pedidos por código
  static async buscarPedidos(req, res) {
    try {
      const { q } = req.query;

      if (!q || q.length < 2) {
        return res.status(400).json({
          success: false,
          message: 'Termo de busca deve ter pelo menos 2 caracteres'
        });
      }

      const query = `
        SELECT cp.id, cp.cd_pedido, cp.cd_cliente, cp.id_status, cp.vl_pedido,
               cp.dt_inclusao, cp.hr_inclusao, c.nm_cliente, c.nm_fantasia
        FROM consulta_pedido cp
        LEFT JOIN clientes c ON cp.cd_cliente = c.cd_cliente
        WHERE cp.cd_pedido ILIKE $1 OR c.nm_cliente ILIKE $1 OR c.nm_fantasia ILIKE $1
        ORDER BY cp.dt_inclusao DESC
        LIMIT 20
      `;

      const result = await db.query(query, [`%${q}%`]);

      res.json({
        success: true,
        data: result.rows
      });
    } catch (error) {
      console.error('Erro ao buscar pedidos:', error);
      res.status(500).json({
        success: false,
        message: 'Erro interno do servidor'
      });
    }
  }
}

module.exports = PedidosController; 