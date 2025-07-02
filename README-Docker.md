# SINSEMS - Configuração Docker

Este documento explica como configurar e executar o sistema SINSEMS usando Docker.

## Pré-requisitos

- Docker Desktop instalado
- Docker Compose instalado
- Git instalado

## Configuração Rápida

### 1. Clone o repositório
```bash
git clone https://github.com/expertbrazil/appsinsemsoficial.git
cd appsinsemsoficial
```

### 2. Execute o script de configuração
```bash
chmod +x docker-setup.sh
./docker-setup.sh
```

## Configuração Manual

### 1. Construir as imagens
```bash
docker-compose build
```

### 2. Subir os serviços
```bash
docker-compose up -d
```

### 3. Executar migrações
```bash
docker-compose exec web bundle exec rails db:migrate
```

### 4. Executar seeds (opcional)
```bash
docker-compose exec web bundle exec rails db:seed
```

## Acessando a Aplicação

- **URL**: http://localhost:3000
- **Banco de dados**: MySQL na porta 3306
- **Usuário root**: root
- **Senha**: FggX@CfFf_zl

## Comandos Úteis

### Gerenciar containers
```bash
# Subir serviços
docker-compose up -d

# Parar serviços
docker-compose down

# Ver logs
docker-compose logs -f

# Ver logs de um serviço específico
docker-compose logs -f web
docker-compose logs -f db
```

### Executar comandos Rails
```bash
# Console Rails
docker-compose exec web rails console

# Executar migrações
docker-compose exec web rails db:migrate

# Executar seeds
docker-compose exec web rails db:seed

# Executar testes
docker-compose exec web rails test
```

### Gerenciar banco de dados
```bash
# Acessar MySQL
docker-compose exec db mysql -u root -p

# Backup do banco
docker-compose exec db mysqldump -u root -p sinsems_development > backup.sql

# Restaurar backup
docker-compose exec -T db mysql -u root -p sinsems_development < backup.sql
```

## Estrutura dos Arquivos Docker

- `Dockerfile`: Configuração da imagem da aplicação Rails
- `docker-compose.yml`: Orquestração dos serviços (Rails + MySQL)
- `config/database.docker.yml`: Configuração do banco para Docker
- `.dockerignore`: Arquivos ignorados no build
- `docker-setup.sh`: Script de configuração automática

## Solução de Problemas

### Porta 3000 já em uso
```bash
# Parar serviços que usam a porta 3000
sudo lsof -ti:3000 | xargs kill -9
```

### Problemas com permissões
```bash
# Dar permissão de execução ao script
chmod +x docker-setup.sh
```

### Limpar cache do Docker
```bash
# Remover containers e volumes
docker-compose down -v

# Limpar cache de build
docker system prune -a
```

### Reconstruir imagens
```bash
# Forçar reconstrução
docker-compose build --no-cache
```

## Variáveis de Ambiente

As principais variáveis de ambiente estão configuradas no `docker-compose.yml`:

- `MYSQL_ROOT_PASSWORD`: Senha do root do MySQL
- `MYSQL_DATABASE`: Nome do banco de dados
- `DATABASE_URL`: URL de conexão com o banco
- `RAILS_ENV`: Ambiente Rails (development)

## Volumes

- `mysql_data`: Dados persistentes do MySQL
- `bundle_cache`: Cache das gems Ruby

## Desenvolvimento

Para desenvolvimento local, os arquivos são montados como volumes, então as alterações são refletidas automaticamente. Apenas reinicie o container web se necessário:

```bash
docker-compose restart web
``` 