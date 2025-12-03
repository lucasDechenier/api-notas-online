#!/bin/bash

echo "🚀 API Notas Online - Script de Inicialização"
echo "=============================================="
echo ""

# Verificar se Docker está rodando
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker não está rodando. Por favor, inicie o Docker primeiro."
    exit 1
fi

echo "✅ Docker está rodando"
echo ""

# Verificar se Docker Compose está disponível
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose não encontrado. Por favor, instale o Docker Compose."
    exit 1
fi

echo "✅ Docker Compose está disponível"
echo ""

# Parar containers existentes
echo "🛑 Parando containers existentes..."
docker-compose down

# Construir e iniciar os containers
echo ""
echo "🔨 Construindo e iniciando containers..."
docker-compose up --build -d

# Aguardar containers iniciarem
echo ""
echo "⏳ Aguardando containers iniciarem..."
sleep 10

# Verificar status
echo ""
echo "📊 Status dos containers:"
docker-compose ps

echo ""
echo "✅ Setup completo!"
echo ""
echo "📝 Informações importantes:"
echo "  - API: http://localhost:3000"
echo "  - MongoDB: localhost:27017"
echo "  - Credenciais MongoDB:"
echo "    - Usuário: admin"
echo "    - Senha: admin123"
echo ""
echo "🧪 Para testar a API:"
echo "  1. Crie uma escola: POST http://localhost:3000/schools"
echo "  2. Crie um usuário: POST http://localhost:3000/users"
echo "  3. Faça login: POST http://localhost:3000/users/login"
echo "  4. Use o token JWT nas requisições autenticadas"
echo ""
echo "📖 Veja o README.md para mais detalhes"
echo ""
echo "🛑 Para parar: docker-compose down"
echo "📋 Para ver logs: docker-compose logs -f"
