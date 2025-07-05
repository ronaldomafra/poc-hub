# Backend API - Sistema de Gestão

API REST para sistema de gestão de vendas, produtos e pedidos.

## 🚀 Tecnologias

- **Node.js** - Runtime JavaScript
- **Express.js** - Framework web
- **PostgreSQL** - Banco de dados
- **JWT** - Autenticação
- **bcryptjs** - Criptografia
- **Helmet** - Segurança
- **CORS** - Cross-origin resource sharing

## 📋 Pré-requisitos

- Node.js 16+
- PostgreSQL 12+
- npm ou yarn

## 🔧 Instalação

1. **Instalar dependências:**
```bash
npm install
```

2. **Configurar variáveis de ambiente:**
```bash
cp env.example .env
```

Edite o arquivo `.env` com suas configurações:
```env
# Configurações do Banco de Dados
DB_HOST=localhost
DB_PORT=5432
DB_NAME=poc_mcp_system
DB_USER=poc_mcp_system
DB_PASSWORD=sua_senha_aqui

# Configurações do JWT
JWT_SECRET=sua_chave_secreta_jwt_aqui_muito_segura
JWT_EXPIRES_IN=24h

# Configurações do Servidor
PORT=3001
NODE_ENV=development
```

3. **Executar o servidor:**
```bash
# Desenvolvimento
npm run dev

# Produção
npm start
```

## 📚 Endpoints da API

### Autenticação

- `POST /api/auth/login` - Login do usuário
- `POST /api/auth/logout` - Logout (requer token)
- `GET /api/auth/verify` - Verificar token
- `GET /api/auth/profile` - Perfil do usuário

### Produtos

- `GET /api/produtos` - Listar produtos (com paginação e filtros)
- `GET /api/produtos/:id` - Obter produto por ID
- `PUT /api/produtos/:id` - Atualizar produto
- `GET /api/produtos/estatisticas/geral` - Estatísticas de produtos
- `GET /api/produtos/buscar/autocomplete` - Buscar produtos

### Pedidos

- `GET /api/pedidos` - Listar pedidos (com paginação e filtros)
- `GET /api/pedidos/:id` - Obter pedido por ID com itens
- `PUT /api/pedidos/:id/status` - Atualizar status do pedido
- `GET /api/pedidos/estatisticas/geral` - Estatísticas de pedidos
- `GET /api/pedidos/buscar/autocomplete` - Buscar pedidos

### Dashboard

- `GET /api/dashboard/estatisticas` - Estatísticas gerais
- `GET /api/dashboard/graficos` - Dados para gráficos
- `GET /api/dashboard/alertas` - Alertas e notificações

## 🔐 Autenticação

A API utiliza JWT (JSON Web Tokens) para autenticação. Para acessar rotas protegidas, inclua o token no header:

```
Authorization: Bearer <seu_token_jwt>
```

## 📊 Estrutura do Projeto

```
src/
├── config/
│   └── database.js          # Configuração do banco
├── controllers/
│   ├── authController.js    # Controller de autenticação
│   ├── produtosController.js # Controller de produtos
│   ├── pedidosController.js  # Controller de pedidos
│   └── dashboardController.js # Controller do dashboard
├── middleware/
│   └── auth.js              # Middleware de autenticação
├── models/
│   └── Auth.js              # Modelo de autenticação
├── routes/
│   ├── auth.js              # Rotas de autenticação
│   ├── produtos.js          # Rotas de produtos
│   ├── pedidos.js           # Rotas de pedidos
│   └── dashboard.js         # Rotas do dashboard
└── server.js                # Servidor principal
```

## 🛡️ Segurança

- **Helmet** - Headers de segurança
- **CORS** - Configurado para desenvolvimento e produção
- **Rate Limiting** - Limite de requisições por IP
- **JWT** - Autenticação segura
- **Validação** - Validação de dados de entrada
- **Compressão** - Respostas comprimidas

## 📝 Logs

O servidor utiliza Morgan para logging. Os logs incluem:
- Requisições HTTP
- Erros de autenticação
- Erros de banco de dados
- Sessões expiradas

## 🔄 Sessões

- Sessões são armazenadas no banco de dados
- Expiração automática após 24 horas
- Limpeza automática de sessões expiradas

## 🧪 Testes

```bash
npm test
```

## 📈 Monitoramento

- Health check: `GET /health`
- Métricas de performance
- Logs estruturados

## 🚀 Deploy

Para produção:

1. Configure as variáveis de ambiente
2. Execute `npm start`
3. Use um process manager como PM2
4. Configure um proxy reverso (nginx)

## 📞 Suporte

Para dúvidas ou problemas, consulte a documentação ou entre em contato com a equipe de desenvolvimento. 