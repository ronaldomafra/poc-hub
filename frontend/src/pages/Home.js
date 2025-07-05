import React from 'react';
import { Link } from 'react-router-dom';
import { 
  BarChart3, 
  Package, 
  ShoppingCart, 
  Users, 
  TrendingUp, 
  Shield, 
  Zap, 
  ArrowRight,
  Play,
  Star,
  Clock,
  Globe
} from 'lucide-react';

const Home = () => {
  const features = [
    {
      icon: <BarChart3 className="h-8 w-8" />,
      title: "Dashboard Inteligente",
      description: "Visualize métricas em tempo real com gráficos interativos e relatórios detalhados"
    },
    {
      icon: <Package className="h-8 w-8" />,
      title: "Gestão de Produtos",
      description: "Controle completo do catálogo com categorização e gestão de estoque"
    },
    {
      icon: <ShoppingCart className="h-8 w-8" />,
      title: "Gestão de Pedidos",
      description: "Acompanhe pedidos do início ao fim com atualizações de status em tempo real"
    },
    {
      icon: <Users className="h-8 w-8" />,
      title: "Gestão de Usuários",
      description: "Controle de acesso seguro com autenticação JWT e perfis personalizados"
    }
  ];

  const benefits = [
    {
      icon: <TrendingUp className="h-6 w-6" />,
      title: "Aumento de Produtividade",
      description: "Automatize processos e reduza tempo gasto em tarefas manuais"
    },
    {
      icon: <Shield className="h-6 w-6" />,
      title: "Segurança Avançada",
      description: "Proteção de dados com criptografia e autenticação robusta"
    },
    {
      icon: <Zap className="h-6 w-6" />,
      title: "Performance Otimizada",
      description: "Interface responsiva e rápida para máxima eficiência"
    },
    {
      icon: <Globe className="h-6 w-6" />,
      title: "Acesso Remoto",
      description: "Acesse o sistema de qualquer lugar com conexão à internet"
    }
  ];

  const stats = [
    { number: "99.9%", label: "Uptime" },
    { number: "< 2s", label: "Tempo de Resposta" },
    { number: "24/7", label: "Suporte" },
    { number: "100%", label: "Seguro" }
  ];

  return (
    <div className="min-h-screen bg-white">
      {/* Header */}
      <header className="bg-white shadow-sm border-b">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <div className="flex items-center">
              <div className="flex-shrink-0">
                <div className="h-8 w-8 bg-primary-600 rounded-lg flex items-center justify-center">
                  <BarChart3 className="h-5 w-5 text-white" />
                </div>
              </div>
              <div className="ml-3">
                <h1 className="text-xl font-bold text-gray-900">POC Hub Testes</h1>
              </div>
            </div>
            <div className="flex items-center space-x-4">
              <Link
                to="/login"
                className="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 transition-colors"
              >
                Acessar Sistema
                <ArrowRight className="ml-2 h-4 w-4" />
              </Link>
            </div>
          </div>
        </div>
      </header>

      {/* Hero Section */}
      <section className="bg-gradient-to-br from-primary-50 to-blue-50 py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center">
            <h1 className="text-4xl md:text-6xl font-bold text-gray-900 mb-6">
              Sistema de Gestão
              <span className="text-primary-600 block">Completo e Moderno</span>
            </h1>
            <p className="text-xl text-gray-600 mb-8 max-w-3xl mx-auto">
              Gerencie seus produtos, pedidos e vendas com uma plataforma intuitiva e poderosa. 
              Tome decisões baseadas em dados reais e aumente sua produtividade.
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <Link
                to="/login"
                className="inline-flex items-center px-8 py-3 border border-transparent text-lg font-medium rounded-lg text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 transition-colors"
              >
                Começar Agora
                <ArrowRight className="ml-2 h-5 w-5" />
              </Link>
              <button className="inline-flex items-center px-8 py-3 border border-gray-300 text-lg font-medium rounded-lg text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 transition-colors">
                <Play className="mr-2 h-5 w-5" />
                Ver Demo
              </button>
            </div>
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section className="py-20 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">
              Funcionalidades Principais
            </h2>
            <p className="text-xl text-gray-600 max-w-2xl mx-auto">
              Tudo que você precisa para gerenciar seu negócio de forma eficiente e profissional
            </p>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
            {features.map((feature, index) => (
              <div key={index} className="text-center p-6 rounded-xl bg-gray-50 hover:bg-gray-100 transition-colors">
                <div className="inline-flex items-center justify-center w-16 h-16 bg-primary-100 text-primary-600 rounded-lg mb-4">
                  {feature.icon}
                </div>
                <h3 className="text-xl font-semibold text-gray-900 mb-2">
                  {feature.title}
                </h3>
                <p className="text-gray-600">
                  {feature.description}
                </p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Benefits Section */}
      <section className="py-20 bg-gray-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">
              Por que escolher o POC Hub Testes?
            </h2>
            <p className="text-xl text-gray-600 max-w-2xl mx-auto">
              Benefícios que fazem a diferença no seu dia a dia
            </p>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
            {benefits.map((benefit, index) => (
              <div key={index} className="flex items-start space-x-4">
                <div className="flex-shrink-0">
                  <div className="flex items-center justify-center w-12 h-12 bg-primary-100 text-primary-600 rounded-lg">
                    {benefit.icon}
                  </div>
                </div>
                <div>
                  <h3 className="text-lg font-semibold text-gray-900 mb-2">
                    {benefit.title}
                  </h3>
                  <p className="text-gray-600">
                    {benefit.description}
                  </p>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Stats Section */}
      <section className="py-20 bg-primary-600">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12">
            <h2 className="text-3xl md:text-4xl font-bold text-white mb-4">
              Números que Impressionam
            </h2>
            <p className="text-xl text-primary-100">
              Confiabilidade e performance em números
            </p>
          </div>
          
          <div className="grid grid-cols-2 md:grid-cols-4 gap-8">
            {stats.map((stat, index) => (
              <div key={index} className="text-center">
                <div className="text-4xl md:text-5xl font-bold text-white mb-2">
                  {stat.number}
                </div>
                <div className="text-primary-100">
                  {stat.label}
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-20 bg-white">
        <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">
            Pronto para Transformar seu Negócio?
          </h2>
          <p className="text-xl text-gray-600 mb-8">
            Junte-se a centenas de empresas que já confiam no POC Hub Testes para gerenciar suas operações
          </p>
          <Link
            to="/login"
            className="inline-flex items-center px-8 py-3 border border-transparent text-lg font-medium rounded-lg text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 transition-colors"
          >
            Acessar Sistema Agora
            <ArrowRight className="ml-2 h-5 w-5" />
          </Link>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-gray-900 text-white py-12">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
            <div className="col-span-1 md:col-span-2">
              <div className="flex items-center mb-4">
                <div className="h-8 w-8 bg-primary-600 rounded-lg flex items-center justify-center mr-3">
                  <BarChart3 className="h-5 w-5 text-white" />
                </div>
                <h3 className="text-xl font-bold">POC Hub Testes</h3>
              </div>
              <p className="text-gray-400 mb-4">
                Sistema completo de gestão para empresas que buscam eficiência e crescimento.
                Gerencie produtos, pedidos e vendas com uma plataforma moderna e intuitiva.
              </p>
              <div className="flex space-x-4">
                <div className="flex items-center text-gray-400">
                  <Star className="h-4 w-4 text-yellow-400 mr-1" />
                  <span className="text-sm">4.9/5</span>
                </div>
                <div className="flex items-center text-gray-400">
                  <Clock className="h-4 w-4 mr-1" />
                  <span className="text-sm">24/7 Suporte</span>
                </div>
              </div>
            </div>
            
                         <div>
               <h4 className="text-lg font-semibold mb-4">Produto</h4>
               <ul className="space-y-2 text-gray-400">
                 <li><button className="hover:text-white transition-colors text-left">Funcionalidades</button></li>
                 <li><button className="hover:text-white transition-colors text-left">Preços</button></li>
                 <li><button className="hover:text-white transition-colors text-left">Integrações</button></li>
                 <li><button className="hover:text-white transition-colors text-left">API</button></li>
               </ul>
             </div>
             
             <div>
               <h4 className="text-lg font-semibold mb-4">Suporte</h4>
               <ul className="space-y-2 text-gray-400">
                 <li><button className="hover:text-white transition-colors text-left">Documentação</button></li>
                 <li><button className="hover:text-white transition-colors text-left">Tutoriais</button></li>
                 <li><button className="hover:text-white transition-colors text-left">FAQ</button></li>
                 <li><button className="hover:text-white transition-colors text-left">Contato</button></li>
               </ul>
             </div>
          </div>
          
          <div className="border-t border-gray-800 mt-8 pt-8 text-center text-gray-400">
            <p>&copy; 2024 POC Hub Testes. Todos os direitos reservados.</p>
          </div>
        </div>
      </footer>
    </div>
  );
};

export default Home; 