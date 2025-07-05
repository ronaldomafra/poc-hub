const db = require('../config/database');

class ProdutosController {
  // Listar produtos com paginação e busca
  static async listarProdutos(req, res) {
    try {
      const { 
        page = 1, 
        limit = 10, 
        search = '', 
        cd_grupo = '',
        cd_fabr = '',
        id_status = ''
      } = req.query;

      const offset = (page - 1) * limit;
      
      // Construir query base
      let whereConditions = [];
      let queryParams = [];
      let paramIndex = 1;

      if (search) {
        whereConditions.push(`(nm_produto ILIKE $${paramIndex} OR cd_produto ILIKE $${paramIndex})`);
        queryParams.push(`%${search}%`);
        paramIndex++;
      }

      if (cd_grupo) {
        whereConditions.push(`cd_grupo = $${paramIndex}`);
        queryParams.push(cd_grupo);
        paramIndex++;
      }

      if (cd_fabr) {
        whereConditions.push(`cd_fabr = $${paramIndex}`);
        queryParams.push(cd_fabr);
        paramIndex++;
      }

      if (id_status) {
        whereConditions.push(`id_status = $${paramIndex}`);
        queryParams.push(id_status);
        paramIndex++;
      }

      const whereClause = whereConditions.length > 0 ? `WHERE ${whereConditions.join(' AND ')}` : '';

      // Query para contar total
      const countQuery = `
        SELECT COUNT(*) as total 
        FROM produtos 
        ${whereClause}
      `;
      
      const countResult = await db.query(countQuery, queryParams);
      const total = parseInt(countResult.rows[0].total);

      // Query para buscar produtos
      const produtosQuery = `
        SELECT 
          id, cd_produto, nm_produto, ds_imagem1, ds_imagem2, ds_imagem3, ds_imagem4,
          cd_fabr, ds_fabr, cd_grupo, cd_grupo_loja, dt_inclusao, dt_alteracao,
          id_status, cd_trib, vl_venda, vl_lista, vl_liquido, cd_barras,
          per_ipi, cd_ncm, qtd_min, vl_redu, vl_redudema, id_quinz,
          pc_desc_tab, pc_desc_av, pc_desc_adic, tpp_produto, created_at, updated_at
        FROM produtos 
        ${whereClause}
        ORDER BY nm_produto ASC
        LIMIT $${paramIndex} OFFSET $${paramIndex + 1}
      `;

      queryParams.push(limit, offset);
      const produtosResult = await db.query(produtosQuery, queryParams);

      const totalPages = Math.ceil(total / limit);

      res.json({
        success: true,
        data: {
          produtos: produtosResult.rows,
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
      console.error('Erro ao listar produtos:', error);
      res.status(500).json({
        success: false,
        message: 'Erro interno do servidor'
      });
    }
  }

  // Obter produto por ID
  static async obterProduto(req, res) {
    try {
      const { id } = req.params;

      const query = `
        SELECT 
          id, cd_produto, nm_produto, ds_imagem1, ds_imagem2, ds_imagem3, ds_imagem4,
          cd_fabr, ds_fabr, cd_grupo, cd_grupo_loja, dt_inclusao, dt_alteracao,
          id_status, cd_trib, vl_venda, vl_lista, vl_liquido, cd_barras,
          per_ipi, cd_ncm, qtd_min, vl_redu, vl_redudema, id_quinz,
          pc_desc_tab, pc_desc_av, pc_desc_adic, tpp_produto, created_at, updated_at
        FROM produtos 
        WHERE id = $1
      `;

      const result = await db.query(query, [id]);

      if (result.rows.length === 0) {
        return res.status(404).json({
          success: false,
          message: 'Produto não encontrado'
        });
      }

      res.json({
        success: true,
        data: result.rows[0]
      });
    } catch (error) {
      console.error('Erro ao obter produto:', error);
      res.status(500).json({
        success: false,
        message: 'Erro interno do servidor'
      });
    }
  }

  // Atualizar produto
  static async atualizarProduto(req, res) {
    try {
      const { id } = req.params;
      const updateData = req.body;

      // Campos permitidos para atualização
      const allowedFields = [
        'nm_produto', 'vl_venda', 'vl_lista', 'vl_liquido', 'id_status',
        'cd_trib', 'per_ipi', 'cd_ncm', 'qtd_min', 'vl_redu', 'vl_redudema'
      ];

      const fieldsToUpdate = [];
      const values = [];
      let paramIndex = 1;

      allowedFields.forEach(field => {
        if (updateData[field] !== undefined) {
          fieldsToUpdate.push(`${field} = $${paramIndex}`);
          values.push(updateData[field]);
          paramIndex++;
        }
      });

      if (fieldsToUpdate.length === 0) {
        return res.status(400).json({
          success: false,
          message: 'Nenhum campo válido para atualização'
        });
      }

      values.push(id);
      const query = `
        UPDATE produtos 
        SET ${fieldsToUpdate.join(', ')}, updated_at = CURRENT_TIMESTAMP
        WHERE id = $${paramIndex}
        RETURNING *
      `;

      const result = await db.query(query, values);

      if (result.rows.length === 0) {
        return res.status(404).json({
          success: false,
          message: 'Produto não encontrado'
        });
      }

      res.json({
        success: true,
        message: 'Produto atualizado com sucesso',
        data: result.rows[0]
      });
    } catch (error) {
      console.error('Erro ao atualizar produto:', error);
      res.status(500).json({
        success: false,
        message: 'Erro interno do servidor'
      });
    }
  }

  // Obter estatísticas de produtos
  static async getEstatisticas(req, res) {
    try {
      const queries = {
        total: 'SELECT COUNT(*) as total FROM produtos',
        ativos: 'SELECT COUNT(*) as total FROM produtos WHERE id_status = \'A\'',
        inativos: 'SELECT COUNT(*) as total FROM produtos WHERE id_status = \'I\'',
        porGrupo: `
          SELECT cd_grupo, COUNT(*) as total 
          FROM produtos 
          GROUP BY cd_grupo 
          ORDER BY total DESC 
          LIMIT 10
        `,
        porFabricante: `
          SELECT cd_fabr, COUNT(*) as total 
          FROM produtos 
          GROUP BY cd_fabr 
          ORDER BY total DESC 
          LIMIT 10
        `
      };

      const results = {};
      
      for (const [key, query] of Object.entries(queries)) {
        const result = await db.query(query);
        results[key] = key.includes('por') ? result.rows : parseInt(result.rows[0].total);
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

  // Buscar produtos por código ou nome
  static async buscarProdutos(req, res) {
    try {
      const { q } = req.query;

      if (!q || q.length < 2) {
        return res.status(400).json({
          success: false,
          message: 'Termo de busca deve ter pelo menos 2 caracteres'
        });
      }

      const query = `
        SELECT id, cd_produto, nm_produto, vl_venda, vl_lista, id_status
        FROM produtos 
        WHERE nm_produto ILIKE $1 OR cd_produto ILIKE $1
        ORDER BY nm_produto ASC
        LIMIT 20
      `;

      const result = await db.query(query, [`%${q}%`]);

      res.json({
        success: true,
        data: result.rows
      });
    } catch (error) {
      console.error('Erro ao buscar produtos:', error);
      res.status(500).json({
        success: false,
        message: 'Erro interno do servidor'
      });
    }
  }
}

module.exports = ProdutosController; 