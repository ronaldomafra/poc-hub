module.exports = {
  apps: [
    {
      name: 'poc-hub-backend',
      script: 'src/server.js',
      instances: 2, // Duas instâncias em cluster
      exec_mode: 'cluster', // Modo cluster para balanceamento de carga
      env_production: {
        NODE_ENV: 'production',
        PORT: 3001
      },
      // Configurações de log
      log_file: '/var/log/poc-hub-backend.log',
      error_file: '/var/log/poc-hub-backend-error.log',
      out_file: '/var/log/poc-hub-backend-out.log',
      log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
      
      // Configurações de restart
      max_memory_restart: '500M',
      restart_delay: 3000,
      max_restarts: 10,
      min_uptime: '10s',
      
      // Configurações de monitoramento
      watch: false, // Desabilitar watch em produção
      ignore_watch: ['node_modules', 'logs', '*.log'],
      
      // Configurações de timeout
      kill_timeout: 5000,
      listen_timeout: 3000,
      
      // Configurações de merge logs
      merge_logs: true,
      
      // Configurações de cron
      cron_restart: '0 2 * * *', // Reiniciar às 2h da manhã
      
      // Configurações de health check
      health_check_grace_period: 3000,
      
      // Configurações de variáveis de ambiente
      env_file: '.env',
      
      // Configurações de source map
      source_map_support: true,
      
      // Configurações de autoreload (apenas desenvolvimento)
      autorestart: true,
      
      // Configurações de exp_backoff_restart_delay
      exp_backoff_restart_delay: 100,
      
      // Configurações de wait_ready
      wait_ready: true,
      
      // Configurações de listen_timeout
      listen_timeout: 3000,
      
      // Configurações de kill_timeout
      kill_timeout: 5000,
      
      // Configurações de shutdown_with_message
      shutdown_with_message: true,
      
      // Configurações de increment_var
      increment_var: 'PORT',
      
      // Configurações de instance_var
      instance_var: 'INSTANCE_ID',
      
      // Configurações de pmx
      pmx: true,
      
      // Configurações de vizion
      vizion: false,
      
      // Configurações de autorestart
      autorestart: true,
      
      // Configurações de watch
      watch: false,
      
      // Configurações de ignore_watch
      ignore_watch: [
        'node_modules',
        'logs',
        '*.log',
        '.git',
        '.env',
        'package-lock.json'
      ],
      
      // Configurações de time
      time: true,
      
      // Configurações de log_type
      log_type: 'json',
      
      // Configurações de log_level
      log_level: 'info',
      
      // Configurações de disable_source_map_support
      disable_source_map_support: false,
      
      // Configurações de node_args
      node_args: '--max-old-space-size=512',
      
      // Configurações de cwd
      cwd: process.env.PWD || '/home/ubuntu/poc/poc-hub/backend',
      
      // Configurações de interpreter
      interpreter: 'node',
      
      // Configurações de interpreter_args
      interpreter_args: '',
      
      // Configurações de script_args
      script_args: '',
      
      // Configurações de name
      name: 'poc-hub-backend',
      
      // Configurações de namespace
      namespace: 'poc-hub',
      
      // Configurações de filter_env
      filter_env: ['NODE_ENV'],
      
      // Configurações de instances
      instances: 2,
      
      // Configurações de exec_mode
      exec_mode: 'cluster',
      

      
      // Configurações de env_production
      env_production: {
        NODE_ENV: 'production',
        PORT: 3001,
        DB_HOST: 'localhost',
        DB_PORT: 5432,
        DB_NAME: 'poc_tcix_logmais',
        DB_USER: 'poc_mcp_system',
        DB_PASSWORD: 'PocMcpSystem2025',
        JWT_SECRET: 'NTNv7j0TuYARvmNMmWXo6fKvM4o6nv/aUi9ryX38ZH+L1bkrnD1ObOQ8JAUmHCBq7Iy7otZcyAagBLHVKvvYaIpmMuxmARQ97jUVG16Jkpkp1wXOPsrF9zwew6TpczyHkHgX5EuLg2MeBuiT/qJACs1J0apruOOJCg/gOtkjB4c=',
        JWT_EXPIRES_IN: '24h',
        BCRYPT_ROUNDS: 12,
        RATE_LIMIT_WINDOW_MS: 900000,
        RATE_LIMIT_MAX_REQUESTS: 100,
        ALLOWED_ORIGINS: 'https://tradingfordummies.site,https://www.tradingfordummies.site'
      }
    }
  ],

  // Configurações de deploy
  deploy: {
    production: {
      user: 'root',
      host: 'localhost',
      ref: 'origin/main',
      repo: 'git@github.com:seu-usuario/poc-hub-testes.git',
      path: '/home/ubuntu/poc/poc-hub/backend',
      'pre-deploy-local': '',
      'post-deploy': 'npm install --production && pm2 reload ecosystem.config.js --env production',
      'pre-setup': ''
    }
  }
}; 