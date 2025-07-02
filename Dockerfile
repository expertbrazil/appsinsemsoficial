# Use a imagem oficial do Ruby
FROM ruby:2.7.8

# Instalar dependências do sistema
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    default-mysql-client \
    imagemagick \
    libmagickwand-dev \
    wkhtmltopdf \
    xvfb \
    && rm -rf /var/lib/apt/lists/*

# Definir diretório de trabalho
WORKDIR /app

# Copiar Gemfile e Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Instalar gems
RUN bundle install

# Copiar o resto da aplicação
COPY . .

# Criar diretório para uploads
RUN mkdir -p public/uploads

# Definir permissões
RUN chmod +x bin/rails

# Expor porta 3000
EXPOSE 3000

# Comando padrão
CMD ["rails", "server", "-b", "0.0.0.0"] 