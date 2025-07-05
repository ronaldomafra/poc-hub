# 🔧 Alterações para Usar Ecosystem.config.js com PM2

## 📋 **Resumo das Alterações**

Modificados os scripts de deploy para usar o arquivo `ecosystem.config.js` com PM2, seguindo as melhores práticas de gerenciamento de processos.

## 🔄 **Alterações no `deploy.sh`**

### **Função `start_application()`:**
- ✅ **Antes**: `pm2 start src/server.js --name "app" --log ...`
- ✅ **Depois**: `pm2 start ecosystem.config.js --env production`

### **Função `stop_application()`:**
- ✅ **Antes**: `pm2 stop "app-name"`
- ✅ **Depois**: `pm2 stop ecosystem.config.js --env production`

### **Função `check_application()`:**
- ✅ Melhorada verificação de logs
- ✅ Adicionada informação sobre localização dos logs

## 📁 **Arquivo `ecosystem.config.js`**

O arquivo já existia e contém configurações completas:

```javascript
module.exports = {
  apps: [
    {
      name: 'poc-hub-backend',
      script: 'src/server.js',
      instances: 'max',
      exec_mode: 'cluster',
      env_production: {
        NODE_ENV: 'production',
        PORT: 3001,
        // ... outras variáveis
      }
    }
  ]
};
```

## 🚀 **Vantagens do Ecosystem**

### **1. Configuração Centralizada**
- Todas as configurações em um arquivo
- Fácil manutenção e versionamento
- Configurações diferentes por ambiente

### **2. Melhor Controle**
- Variáveis de ambiente organizadas
- Configurações de log centralizadas
- Restart automático configurado

### **3. Cluster Mode**
- Usa todas as CPUs disponíveis
- Melhor performance
- Alta disponibilidade

### **4. Logs Organizados**
- Logs separados por tipo (out, error, combined)
- Formato de data configurado
- Rotação automática

## 🔧 **Comandos PM2 com Ecosystem**

### **Iniciar Aplicação:**
```bash
pm2 start ecosystem.config.js --env production
```

### **Parar Aplicação:**
```bash
pm2 stop ecosystem.config.js --env production
```

### **Reiniciar Aplicação:**
```bash
pm2 restart ecosystem.config.js --env production
```

### **Recarregar Aplicação:**
```bash
pm2 reload ecosystem.config.js --env production
```

### **Deletar Aplicação:**
```bash
pm2 delete ecosystem.config.js --env production
```

## 📊 **Configurações do Ecosystem**

### **Performance:**
- `instances: 'max'` - Usa todas as CPUs
- `exec_mode: 'cluster'` - Modo cluster
- `max_memory_restart: '500M'` - Restart se exceder memória

### **Logs:**
- `log_file: '/var/log/poc-hub-backend.log'`
- `error_file: '/var/log/poc-hub-backend-error.log'`
- `out_file: '/var/log/poc-hub-backend-out.log'`

### **Restart:**
- `restart_delay: 3000` - Delay entre restarts
- `max_restarts: 10` - Máximo de restarts
- `min_uptime: '10s'` - Tempo mínimo para considerar estável

### **Monitoramento:**
- `watch: false` - Desabilitado em produção
- `time: true` - Timestamp nos logs
- `merge_logs: true` - Logs unificados

## 🧪 **Script de Teste Atualizado**

Criado `test-pm2.sh` para testar o ecosystem:

```bash
# Executar teste
./test-pm2.sh
```

**O que testa:**
- ✅ Verificação do PM2 instalado
- ✅ Verificação do ecosystem.config.js
- ✅ Teste de inicialização com ecosystem
- ✅ Verificação de logs
- ✅ Limpeza após teste

## 🔍 **Logs Disponíveis**

### **Localização dos Logs:**
- `/var/log/poc-hub-backend.log` - Log geral
- `/var/log/poc-hub-backend-error.log` - Log de erros
- `/var/log/poc-hub-backend-out.log` - Log de saída

### **Comandos para Verificar Logs:**
```bash
# Log geral
tail -f /var/log/poc-hub-backend.log

# Log de erros
tail -f /var/log/poc-hub-backend-error.log

# Log de saída
tail -f /var/log/poc-hub-backend-out.log

# Últimas 50 linhas de erro
tail -n 50 /var/log/poc-hub-backend-error.log
```

## ✅ **Benefícios das Alterações**

1. **Melhor Organização** - Configurações centralizadas
2. **Maior Performance** - Cluster mode com todas as CPUs
3. **Logs Organizados** - Separação por tipo e formato
4. **Fácil Manutenção** - Um arquivo para todas as configurações
5. **Ambientes Separados** - Dev e production com configurações diferentes
6. **Monitoramento Melhorado** - Mais informações nos logs

## 🎯 **Como Executar Agora**

```bash
# Deploy completo
sudo ./deploy.sh

# Teste do PM2
./test-pm2.sh

# Verificar status
pm2 status

# Ver logs
pm2 logs poc-hub-backend
```

---

**Data da Alteração**: $(date)
**Motivo**: Implementar uso do ecosystem.config.js para melhor gerenciamento do PM2 