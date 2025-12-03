# API Notas Online

API REST desenvolvida em Ruby on Rails (modo API) com MongoDB como banco de dados, representando um sistema escolar multilocatário.

## 📋 Sobre o Projeto

Sistema de gerenciamento escolar onde:
- Todos os dados pertencem a uma **escola** (multilocatário)
- Usuários podem ser **admin** ou **teacher** (professor)
- Admins gerenciam todos os dados da escola
- Professores gerenciam apenas suas próprias disciplinas e notas

## 🛠️ Tecnologias

- Ruby 3.1.4
- Rails 7.2.3 (modo API)
- MongoDB 7
- Mongoid (ODM)
- JWT (autenticação)
- BCrypt (criptografia de senhas)
- Docker & Docker Compose

## 📦 Estrutura de Dados

### Entidades

1. **School** (Escola)
   - Nome, endereço, telefone, e-mail
   - Entidade principal do sistema

2. **User** (Usuário)
   - Nome, e-mail, senha, tipo (admin/teacher), endereço
   - Pertence a uma escola
   - Gera token JWT para autenticação

3. **Student** (Aluno)
   - Nome, e-mail, matrícula, telefone
   - Pertence a uma escola
   - Matrícula única por escola

4. **Subject** (Disciplina)
   - Nome, código, quantidade de notas (1-3)
   - Médias de aprovação e recuperação
   - Possui um professor responsável
   - Código único por escola

5. **Grade** (Nota)
   - Lista de notas numéricas (0-10)
   - Cálculo automático de média
   - Status: aprovado, recuperação ou reprovado
   - Um registro por aluno por disciplina

## 🚀 Como Executar

### Pré-requisitos

- Docker
- Docker Compose

### Iniciando a aplicação

```bash
# Subir os containers (API + MongoDB)
docker-compose up --build

# A API estará disponível em: http://localhost:3000
# MongoDB estará em: localhost:27017
```

### Parando a aplicação

```bash
docker-compose down

# Para remover volumes (dados do banco)
docker-compose down -v
```

## 🔐 Autenticação

A API utiliza JWT (JSON Web Token) com expiração de **48 horas**.

### Endpoints públicos (sem autenticação):
- `POST /schools` - Criar escola
- `POST /users` - Criar usuário
- `POST /users/login` - Login

### Headers para endpoints autenticados:
```
Authorization: Bearer {seu_token_jwt}
```

## 📚 Endpoints da API

### Schools (Escolas)

```bash
# Criar escola (público)
POST /schools
{
  "school": {
    "name": "Escola ABC",
    "email": "contato@escolaabc.com",
    "address": "Rua X, 123",
    "phone": "(11) 99999-9999"
  }
}

# Listar escolas (autenticado)
GET /schools

# Ver escola específica
GET /schools/:id

# Atualizar escola (admin)
PUT /schools/:id

# Deletar escola (admin)
DELETE /schools/:id
```

### Users (Usuários)

```bash
# Criar usuário (público)
POST /users
{
  "user": {
    "name": "João Silva",
    "email": "joao@example.com",
    "password": "senha123",
    "password_confirmation": "senha123",
    "user_type": "admin",
    "school_id": "school_id_aqui"
  }
}

# Login (público)
POST /users/login
{
  "email": "joao@example.com",
  "password": "senha123"
}

# Ver perfil atual
GET /users/me

# Listar usuários (admin)
GET /users

# Ver usuário específico
GET /users/:id

# Atualizar usuário
PUT /users/:id

# Deletar usuário (admin)
DELETE /users/:id
```

### Students (Alunos)

```bash
# Criar aluno
POST /students
{
  "student": {
    "name": "Maria Santos",
    "email": "maria@example.com",
    "registration_number": "2024001",
    "phone": "(11) 88888-8888"
  }
}

# Listar alunos
GET /students

# Ver aluno específico
GET /students/:id

# Atualizar aluno
PUT /students/:id

# Deletar aluno (admin)
DELETE /students/:id
```

### Subjects (Disciplinas)

```bash
# Criar disciplina
POST /subjects
{
  "subject": {
    "name": "Matemática",
    "code": "MAT101",
    "number_of_grades": 3,
    "passing_average": 7.0,
    "recovery_average": 5.0,
    "teacher_id": "teacher_id_aqui"
  }
}

# Listar disciplinas (admin vê todas, professor vê as suas)
GET /subjects

# Ver disciplina específica
GET /subjects/:id

# Atualizar disciplina
PUT /subjects/:id

# Deletar disciplina
DELETE /subjects/:id
```

### Grades (Notas)

```bash
# Criar registro de notas
POST /grades
{
  "grade": {
    "student_id": "student_id_aqui",
    "subject_id": "subject_id_aqui",
    "scores": [8.5, 7.0]
  }
}

# Listar notas (com filtros opcionais)
GET /grades
GET /grades?student_id=xxx
GET /grades?subject_id=xxx

# Ver nota específica
GET /grades/:id

# Adicionar uma nota
PUT /grades/:id
{
  "grade": {
    "add_score": 9.0
  }
}

# Atualizar uma nota específica
PUT /grades/:id
{
  "grade": {
    "score_index": 0,
    "update_score": 8.0
  }
}

# Atualizar todas as notas
PUT /grades/:id
{
  "grade": {
    "scores": [8.0, 7.5, 9.0]
  }
}

# Deletar registro de notas
DELETE /grades/:id
```

## 🔒 Regras de Permissão

### Admin
- Gerencia todos os dados da escola
- Pode criar, editar e excluir qualquer recurso
- Vê todos os dados da escola

### Teacher (Professor)
- Vê todos os alunos da escola
- Gerencia apenas suas próprias disciplinas
- Lança e edita notas apenas das suas disciplinas
- Não pode excluir alunos
- Pode editar apenas seu próprio perfil

### Validações Importantes
- Matrícula de aluno é única por escola
- Código de disciplina é único por escola
- Apenas um registro de notas por aluno por disciplina
- Quantidade de notas limitada pela configuração da disciplina (1-3)
- Todas as notas devem estar entre 0 e 10

## 🎯 Status de Notas

O sistema calcula automaticamente o status do aluno:
- **approved**: média >= média de aprovação
- **recovery**: média >= média de recuperação e < média de aprovação
- **failed**: média < média de recuperação
- **incomplete**: nem todas as notas foram lançadas

## 📝 Variáveis de Ambiente

As seguintes variáveis são configuradas no `docker-compose.yml`:

```yaml
MONGODB_HOST=mongodb
MONGODB_PORT=27017
MONGODB_USERNAME=admin
MONGODB_PASSWORD=admin123
MONGODB_DATABASE=api_notas_development
RAILS_ENV=development
```

## 🧪 Testando a API

Você pode usar ferramentas como:
- Postman
- Insomnia
- cURL
- HTTPie

Exemplo com cURL:

```bash
# Criar uma escola
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

# Criar um usuário admin
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

# Login
curl -X POST http://localhost:3000/users/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@escola.com",
    "password": "senha123"
  }'
```

## 📂 Estrutura do Projeto

```
api-notas-online/
├── app/
│   ├── controllers/
│   │   ├── concerns/
│   │   │   ├── authenticable.rb
│   │   │   └── json_web_token.rb
│   │   ├── schools_controller.rb
│   │   ├── users_controller.rb
│   │   ├── students_controller.rb
│   │   ├── subjects_controller.rb
│   │   └── grades_controller.rb
│   └── models/
│       ├── school.rb
│       ├── user.rb
│       ├── student.rb
│       ├── subject.rb
│       └── grade.rb
├── config/
│   ├── mongoid.yml
│   └── routes.rb
├── docker-compose.yml
├── Dockerfile
└── README.md
```

## 👥 Autor

Desenvolvido seguindo as melhores práticas de Clean Code e Rails.

## 📄 Licença

Este projeto é de código aberto.
