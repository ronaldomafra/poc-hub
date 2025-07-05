# Instruções para Testar o Sistema POC Hub Testes

## 🚀 Como Executar

### 1. Preparação do Ambiente

```bash
# Instalar todas as dependências
npm run install:all

# Configurar banco de dados (se necessário)
./executar_criar_usuario.sh
```

### 2. Configuração do Backend

```bash
cd backend
cp env.example .env
```

Editar o arquivo `.env` com suas configurações:
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

### 3. Executar o Sistema

#### Opção A: Executar Tudo Junto
```bash
npm run dev
```

#### Opção B: Executar Separadamente
```bash
# Terminal 1 - Backend
npm run dev:backend

# Terminal 2 - Frontend
npm run dev:frontend
```

## 🧪 Testando o Sistema

### Frontend (http://localhost:3000)

#### Login Mock (quando backend não está disponível)
- **Usuário**: `admin`
- **Senha**: `admin`

#### Funcionalidades Disponíveis

1. **Dashboard**
   - Estatísticas gerais
   - Gráficos de vendas
   - Gráficos de produtos por categoria
   - Tendência de pedidos
   - Alertas e notificações

2. **Produtos**
   - Listagem com dados mock
   - Filtros por categoria e status
   - Busca por nome/código
   - Visualização de detalhes

3. **Pedidos**
   - Listagem com dados mock
   - Filtros por status e data
   - Atualização de status (apenas visual)
   - Visualização de detalhes

### Backend (http://localhost:3001)

#### Health Check
```bash
curl http://localhost:3001/health
```

#### Endpoints Disponíveis
- `POST /api/auth/login` - Login
- `GET /api/produtos` - Listar produtos
- `GET /api/pedidos` - Listar pedidos
- `GET /api/dashboard/estatisticas` - Estatísticas

## 📊 Dados Mock Disponíveis

### Dashboard
- Estatísticas: 1250 produtos, 45 pedidos ativos, R$ 125.000 receita
- Gráficos: Vendas semanais, produtos por categoria, tendência de pedidos
- Alertas: Estoque baixo, erros de sistema, manutenção

### Produtos
- 5 produtos de exemplo com diferentes categorias
- Preços variados (R$ 29,99 a R$ 3.499,99)
- Status diferentes (ativo, pendente)

### Pedidos
- 5 pedidos de exemplo
- Status variados (pendente, aprovado, finalizado, cancelado)
- Valores de R$ 89,99 a R$ 3.499,99

## 🔧 Troubleshooting

### Frontend não carrega
```bash
cd frontend
npm install
npm start
```

### Backend não conecta
```bash
cd backend
npm install
npm run dev
```

### Erro de CORS
- Verificar se o backend está rodando na porta 3001
- Verificar configuração do CORS no backend

### Dados não aparecem
- Verificar console do navegador para erros
- Verificar se o backend está respondendo
- Os dados mock aparecem automaticamente se o backend não estiver disponível

## 📱 Responsividade

Teste em diferentes tamanhos de tela:
- **Desktop**: 1024px+
- **Tablet**: 768px - 1023px
- **Mobile**: até 767px

## 🎨 Funcionalidades da Interface

### Design System
- Cores consistentes (azul primário, cinza secundário)
- Tipografia Inter
- Componentes reutilizáveis
- Animações suaves

### Navegação
- Sidebar responsiva
- Menu mobile com hamburger
- Breadcrumbs automáticos
- Rotas protegidas

### Interações
- Loading states
- Toast notifications
- Formulários com validação
- Tabelas com paginação

## 🔐 Segurança

### Autenticação
- JWT tokens
- Rotas protegidas
- Logout automático
- Interceptors para tokens

### Validação
- Dados de entrada
- Sanitização
- Rate limiting (backend)

## 📈 Próximos Passos

1. **Conectar com Backend Real**
   - Configurar banco de dados
   - Implementar endpoints completos
   - Testar autenticação real

2. **Funcionalidades Adicionais**
   - CRUD completo de produtos
   - Gestão de pedidos
   - Relatórios avançados
   - Upload de imagens

3. **Melhorias**
   - Testes automatizados
   - CI/CD
   - Deploy em produção
   - Monitoramento

## 📞 Suporte

Se encontrar problemas:
1. Verificar logs do console
2. Verificar se todas as dependências estão instaladas
3. Verificar configurações de ambiente
4. Consultar documentação específica de cada módulo 