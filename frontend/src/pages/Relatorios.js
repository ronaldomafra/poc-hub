import React, { useState, useEffect } from 'react';
import { 
  BarChart, 
  Download,
  Calendar,
  TrendingUp,
  DollarSign
} from 'lucide-react';
import { BarChart as RechartsBarChart, LineChart as RechartsLineChart, PieChart as RechartsPieChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, Line, Pie, Cell } from 'recharts';
import api from '../utils/api';
import toast from 'react-hot-toast';

const Relatorios = () => {
  const [selectedPeriod, setSelectedPeriod] = useState('30dias');
  const [loading, setLoading] = useState(false);
  const [stats, setStats] = useState(null);
  const [chartData, setChartData] = useState(null);

  const periods = [
    { value: '7dias', label: 'Últimos 7 dias' },
    { value: '30dias', label: 'Últimos 30 dias' },
    { value: '90dias', label: 'Últimos 90 dias' },
    { value: '1ano', label: 'Último ano' }
  ];

  useEffect(() => {
    loadReportData();
  }, [selectedPeriod]);

  const loadReportData = async () => {
    try {
      setLoading(true);
      
      // Carregar estatísticas
      const statsResponse = await api.get('/api/dashboard/estatisticas');
      setStats(statsResponse.data.data);
      
      // Carregar dados de gráficos
      const chartsResponse = await api.get('/api/dashboard/graficos?tipo=vendas_mensal');
      setChartData(chartsResponse.data.data);
      
    } catch (error) {
      console.error('Erro ao carregar dados dos relatórios:', error);
      toast.error('Erro ao carregar dados dos relatórios');
      
      // Definir dados vazios em caso de erro
      setStats({
        totalProdutos: 0,
        pedidosAtivos: 0,
        valorPedidosMes: 0,
        clientesAtivos: 0
      });
      setChartData([]);
    } finally {
      setLoading(false);
    }
  };

  const handleExportReport = (type) => {
    toast.success(`Relatório ${type} exportado com sucesso!`);
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
              {change > 0 ? '+' : ''}{change}% em relação ao período anterior
            </p>
          )}
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
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Relatórios</h1>
          <p className="text-gray-600">Análises e estatísticas do sistema</p>
        </div>
        <div className="flex space-x-3">
          <select
            value={selectedPeriod}
            onChange={(e) => setSelectedPeriod(e.target.value)}
            className="input w-auto"
          >
            {periods.map(period => (
              <option key={period.value} value={period.value}>
                {period.label}
              </option>
            ))}
          </select>
          <button
            onClick={() => handleExportReport('PDF')}
            className="btn-primary flex items-center"
          >
            <Download className="h-4 w-4 mr-2" />
            Exportar PDF
          </button>
        </div>
      </div>

      {/* Cards de Estatísticas */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <StatCard
          title="Total de Vendas"
          value={`R$ ${(stats?.valorPedidosMes || 0).toLocaleString()}`}
          icon={DollarSign}
          color="bg-green-500"
        />
        <StatCard
          title="Pedidos Processados"
          value={stats?.pedidosMes || 0}
          icon={TrendingUp}
          color="bg-blue-500"
        />
        <StatCard
          title="Produtos Cadastrados"
          value={stats?.totalProdutos || 0}
          icon={BarChart}
          color="bg-purple-500"
        />
        <StatCard
          title="Ticket Médio"
          value={`R$ ${((stats?.valorPedidosMes || 0) / (stats?.pedidosMes || 1)).toFixed(2)}`}
          icon={Calendar}
          color="bg-orange-500"
        />
      </div>

      {/* Gráficos */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Gráfico de Vendas por Período */}
        <div className="card p-6">
          <div className="flex justify-between items-center mb-4">
            <h3 className="text-lg font-semibold text-gray-900">Vendas por Período</h3>
            <button
              onClick={() => handleExportReport('Vendas')}
              className="text-primary-600 hover:text-primary-900 text-sm"
            >
              Exportar
            </button>
          </div>
          <ResponsiveContainer width="100%" height={300}>
            <RechartsBarChart data={chartData || []}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="mes" />
              <YAxis />
              <Tooltip formatter={(value) => [`R$ ${value.toLocaleString()}`, 'Vendas']} />
              <Bar dataKey="valor_total" fill="#3b82f6" />
            </RechartsBarChart>
          </ResponsiveContainer>
        </div>

        {/* Gráfico de Pedidos por Status */}
        <div className="card p-6">
          <div className="flex justify-between items-center mb-4">
            <h3 className="text-lg font-semibold text-gray-900">Pedidos por Status</h3>
            <button
              onClick={() => handleExportReport('Status')}
              className="text-primary-600 hover:text-primary-900 text-sm"
            >
              Exportar
            </button>
          </div>
          <ResponsiveContainer width="100%" height={300}>
            <RechartsPieChart>
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
            </RechartsPieChart>
          </ResponsiveContainer>
        </div>
      </div>

      {/* Gráfico de Tendência */}
      <div className="card p-6">
        <div className="flex justify-between items-center mb-4">
          <h3 className="text-lg font-semibold text-gray-900">Tendência de Pedidos</h3>
          <button
            onClick={() => handleExportReport('Tendência')}
            className="text-primary-600 hover:text-primary-900 text-sm"
          >
            Exportar
          </button>
        </div>
        <ResponsiveContainer width="100%" height={300}>
          <RechartsLineChart data={chartData || []}>
            <CartesianGrid strokeDasharray="3 3" />
            <XAxis dataKey="mes" />
            <YAxis />
            <Tooltip />
            <Line type="monotone" dataKey="total_pedidos" stroke="#3b82f6" strokeWidth={2} />
          </RechartsLineChart>
        </ResponsiveContainer>
      </div>

      {/* Relatórios Detalhados */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {/* Relatório de Produtos Mais Vendidos */}
        <div className="card p-6">
          <h3 className="text-lg font-semibold text-gray-900 mb-4">Produtos Mais Vendidos</h3>
          <div className="space-y-3">
            {stats?.produtosMaisVendidos?.slice(0, 5).map((produto, index) => (
              <div key={index} className="flex justify-between items-center p-3 bg-gray-50 rounded-lg">
                <div>
                  <p className="font-medium text-gray-900">{produto.nm_produto}</p>
                  <p className="text-sm text-gray-600">{produto.ds_fabr}</p>
                </div>
                <div className="text-right">
                  <p className="font-medium text-gray-900">{produto.quantidade_total} unidades</p>
                  <p className="text-sm text-gray-600">{produto.total_pedidos} pedidos</p>
                </div>
              </div>
            )) || (
              <p className="text-gray-500 text-center py-4">Nenhum dado disponível</p>
            )}
          </div>
        </div>

        {/* Relatório de Top Clientes */}
        <div className="card p-6">
          <h3 className="text-lg font-semibold text-gray-900 mb-4">Top Clientes</h3>
          <div className="space-y-3">
            {stats?.topClientes?.slice(0, 5).map((cliente, index) => (
              <div key={index} className="flex justify-between items-center p-3 bg-gray-50 rounded-lg">
                <div>
                  <p className="font-medium text-gray-900">{cliente.nm_cliente}</p>
                  <p className="text-sm text-gray-600">{cliente.nm_fantasia}</p>
                </div>
                <div className="text-right">
                  <p className="font-medium text-gray-900">R$ {parseFloat(cliente.valor_total || 0).toLocaleString()}</p>
                  <p className="text-sm text-gray-600">{cliente.total_pedidos} pedidos</p>
                </div>
              </div>
            )) || (
              <p className="text-gray-500 text-center py-4">Nenhum dado disponível</p>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default Relatorios; 