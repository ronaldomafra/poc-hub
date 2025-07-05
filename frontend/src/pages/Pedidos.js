import React, { useState, useEffect } from 'react';
import { Search, Plus, Eye, Clock, CheckCircle, XCircle, X } from 'lucide-react';
import api from '../utils/api';
import toast from 'react-hot-toast';


const Pedidos = () => {
  const [pedidos, setPedidos] = useState([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const [selectedPedido, setSelectedPedido] = useState(null);
  const [showModal, setShowModal] = useState(false);
  const [filters, setFilters] = useState({
    status: '',
    dataInicio: '',
    dataFim: '',
    cliente: ''
  });

  useEffect(() => {
    loadPedidos();
  }, [currentPage, filters, searchTerm]);

  const loadPedidos = async () => {
    try {
      setLoading(true);
      const params = {
        page: currentPage,
        limit: 10,
        search: searchTerm,
        ...filters
      };

      const response = await api.get('/api/pedidos', { params });
      
      if (response.data.success) {
        setPedidos(response.data.data.pedidos);
        setTotalPages(response.data.data.totalPages);
      } else {
        toast.error(response.data.message || 'Erro ao carregar pedidos');
      }
    } catch (error) {
      console.error('Erro ao carregar pedidos:', error);
      toast.error('Erro ao carregar pedidos');
    } finally {
      setLoading(false);
    }
  };

  const handleSearch = (e) => {
    e.preventDefault();
    setCurrentPage(1);
    loadPedidos();
  };

  const handleFilterChange = (key, value) => {
    setFilters(prev => ({
      ...prev,
      [key]: value
    }));
    setCurrentPage(1);
  };

  const clearFilters = () => {
    setFilters({
      status: '',
      dataInicio: '',
      dataFim: '',
      cliente: ''
    });
    setSearchTerm('');
    setCurrentPage(1);
  };

  const [pedidoItens, setPedidoItens] = useState([]);

  const handleViewPedido = async (pedido) => {
    try {
      setSelectedPedido(pedido);
      setShowModal(true);
      
      // Carregar itens do pedido
      const response = await api.get(`/api/pedidos/${pedido.id}`);
      if (response.data.success) {
        setPedidoItens(response.data.data.itens || []);
      }
    } catch (error) {
      console.error('Erro ao carregar itens do pedido:', error);
      toast.error('Erro ao carregar detalhes do pedido');
    }
  };

  const closeModal = () => {
    setShowModal(false);
    setSelectedPedido(null);
  };

  const formatPrice = (price) => {
    return new Intl.NumberFormat('pt-BR', {
      style: 'currency',
      currency: 'BRL'
    }).format(price);
  };

  const formatDate = (date) => {
    return new Date(date).toLocaleDateString('pt-BR');
  };

  const getStatusInfo = (status) => {
    switch (status?.toLowerCase()) {
      case 'pendente':
        return {
          color: 'bg-yellow-100 text-yellow-800',
          icon: Clock,
          text: 'Pendente'
        };
      case 'aprovado':
        return {
          color: 'bg-blue-100 text-blue-800',
          icon: CheckCircle,
          text: 'Aprovado'
        };
      case 'finalizado':
        return {
          color: 'bg-green-100 text-green-800',
          icon: CheckCircle,
          text: 'Finalizado'
        };
      case 'cancelado':
        return {
          color: 'bg-red-100 text-red-800',
          icon: XCircle,
          text: 'Cancelado'
        };
      default:
        return {
          color: 'bg-gray-100 text-gray-800',
          icon: Clock,
          text: status || 'Desconhecido'
        };
    }
  };

  const updateStatus = async (pedidoId, newStatus) => {
    try {
      const response = await api.put(`/api/pedidos/${pedidoId}/status`, {
        status: newStatus
      });

      if (response.data.success) {
        toast.success('Status atualizado com sucesso');
        loadPedidos();
      }
    } catch (error) {
      console.error('Erro ao atualizar status:', error);
      toast.error('Erro ao atualizar status do pedido');
    }
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Pedidos</h1>
          <p className="text-gray-600">Gerencie os pedidos do sistema</p>
        </div>
        <button className="btn-primary flex items-center">
          <Plus className="h-4 w-4 mr-2" />
          Novo Pedido
        </button>
      </div>

      {/* Filtros e busca */}
      <div className="card p-6">
        <form onSubmit={handleSearch} className="space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Buscar
              </label>
              <div className="relative">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
                <input
                  type="text"
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  placeholder="Número do pedido, cliente..."
                  className="input pl-10"
                />
              </div>
            </div>
            
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Status
              </label>
              <select
                value={filters.status}
                onChange={(e) => handleFilterChange('status', e.target.value)}
                className="input"
              >
                <option value="">Todos</option>
                <option value="pendente">Pendente</option>
                <option value="aprovado">Aprovado</option>
                <option value="finalizado">Finalizado</option>
                <option value="cancelado">Cancelado</option>
              </select>
            </div>
            
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Data Início
              </label>
              <input
                type="date"
                value={filters.dataInicio}
                onChange={(e) => handleFilterChange('dataInicio', e.target.value)}
                className="input"
              />
            </div>
            
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Data Fim
              </label>
              <input
                type="date"
                value={filters.dataFim}
                onChange={(e) => handleFilterChange('dataFim', e.target.value)}
                className="input"
              />
            </div>
          </div>
          
          <div className="flex justify-between items-center">
            <button
              type="button"
              onClick={clearFilters}
              className="text-sm text-gray-600 hover:text-gray-900"
            >
              Limpar filtros
            </button>
            <button type="submit" className="btn-primary">
              Buscar
            </button>
          </div>
        </form>
      </div>

      {/* Lista de pedidos */}
      <div className="card">
        {loading ? (
          <div className="flex items-center justify-center h-64">
            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary-600"></div>
          </div>
        ) : (
          <>
            <div className="overflow-x-auto">
              <table className="min-w-full divide-y divide-gray-200">
                <thead className="bg-gray-50">
                  <tr>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Pedido
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Cliente
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Data
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Valor
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Status
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Itens
                    </th>
                    <th className="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Ações
                    </th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200">
                  {pedidos.map((pedido) => {
                    const statusInfo = getStatusInfo(pedido.status);
                    const StatusIcon = statusInfo.icon;
                    
                    return (
                      <tr key={pedido.id} className="hover:bg-gray-50">
                        <td className="px-6 py-4 whitespace-nowrap">
                          <div className="text-sm font-medium text-gray-900">
                            #{pedido.cd_pedido}
                          </div>
                          <div className="text-sm text-gray-500">
                            {pedido.tp_pedido}
                          </div>
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap">
                          <div className="text-sm text-gray-900">
                            {pedido.nm_cliente}
                          </div>
                          <div className="text-sm text-gray-500">
                            {pedido.cd_cliente}
                          </div>
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                          {formatDate(pedido.dt_pedido)}
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                          {formatPrice(pedido.vl_pedido)}
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap">
                          <span className={`inline-flex items-center px-2 py-1 text-xs font-semibold rounded-full ${statusInfo.color}`}>
                            <StatusIcon className="h-3 w-3 mr-1" />
                            {statusInfo.text}
                          </span>
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                          {pedido.qt_itens || 0} itens
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                                  <div className="flex justify-end space-x-2">
                          <button 
                            onClick={() => handleViewPedido(pedido)}
                            className="text-primary-600 hover:text-primary-900"
                            title="Visualizar pedido"
                          >
                            <Eye className="h-4 w-4" />
                          </button>
                            {pedido.status === 'pendente' && (
                              <>
                                <button 
                                  onClick={() => updateStatus(pedido.id, 'aprovado')}
                                  className="text-green-600 hover:text-green-900"
                                  title="Aprovar pedido"
                                >
                                  <CheckCircle className="h-4 w-4" />
                                </button>
                                <button 
                                  onClick={() => updateStatus(pedido.id, 'cancelado')}
                                  className="text-red-600 hover:text-red-900"
                                  title="Cancelar pedido"
                                >
                                  <XCircle className="h-4 w-4" />
                                </button>
                              </>
                            )}
                          </div>
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>

            {/* Paginação */}
            {totalPages > 1 && (
              <div className="bg-white px-4 py-3 flex items-center justify-between border-t border-gray-200 sm:px-6">
                <div className="flex-1 flex justify-between sm:hidden">
                  <button
                    onClick={() => setCurrentPage(Math.max(1, currentPage - 1))}
                    disabled={currentPage === 1}
                    className="btn-secondary disabled:opacity-50"
                  >
                    Anterior
                  </button>
                  <button
                    onClick={() => setCurrentPage(Math.min(totalPages, currentPage + 1))}
                    disabled={currentPage === totalPages}
                    className="btn-secondary disabled:opacity-50"
                  >
                    Próximo
                  </button>
                </div>
                <div className="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
                  <div>
                    <p className="text-sm text-gray-700">
                      Página <span className="font-medium">{currentPage}</span> de{' '}
                      <span className="font-medium">{totalPages}</span>
                    </p>
                  </div>
                  <div>
                    <nav className="relative z-0 inline-flex rounded-md shadow-sm -space-x-px">
                      <button
                        onClick={() => setCurrentPage(Math.max(1, currentPage - 1))}
                        disabled={currentPage === 1}
                        className="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 disabled:opacity-50"
                      >
                        Anterior
                      </button>
                      <button
                        onClick={() => setCurrentPage(Math.min(totalPages, currentPage + 1))}
                        disabled={currentPage === totalPages}
                        className="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 disabled:opacity-50"
                      >
                        Próximo
                      </button>
                    </nav>
                  </div>
                </div>
              </div>
            )}
          </>
        )}
      </div>

      {/* Modal de Detalhes do Pedido */}
      {showModal && selectedPedido && (
        <div className="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50">
          <div className="relative top-20 mx-auto p-5 border w-11/12 md:w-3/4 lg:w-1/2 shadow-lg rounded-md bg-white">
            <div className="mt-3">
              <div className="flex justify-between items-center mb-4">
                <h3 className="text-lg font-semibold text-gray-900">
                  Detalhes do Pedido #{selectedPedido.cd_pedido}
                </h3>
                <button
                  onClick={closeModal}
                  className="text-gray-400 hover:text-gray-600"
                >
                  <X className="h-6 w-6" />
                </button>
              </div>

              {/* Informações do Pedido */}
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
                <div>
                  <h4 className="font-medium text-gray-900 mb-2">Informações do Cliente</h4>
                  <p className="text-sm text-gray-600">Nome: {selectedPedido.nm_cliente}</p>
                  <p className="text-sm text-gray-600">Código: {selectedPedido.cd_cliente}</p>
                </div>
                <div>
                  <h4 className="font-medium text-gray-900 mb-2">Informações do Pedido</h4>
                  <p className="text-sm text-gray-600">Data: {formatDate(selectedPedido.dt_pedido)}</p>
                  <p className="text-sm text-gray-600">Tipo: {selectedPedido.tp_pedido}</p>
                  <p className="text-sm text-gray-600">Status: <span className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${getStatusInfo(selectedPedido.status).color}`}>
                    {getStatusInfo(selectedPedido.status).text}
                  </span></p>
                </div>
              </div>

              {/* Itens do Pedido */}
              <div>
                <h4 className="font-medium text-gray-900 mb-3">Itens do Pedido</h4>
                <div className="overflow-x-auto">
                  <table className="min-w-full divide-y divide-gray-200">
                    <thead className="bg-gray-50">
                      <tr>
                        <th className="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Produto</th>
                        <th className="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Código</th>
                        <th className="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Qtd</th>
                        <th className="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Valor Unit.</th>
                        <th className="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Total</th>
                      </tr>
                    </thead>
                    <tbody className="bg-white divide-y divide-gray-200">
                      {pedidoItens?.map((item) => (
                        <tr key={item.id}>
                          <td className="px-4 py-2 text-sm text-gray-900">{item.nm_produto}</td>
                          <td className="px-4 py-2 text-sm text-gray-600">{item.cd_produto}</td>
                          <td className="px-4 py-2 text-sm text-gray-900">{item.nr_quantidade}</td>
                          <td className="px-4 py-2 text-sm text-gray-900">{formatPrice(item.vl_venda_pedido)}</td>
                          <td className="px-4 py-2 text-sm font-medium text-gray-900">{formatPrice(item.vl_liquido)}</td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>

                {/* Total do Pedido */}
                <div className="mt-4 text-right">
                  <p className="text-lg font-semibold text-gray-900">
                    Total: {formatPrice(selectedPedido.vl_pedido)}
                  </p>
                </div>
              </div>

              {/* Botões de Ação */}
              <div className="flex justify-end space-x-3 mt-6">
                <button
                  onClick={closeModal}
                  className="btn-secondary"
                >
                  Fechar
                </button>
                {selectedPedido.status === 'pendente' && (
                  <>
                    <button
                      onClick={() => {
                        updateStatus(selectedPedido.id, 'aprovado');
                        closeModal();
                      }}
                      className="btn-primary"
                    >
                      Aprovar Pedido
                    </button>
                    <button
                      onClick={() => {
                        updateStatus(selectedPedido.id, 'cancelado');
                        closeModal();
                      }}
                      className="btn-danger"
                    >
                      Cancelar Pedido
                    </button>
                  </>
                )}
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default Pedidos; 