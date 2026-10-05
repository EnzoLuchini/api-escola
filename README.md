# Sistema Escolar API

Esta API foi desenvolvida como parte do Check Point 2 da disciplina de Microservices and Web Engineering (2026). O objetivo do projeto é construir uma API RESTful completa em Spring Boot, com persistência de dados em um banco de dados relacional **SQL Server**, utilizando Docker.

## 📋 Pré-requisitos

Para executar o projeto localmente, você precisará ter instalado:

- Java 21
- Maven
- SQL Server
- Docker (opcional)

---

## 📋 Requisitos do Projeto

A aplicação atende aos seguintes critérios técnicos:

- **Entidades:** Possui as entidades `Aluno` e `Curso`, cada uma com pelo menos 5 atributos e mapeamento para tabelas no plural (`alunos` e `cursos`).
- **Persistência:** Implementação de `JpaRepository` (Spring Data JPA) para ambas as entidades.
- **CRUD Completo:** Endpoints para Criar, Ler (Buscar todos e por ID), Atualizar e Deletar.
- **Banco de dados:** Conexão com **SQL Server** via driver `mssql-jdbc`.
- **Porta:** A aplicação está configurada para rodar na porta `8080`.

---

## 🏗️ Estrutura de Endpoints

### Alunos

- `GET /alunos` — Lista todos os alunos registrados.
- `GET /alunos/{id}` — Busca um aluno específico pelo ID.
- `POST /alunos` — Registra um novo aluno.
- `PUT /alunos/{id}` — Atualiza os dados de um aluno existente.
- `DELETE /alunos/{id}` — Remove um aluno do sistema.

### Cursos

- `GET /cursos` — Lista todos os cursos registrados.
- `GET /cursos/{id}` — Busca um curso específico pelo ID.
- `POST /cursos` — Registra um novo curso.
- `PUT /cursos/{id}` — Atualiza os dados de um curso existente.
- `DELETE /cursos/{id}` — Remove um curso do sistema.

### Exemplo de corpo (JSON)

**Aluno**

```json
{
  "id": 1,
  "nome": "Maria Silva",
  "email": "maria@example.com",
  "rm": 12345,
  "senha": "senha123"
}
```

**Curso**

```json
{
  "id": 1,
  "nome": "Análise e Desenvolvimento de Sistemas",
  "reitor": "João Souza",
  "notaMec": 4.5,
  "nivel": "Superior"
}
```

---

## 🐳 Execução a partir da imagem publicada no Docker Hub

A imagem da aplicação está publicada no Docker Hub e pode ser executada **sem a necessidade de clonar o projeto ou compilar o código**.

- **Repositório:** [`eluchini/api-escola`](https://hub.docker.com/r/eluchini/api-escola)

### 1. Subir o banco de dados (SQL Server)

A aplicação precisa de um **SQL Server** disponível. Caso ainda não possua um, suba um container SQL Server com o comando abaixo (a senha coincide com a variável usada na execução da API):

```sh
docker run -d --name sqlserver \
  -e "ACCEPT_EULA=Y" \
  -e "MSSQL_SA_PASSWORD=1q2w3e4R@" \
  -p 1433:1433 \
  mcr.microsoft.com/mssql/server:2022-latest
```

> No profile `default`, a aplicação cria automaticamente as tabelas (`ddl-auto=update`) ao iniciar. É necessário, porém, que o banco (schema) `school` já exista no SQL Server. Crie-o com:
>
> ```sh
> docker exec -i sqlserver /opt/mssql-tools18/bin/sqlcmd \
>   -S localhost -U sa -P "1q2w3e4R@" -C \
>   -Q "CREATE DATABASE school"
> ```

### 2. Download da imagem (docker pull)

```sh
docker pull eluchini/api-escola:1.1.0
```

### 3. Execução do container (docker run)

O comando abaixo mapeia a porta **8080**, define o **profile** e informa todas as **variáveis de ambiente** necessárias para a conexão com o banco de dados:

```sh
docker run -d --name api-escola \
  -p 8080:8080 \
  -e SPRING_PROFILES_ACTIVE=default \
  -e DB_SERVER_URL=host.docker.internal \
  -e DB_SERVER_PORT=1433 \
  -e DB_SCHEMA=school \
  -e DB_USER=sa \
  -e DB_PWD=1q2w3e4R@ \
  eluchini/api-escola:1.1.0
```

No **Windows PowerShell**, use `` ` `` (crase) no lugar de `\` para quebrar a linha, ou informe tudo em uma única linha:

```powershell
docker run -d --name api-escola -p 8080:8080 -e SPRING_PROFILES_ACTIVE=default -e DB_SERVER_URL=host.docker.internal -e DB_SERVER_PORT=1433 -e DB_SCHEMA=school -e DB_USER=sa -e DB_PWD=1q2w3e4R@ eluchini/api-escola:1.1.0
```

> **Nota:** `host.docker.internal` permite que o container acesse um banco de dados que esteja rodando na **máquina host**. Ajuste `DB_SERVER_URL` caso o banco esteja em outro endereço.

### 4. Variáveis de ambiente necessárias

| Variável | Descrição | Exemplo |
|---|---|---|
| `SPRING_PROFILES_ACTIVE` | Profile ativo do Spring Boot (`default` ou `prd`) | `default` |
| `DB_SERVER_URL` | Endereço do servidor do banco de dados | `host.docker.internal` |
| `DB_SERVER_PORT` | Porta do banco de dados (SQL Server) | `1433` |
| `DB_SCHEMA` | Nome do banco/database | `school` |
| `DB_USER` | Usuário do banco de dados | `sa` |
| `DB_PWD` | Senha do banco de dados | `1q2w3e4R@` |

### 5. Acesso ao Swagger / OpenAPI

Com o container em execução, a documentação interativa da API fica disponível em:

| Recurso | URL |
|---|---|
| **Swagger UI** | [http://localhost:8080/](http://localhost:8080/) |
| **OpenAPI (JSON)** | [http://localhost:8080/v3/api-docs](http://localhost:8080/v3/api-docs) |

Pela **Swagger UI** é possível visualizar e testar todos os endpoints de `Alunos` e `Cursos` diretamente pelo navegador.

---

## 🚀 Execução local

### 1. Configuração das variáveis de ambiente

A aplicação utiliza variáveis de ambiente para configurar a conexão com o banco de dados e o profile do Spring Boot.

| Variável | Descrição | Exemplo |
|---|---|---|
| `DB_SERVER_URL` | Endereço do servidor do banco de dados | `localhost` |
| `DB_SERVER_PORT` | Porta do banco de dados (SQL Server) | `1433` |
| `DB_SCHEMA` | Nome do banco/database | `school` |
| `DB_USER` | Usuário do banco de dados | `sa` |
| `DB_PWD` | Senha do banco de dados | `1q2w3e4R@` |
| `SPRING_PROFILES_ACTIVE` | Profile ativo do Spring Boot | `default` |

> No profile `default` essas variáveis possuem valores padrão (ver `application-default.properties`), então a aplicação sobe mesmo sem defini-las, desde que exista um SQL Server acessível em `host.docker.internal:1433` com o banco `school`. No profile `prd` as variáveis são obrigatórias.

### Linux / macOS

```sh
export DB_SERVER_URL=localhost
export DB_SERVER_PORT=1433
export DB_SCHEMA=school
export DB_USER=sa
export DB_PWD=1q2w3e4R@
export SPRING_PROFILES_ACTIVE=default
```

### Windows PowerShell

```powershell
$env:DB_SERVER_URL="localhost"
$env:DB_SERVER_PORT="1433"
$env:DB_SCHEMA="school"
$env:DB_USER="sa"
$env:DB_PWD="1q2w3e4R@"
$env:SPRING_PROFILES_ACTIVE="default"
```

### 2. Executar a aplicação

Com Maven:

```sh
mvn spring-boot:run
```

Ou utilizando o Maven Wrapper:

```sh
./mvnw spring-boot:run
```

No Windows:

```powershell
.\mvnw.cmd spring-boot:run
```

A aplicação será iniciada em:

```text
http://localhost:8080
```

---

## 🐳 Execução com Docker (build local)

### 1. Criar a imagem

Na raiz do projeto, execute:

```sh
docker build -t sistema-escolar-api:1.1 .
```

### 2. Executar o container

Caso o banco de dados esteja sendo executado na máquina host, utilize `host.docker.internal` para permitir que o container acesse o banco.

```sh
docker run \
  -p 8080:8080 \
  -e DB_SERVER_URL=host.docker.internal \
  -e DB_SERVER_PORT=1433 \
  -e DB_SCHEMA=school \
  -e DB_USER=sa \
  -e DB_PWD=1q2w3e4R@ \
  -e SPRING_PROFILES_ACTIVE=default \
  sistema-escolar-api:1.1
```

A aplicação ficará disponível em:

```text
http://localhost:8080
```

> **Nota:** `host.docker.internal` permite que o container acesse serviços executados na máquina host. Em ambientes Linux, dependendo da configuração do Docker, pode ser necessário utilizar uma configuração de rede diferente.

---

## ⚙️ Profiles do Spring Boot

O profile ativo da aplicação é definido através da variável de ambiente:

```text
SPRING_PROFILES_ACTIVE
```

### Desenvolvimento (`default`)

Possui valores padrão para a conexão com o SQL Server e habilita `show-sql` e `ddl-auto=update`.

```sh
export SPRING_PROFILES_ACTIVE=default
```

### Produção (`prd`)

Exige todas as variáveis de ambiente e usa `ddl-auto=none`.

```sh
export SPRING_PROFILES_ACTIVE=prd
```

Ao executar com Docker:

```sh
docker run \
  -p 8080:8080 \
  -e SPRING_PROFILES_ACTIVE=prd \
  sistema-escolar-api:1.1
```

---

## 🔐 Variáveis de ambiente

As configurações de conexão com o banco de dados devem ser fornecidas através de variáveis de ambiente.

Variáveis utilizadas pela aplicação:

```text
DB_SERVER_URL
DB_SERVER_PORT
DB_SCHEMA
DB_USER
DB_PWD
SPRING_PROFILES_ACTIVE
```

### Exemplo

```text
DB_SERVER_URL=localhost
DB_SERVER_PORT=1433
DB_SCHEMA=school
DB_USER=sa
DB_PWD=1q2w3e4R@
SPRING_PROFILES_ACTIVE=default
```

> **Importante:** evite armazenar senhas, tokens ou outras credenciais diretamente no código-fonte ou no repositório Git.

---

## 📦 Docker — comandos úteis

### Criar a imagem

```sh
docker build -t sistema-escolar-api:1.1 .
```

### Executar o container

```sh
docker run \
  -p 8080:8080 \
  -e DB_SERVER_URL=host.docker.internal \
  -e DB_SERVER_PORT=1433 \
  -e DB_SCHEMA=school \
  -e DB_USER=sa \
  -e DB_PWD=1q2w3e4R@ \
  -e SPRING_PROFILES_ACTIVE=prd \
  sistema-escolar-api:1.1
```

### Listar containers em execução

```sh
docker ps
```

### Listar todos os containers

```sh
docker ps -a
```

### Parar um container

```sh
docker stop <container_id>
```

### Remover um container

```sh
docker rm <container_id>
```

### Listar imagens

```sh
docker images
```

### Remover uma imagem

```sh
docker rmi sistema-escolar-api:1.1
```

---

## 🔒 Segurança

Não versione credenciais reais no repositório.

Recomenda-se utilizar um arquivo `.env` local para desenvolvimento e adicioná-lo ao `.gitignore`:

```gitignore
.env
```

Para facilitar a configuração de novos ambientes, pode ser criado um arquivo `.env.example`:

```env
DB_SERVER_URL=localhost
DB_SERVER_PORT=1433
DB_SCHEMA=school
DB_USER=sa
DB_PWD=1q2w3e4R@
SPRING_PROFILES_ACTIVE=default
```

O arquivo `.env.example` pode ser versionado, enquanto o `.env` contendo credenciais reais deve permanecer fora do repositório.
