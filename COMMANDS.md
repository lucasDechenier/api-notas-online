# Comandos Úteis - API Notas Online

## 🐳 Docker & Docker Compose

### Iniciar aplicação
```bash
# Primeira vez ou após mudanças no Dockerfile
docker-compose up --build

# Iniciar em background
docker-compose up -d

# Iniciar apenas um serviço
docker-compose up mongodb
docker-compose up api
```

### Parar aplicação
```bash
# Parar containers
docker-compose down

# Parar e remover volumes (APAGA DADOS!)
docker-compose down -v

# Parar apenas um serviço
docker-compose stop api
docker-compose stop mongodb
```

### Ver logs
```bash
# Logs de todos os serviços
docker-compose logs -f

# Logs de um serviço específico
docker-compose logs -f api
docker-compose logs -f mongodb

# Últimas 100 linhas
docker-compose logs --tail=100 api
```

### Status e informações
```bash
# Ver containers rodando
docker-compose ps

# Ver uso de recursos
docker stats

# Inspecionar um serviço
docker-compose exec api rails about
```

### Executar comandos nos containers
```bash
# Rails console
docker-compose exec api rails console

# Bash no container da API
docker-compose exec api bash

# MongoDB shell
docker-compose exec mongodb mongosh -u admin -p admin123

# Ver rotas
docker-compose exec api rails routes
```

## 🚂 Rails Commands

### Console
```bash
# Acessar console Rails
docker-compose exec api rails console

# Exemplos no console:
# School.count
# User.all
# Student.where(school_id: "...")
```

### Rotas
```bash
# Listar todas as rotas
docker-compose exec api rails routes

# Buscar rota específica
docker-compose exec api rails routes | grep users
```

### Informações
```bash
# Ver informações do Rails
docker-compose exec api rails about

# Ver versões
docker-compose exec api ruby -v
docker-compose exec api rails -v
```

## 🗄️ MongoDB Commands

### Acessar MongoDB
```bash
# Via mongosh
docker-compose exec mongodb mongosh -u admin -p admin123

# Comandos úteis no mongosh:
show dbs                              # Listar databases
use api_notas_development            # Usar database
show collections                      # Listar collections
db.schools.find()                    # Buscar escolas
db.users.find().pretty()             # Buscar usuários formatado
db.students.countDocuments()         # Contar alunos
db.subjects.find({teacher_id: "..."})# Buscar disciplinas por professor
```

### Backup e Restore
```bash
# Backup
docker-compose exec mongodb mongodump \
  --username=admin \
  --password=admin123 \
  --db=api_notas_development \
  --out=/data/backup

# Restore
docker-compose exec mongodb mongorestore \
  --username=admin \
  --password=admin123 \
  --db=api_notas_development \
  /data/backup/api_notas_development
```

## 🧪 Testes com cURL

### Criar Escola
```bash
curl -X POST http://localhost:3000/schools \
  -H "Content-Type: application/json" \
  -d '{
    "school": {
      "name": "Escola Teste",
      "email": "teste@escola.com",
      "address": "Rua Teste, 123",
      "phone": "(11) 99999-9999"
    }
  }'
```

### Criar Usuário
```bash
curl -X POST http://localhost:3000/users \
  -H "Content-Type: application/json" \
  -d '{
    "user": {
      "name": "Admin Teste",
      "email": "admin@escola.com",
      "password": "senha123",
      "password_confirmation": "senha123",
      "user_type": "admin",
      "school_id": "SEU_SCHOOL_ID"
    }
  }'
```

### Login
```bash
curl -X POST http://localhost:3000/users/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@escola.com",
    "password": "senha123"
  }'
```

### Listar com Autenticação
```bash
# Salvar token em variável
TOKEN="seu_token_aqui"

# Listar escolas
curl -X GET http://localhost:3000/schools \
  -H "Authorization: Bearer $TOKEN"

# Listar alunos
curl -X GET http://localhost:3000/students \
  -H "Authorization: Bearer $TOKEN"
```

## 🔧 Manutenção

### Limpar Docker
```bash
# Remover containers parados
docker container prune

# Remover images não utilizadas
docker image prune

# Remover volumes não utilizados
docker volume prune

# Limpar tudo (cuidado!)
docker system prune -a --volumes
```

### Rebuild completo
```bash
# Parar tudo
docker-compose down -v

# Remover imagens
docker rmi api-notas-online-api

# Rebuild
docker-compose build --no-cache

# Iniciar
docker-compose up
```

### Ver uso de espaço
```bash
docker system df
```

## 📊 Monitoramento

### Health Check
```bash
curl http://localhost:3000/up
```

### Ver processos no container
```bash
docker-compose exec api ps aux
```

### Ver uso de memória
```bash
docker stats --no-stream
```

## 🐛 Debug

### Ver erros da API
```bash
# Logs em tempo real
docker-compose logs -f api

# Últimos erros
docker-compose logs --tail=50 api | grep Error
```

### Acessar shell para debug
```bash
# Bash no container
docker-compose exec api bash

# Ver arquivos
ls -la app/models/
cat app/models/user.rb

# Ver gems instaladas
bundle list
```

### Testar conexão MongoDB
```bash
# Da API
docker-compose exec api rails runner "puts Mongoid::Clients.default.database.name"

# Direto no MongoDB
docker-compose exec mongodb mongosh \
  -u admin \
  -p admin123 \
  --eval "db.adminCommand('ping')"
```

## 📝 Dicas Úteis

### Aliases (adicione ao .bashrc ou .zshrc)
```bash
alias dc='docker-compose'
alias dcu='docker-compose up'
alias dcd='docker-compose down'
alias dcl='docker-compose logs -f'
alias dcr='docker-compose exec api rails'
alias dcc='docker-compose exec api rails console'
```

### Variáveis de ambiente
```bash
# Ver variáveis no container
docker-compose exec api env | grep MONGODB
```

### Recarregar código sem restart
O volume está montado, então mudanças no código são refletidas automaticamente (em desenvolvimento).

### Instalar nova gem
1. Adicionar no Gemfile
2. `docker-compose exec api bundle install`
3. `docker-compose restart api`

## 🚀 Deploy (Produção)

### Variáveis de ambiente para produção
```bash
export RAILS_ENV=production
export MONGODB_HOST=seu-mongodb-host
export MONGODB_USERNAME=usuario
export MONGODB_PASSWORD=senha-segura
export SECRET_KEY_BASE=$(rails secret)
```

### Build para produção
```bash
docker build -t api-notas-online:production .
docker run -p 3000:3000 \
  -e RAILS_ENV=production \
  -e MONGODB_HOST=... \
  api-notas-online:production
```

## 🔐 Segurança

### Gerar nova secret key
```bash
docker-compose exec api rails secret
```

### Verificar gems com vulnerabilidades
```bash
docker-compose exec api bundle audit
```

### Atualizar gems
```bash
docker-compose exec api bundle update
docker-compose restart api
```

## 📦 Backup Rápido

### Script de backup
```bash
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
docker-compose exec -T mongodb mongodump \
  --username=admin \
  --password=admin123 \
  --db=api_notas_development \
  --archive=/data/backup_$DATE.archive
```

## 🎯 Atalhos Rápidos

```bash
# Start
docker-compose up -d && docker-compose logs -f

# Stop
docker-compose down

# Restart
docker-compose restart

# Rebuild
docker-compose up --build -d

# Clean restart
docker-compose down -v && docker-compose up --build

# Console
docker-compose exec api rails console

# MongoDB
docker-compose exec mongodb mongosh -u admin -p admin123

# Logs
docker-compose logs -f api
```
