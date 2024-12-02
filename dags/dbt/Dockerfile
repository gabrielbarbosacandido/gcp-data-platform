FROM python:3.8-slim

WORKDIR /app

COPY requirements.txt .

# Instalar as dependências do projeto
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

COPY . .

CMD ["dbt", "run"]
