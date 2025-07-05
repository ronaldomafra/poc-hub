# Frontend - POC Hub Testes

Frontend React para o sistema de gestão POC Hub Testes.

## 🚀 Tecnologias

- **React 18** - Biblioteca JavaScript para interfaces
- **React Router** - Roteamento
- **Tailwind CSS** - Framework CSS
- **Axios** - Cliente HTTP
- **React Hot Toast** - Notificações
- **Lucide React** - Ícones
- **Recharts** - Gráficos

## 📋 Pré-requisitos

- Node.js 16+
- npm ou yarn

## 🔧 Instalação

1. **Instalar dependências:**
```bash
npm install
```

2. **Configurar variáveis de ambiente (opcional):**
```bash
# Criar arquivo .env se necessário
REACT_APP_API_URL=http://localhost:3001
```

3. **Executar o servidor de desenvolvimento:**
```bash
npm start
```

O frontend estará disponível em `http://localhost:3000`

## 📚 Funcionalidades

### Autenticação
- Login com usuário e senha
- Autenticação JWT
- Proteção de rotas
- Logout automático

### Dashboard
- Estatísticas gerais
- Gráficos de vendas
- Gráficos de produtos por categoria
- Tendência de pedidos
- Alertas e notificações

### Produtos
- Listagem com paginação
- Busca e filtros
- Visualização de detalhes
- Status de produtos

### Pedidos
- Listagem com paginação
- Filtros por status e data
- Atualização de status
- Visualização de detalhes

## 🎨 Design System

### Cores
- **Primary**: Azul (#3b82f6)
- **Secondary**: Cinza (#64748b)
- **Success**: Verde (#10b981)
- **Warning**: Amarelo (#f59e0b)
- **Error**: Vermelho (#ef4444)

### Componentes
- Botões com variantes (primary, secondary, danger)
- Inputs com validação
- Cards com sombras
- Tabelas responsivas
- Modais e notificações

## 📱 Responsividade

O frontend é totalmente responsivo e funciona em:
- Desktop (1024px+)
- Tablet (768px - 1023px)
- Mobile (até 767px)

## 🔐 Segurança

- Interceptors para tokens JWT
- Redirecionamento automático para login
- Validação de rotas protegidas
- Sanitização de dados

## 🚀 Deploy

Para produção:

```bash
npm run build
```

Os arquivos otimizados estarão na pasta `build/`.

## 📞 Suporte

Para dúvidas ou problemas, consulte a documentação ou entre em contato com a equipe de desenvolvimento. 