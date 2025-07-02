#!/bin/bash

echo "🚀 Configurando o ambiente Docker para o SINSEMS..."

# Verificar se o Docker está instalado
if ! command -v docker &> /dev/null; then
    echo "❌ Docker não está instalado. Por favor, instale o Docker primeiro."
    exit 1
fi

# Verificar se o Docker Compose está instalado
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose não está instalado. Por favor, instale o Docker Compose primeiro."
    exit 1
fi

echo "✅ Docker e Docker Compose encontrados"

# Parar containers existentes
echo "🛑 Parando containers existentes..."
docker-compose down

# Construir as imagens
echo "🔨 Construindo imagens..."
docker-compose build

# Subir os serviços
echo "⬆️ Subindo os serviços..."
docker-compose up -d

# Aguardar o banco estar pronto
echo "⏳ Aguardando o banco de dados estar pronto..."
sleep 30

# Executar migrações
echo "🗃️ Executando migrações..."
docker-compose exec web bundle exec rails db:migrate

# Executar seeds (se existir)
if [ -f "db/seeds.rb" ]; then
    echo "🌱 Executando seeds..."
    docker-compose exec web bundle exec rails db:seed
fi

echo "✅ Ambiente Docker configurado com sucesso!"
echo "🌐 Acesse: http://localhost:3000"
echo ""
echo "Comandos úteis:"
echo "  docker-compose up -d     # Subir serviços"
echo "  docker-compose down      # Parar serviços"
echo "  docker-compose logs -f   # Ver logs"
echo "  docker-compose exec web rails console  # Console Rails" 