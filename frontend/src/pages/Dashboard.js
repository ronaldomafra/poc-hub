import React, { useState, useEffect } from 'react';
import { 
  Package, 
  ShoppingCart, 
  TrendingUp, 
  DollarSign,
  Users,
  AlertTriangle
} from 'lucide-react';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, LineChart, Line, PieChart, Pie, Cell } from 'recharts';
import api from '../utils/api';
import toast from 'react-hot-toast';

const Dashboard = () => {
  const [stats, setStats] = useState(null);
  const [chartData, setChartData] = useState(null);
  const [alerts, setAlerts] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadDashboardData();
  }, []);

  const loadDashboardData = async () => {
    try {
      setLoading(true);
      
      // Carregar dados do backend
      const statsResponse = await api.get('/api/dashboard/estatisticas');
      setStats(statsResponse.data.data);
      
      // Carregar dados de gráficos - vendas mensais
      const chartsResponse = await api.get('/api/dashboard/graficos?tipo=vendas_mensal');
      setChartData(chartsResponse.data.data);
      
      const alertsResponse = await api.get('/api/dashboard/alertas');
      setAlerts(alertsResponse.data.data);
      
    } catch (error) {
      console.error('Erro ao carregar dashboard:', error);
      toast.error('Erro ao carregar dados do dashboard');
      
      // Definir dados vazios em caso de erro
      setStats({
        totalProdutos: 0,
        pedidosAtivos: 0,
        receitaMensal: 0,
        usuariosAtivos: 0
      });
      setChartData([]);
      setAlerts([]);
    } finally {
      setLoading(false);
    }
  };

  const StatCard = ({ title, value, icon: Icon, color, change }) => (
    <div className="card p-6">
      <div className="flex items-center">
        <div className={`p-3 rounded-lg ${color}`}>
          <Icon className="h-6 w-6 text-white" />
        </div>
        <div className="ml-4">
          <p className="text-sm font-medium text-gray-600">{title}</p>
          <p className="text-2xl font-semibold text-gray-900">{value}</p>
          {change && (
            <p className={`text-sm ${change > 0 ? 'text-green-600' : 'text-red-600'}`}>
              {change > 0 ? '+' : ''}{change}% em relação ao mês anterior
            </p>
          )}
        </div>
      </div>
    </div>
  );

  const AlertCard = ({ alert }) => (
    <div className={`p-4 rounded-lg border-l-4 ${
      alert.tipo === 'estoque' ? 'bg-red-50 border-red-400' :
      alert.tipo === 'pedidos' ? 'bg-yellow-50 border-yellow-400' :
      'bg-blue-50 border-blue-400'
    }`}>
      <div className="flex">
        <AlertTriangle className={`h-5 w-5 ${
          alert.tipo === 'estoque' ? 'text-red-400' :
          alert.tipo === 'pedidos' ? 'text-yellow-400' :
          'text-blue-400'
        }`} />
        <div className="ml-3">
          <h3 className="text-sm font-medium text-gray-900">{alert.titulo}</h3>
          <p className="text-sm text-gray-600">{alert.descricao}</p>
        </div>
      </div>
    </div>
  );

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"></div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Dashboard</h1>
        <p className="text-gray-600">Visão geral do sistema</p>
      </div>

      {/* Cards de estatísticas */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <StatCard
          title="Total de Produtos"
          value={stats?.totalProdutos || 0}
          icon={Package}
          color="bg-blue-500"
        />
        <StatCard
          title="Pedidos Ativos"
          value={stats?.pedidosAtivos || 0}
          icon={ShoppingCart}
          color="bg-green-500"
        />
        <StatCard
          title="Receita Mensal"
          value={`R$ ${(stats?.valorPedidosMes || 0).toLocaleString()}`}
          icon={DollarSign}
          color="bg-purple-500"
        />
        <StatCard
          title="Clientes Ativos"
          value={stats?.clientesAtivos || 0}
          icon={Users}
          color="bg-orange-500"
        />
      </div>

      {/* Gráficos */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Gráfico de vendas mensais */}
        <div className="card p-6">
          <h3 className="text-lg font-semibold text-gray-900 mb-4">Vendas dos Últimos 12 Meses</h3>
          <ResponsiveContainer width="100%" height={300}>
            <BarChart data={chartData || []}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="mes" />
              <YAxis />
              <Tooltip />
              <Bar dataKey="valor_total" fill="#3b82f6" />
            </BarChart>
          </ResponsiveContainer>
        </div>

        {/* Gráfico de pedidos por status */}
        <div className="card p-6">
          <h3 className="text-lg font-semibold text-gray-900 mb-4">Pedidos por Status</h3>
          <ResponsiveContainer width="100%" height={300}>
            <PieChart>
              <Pie
                data={stats?.pedidosPorStatus || []}
                cx="50%"
                cy="50%"
                labelLine={false}
                label={({ id_status, total }) => `${id_status}: ${total}`}
                outerRadius={80}
                fill="#8884d8"
                dataKey="total"
              >
                {stats?.pedidosPorStatus?.map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={['#3b82f6', '#10b981', '#f59e0b', '#ef4444', '#8b5cf6'][index % 5]} />
                ))}
              </Pie>
              <Tooltip />
            </PieChart>
          </ResponsiveContainer>
        </div>
      </div>

      {/* Gráfico de tendência de vendas */}
      <div className="card p-6">
        <h3 className="text-lg font-semibold text-gray-900 mb-4">Tendência de Vendas (Últimos 12 Meses)</h3>
        <ResponsiveContainer width="100%" height={300}>
          <LineChart data={chartData || []}>
            <CartesianGrid strokeDasharray="3 3" />
            <XAxis dataKey="mes" />
            <YAxis />
            <Tooltip />
            <Line type="monotone" dataKey="total_pedidos" stroke="#3b82f6" strokeWidth={2} />
          </LineChart>
        </ResponsiveContainer>
      </div>

      {/* Alertas */}
      {alerts.length > 0 && (
        <div className="card p-6">
          <h3 className="text-lg font-semibold text-gray-900 mb-4">Alertas e Notificações</h3>
          <div className="space-y-3">
            {alerts.map((alert, index) => (
              <AlertCard key={index} alert={alert} />
            ))}
          </div>
        </div>
      )}
    </div>
  );
};

export default Dashboard; 