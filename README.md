# POC Hub Testes - Sistema de Gestão

Sistema completo de gestão com backend Node.js/Express e frontend React.

## 🚀 Tecnologias

### Backend
- **Node.js** - Runtime JavaScript
- **Express.js** - Framework web
- **PostgreSQL** - Banco de dados
- **JWT** - Autenticação
- **bcryptjs** - Criptografia
- **Helmet** - Segurança
- **CORS** - Cross-origin resource sharing

### Frontend
- **React 18** - Biblioteca JavaScript para interfaces
- **React Router** - Roteamento
- **Tailwind CSS** - Framework CSS
- **Axios** - Cliente HTTP
- **React Hot Toast** - Notificações
- **Lucide React** - Ícones
- **Recharts** - Gráficos

## 📋 Pré-requisitos

- Node.js 16+
- PostgreSQL 12+
- npm ou yarn

## 🔧 Instalação

1. **Clonar o repositório:**
```bash
git clone <url-do-repositorio>
cd poc-hub-testes
```

2. **Instalar todas as dependências:**
```bash
npm run install:all
```

3. **Configurar banco de dados:**
```bash
# Executar o script de criação do banco
./executar_criar_usuario.sh
```

4. **Configurar variáveis de ambiente do backend:**
```bash
cd backend
cp env.example .env
# Editar o arquivo .env com suas configurações
```

5. **Executar o sistema completo:**
```bash
# Desenvolvimento (backend + frontend)
npm run dev

# Ou executar separadamente:
npm run dev:backend  # Backend na porta 3001
npm run dev:frontend # Frontend na porta 3000
```

## 📚 Funcionalidades

### Autenticação
- Login/logout com JWT
- Proteção de rotas
- Gerenciamento de sessões
- Perfil do usuário

### Dashboard
- Estatísticas gerais
- Gráficos de vendas
- Gráficos de produtos por categoria
- Tendência de pedidos
- Alertas e notificações

### Produtos
- CRUD completo
- Listagem com paginação
- Busca e filtros avançados
- Gestão de estoque
- Categorização

### Pedidos
- Gestão completa de pedidos
- Atualização de status
- Filtros por data e status
- Visualização de itens
- Histórico de pedidos

## 🌐 Endpoints da API

### Autenticação
- `POST /api/auth/login` - Login
- `POST /api/auth/logout` - Logout
- `GET /api/auth/verify` - Verificar token
- `GET /api/auth/profile` - Perfil do usuário

### Produtos
- `GET /api/produtos` - Listar produtos
- `GET /api/produtos/:id` - Obter produto
- `PUT /api/produtos/:id` - Atualizar produto
- `GET /api/produtos/estatisticas/geral` - Estatísticas
- `GET /api/produtos/buscar/autocomplete` - Busca

### Pedidos
- `GET /api/pedidos` - Listar pedidos
- `GET /api/pedidos/:id` - Obter pedido
- `PUT /api/pedidos/:id/status` - Atualizar status
- `GET /api/pedidos/estatisticas/geral` - Estatísticas
- `GET /api/pedidos/buscar/autocomplete` - Busca

### Dashboard
- `GET /api/dashboard/estatisticas` - Estatísticas gerais
- `GET /api/dashboard/graficos` - Dados para gráficos
- `GET /api/dashboard/alertas` - Alertas

## 🎨 Interface

### Design System
- Interface moderna e responsiva
- Design system consistente
- Componentes reutilizáveis
- Cores e tipografia padronizadas

### Responsividade
- Desktop (1024px+)
- Tablet (768px - 1023px)
- Mobile (até 767px)

## 🔐 Segurança

- Autenticação JWT
- Criptografia de senhas
- Headers de segurança (Helmet)
- Rate limiting
- Validação de dados
- CORS configurado

## 📊 Banco de Dados

### Tabelas Principais
- `login_usuario` - Usuários do sistema
- `produtos` - Catálogo de produtos
- `pedidos` - Pedidos dos clientes
- `pedido_itens` - Itens dos pedidos
- `sessoes` - Sessões ativas

## 🚀 Deploy

### Desenvolvimento
```bash
npm run dev
```

### Produção
```bash
# Backend
cd backend
npm start

# Frontend
cd frontend
npm run build
```

## 📁 Estrutura do Projeto

```
poc-hub-testes/
├── backend/                 # API Node.js/Express
│   ├── src/
│   │   ├── config/         # Configurações
│   │   ├── controllers/    # Controladores
│   │   ├── middleware/     # Middlewares
│   │   ├── models/         # Modelos
│   │   ├── routes/         # Rotas
│   │   └── server.js       # Servidor
│   ├── package.json
│   └── README.md
├── frontend/               # Aplicação React
│   ├── src/
│   │   ├── components/     # Componentes
│   │   ├── contexts/       # Contextos
│   │   ├── pages/          # Páginas
│   │   ├── utils/          # Utilitários
│   │   ├── App.js
│   │   └── index.js
│   ├── package.json
│   └── README.md
├── package.json            # Scripts principais
└── README.md
```

## 🧪 Testes

```bash
# Backend
cd backend
npm test

# Frontend
cd frontend
npm test
```

## 📈 Monitoramento

- Health check: `GET /health`
- Logs estruturados
- Métricas de performance
- Tratamento de erros

## 📞 Suporte

Para dúvidas ou problemas:
1. Consulte a documentação específica de cada módulo
2. Verifique os logs do sistema
3. Entre em contato com a equipe de desenvolvimento

## 📝 Licença

MIT License - veja o arquivo LICENSE para detalhes. 