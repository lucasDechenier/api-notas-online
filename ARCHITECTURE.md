# Arquitetura da API Notas Online

## 🏗️ Visão Geral

Esta API REST segue o padrão **MVC (Model-View-Controller)** do Rails em modo API, com MongoDB como banco de dados NoSQL.

## 📊 Diagrama de Relacionamentos

```
School (Escola)
├── has_many :users (Usuários)
├── has_many :students (Alunos)
├── has_many :subjects (Disciplinas)
└── has_many :grades (Notas)

User (Usuário)
├── belongs_to :school
└── has_many :subjects (como teacher)

Student (Aluno)
├── belongs_to :school
└── has_many :grades

Subject (Disciplina)
├── belongs_to :school
├── belongs_to :teacher (User)
└── has_many :grades

Grade (Nota)
├── belongs_to :school
├── belongs_to :student
└── belongs_to :subject
```

## 🔐 Fluxo de Autenticação

```
1. Cliente → POST /users/login (email + senha)
2. API → Valida credenciais com BCrypt
3. API → Gera JWT com payload:
   - user_id
   - school_id
   - user_type
   - exp (48h)
4. API → Retorna token JWT
5. Cliente → Envia token em todas as requisições:
   Authorization: Bearer <token>
6. API → Valida token em cada requisição
7. API → Extrai current_user e current_school
```

## 🎯 Arquitetura de Controllers

### ApplicationController
- **Base para todos os controllers**
- Include `Authenticable` concern
- Tratamento global de exceções
- Rescue de erros Mongoid

### Concerns

#### Authenticable
- `authenticate_user!` - Verifica token JWT
- `current_user` - Usuário autenticado
- `current_school` - Escola do usuário
- `authorize_admin!` - Restrição para admins
- `authorize_teacher_or_admin!` - Restrição para professores e admins

#### JsonWebToken
- `encode(payload)` - Gera token JWT
- `decode(token)` - Decodifica e valida token

### Controllers Específicos

#### SchoolsController
- **Público**: `create`
- **Autenticado**: `index`, `show`
- **Admin**: `update`, `destroy`

#### UsersController
- **Público**: `create`, `login`
- **Autenticado**: `me`, `show`, `update`
- **Admin**: `index`, `destroy`

#### StudentsController
- **Teacher/Admin**: `index`, `show`, `create`, `update`
- **Admin**: `destroy`

#### SubjectsController
- **Teacher/Admin**: Todos os endpoints
- **Filtros**: Professores veem apenas suas disciplinas

#### GradesController
- **Teacher/Admin**: Todos os endpoints
- **Filtros**: Professores veem apenas notas das suas disciplinas

## 🗄️ Camada de Dados (Models)

### Validações Principais

#### School
```ruby
validates :name, presence: true
validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
```

#### User
```ruby
validates :name, presence: true
validates :email, presence: true, uniqueness: true
validates :user_type, inclusion: { in: %w[admin teacher] }
validates :school, presence: true
has_secure_password
```

#### Student
```ruby
validates :name, presence: true
validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
validates :registration_number, presence: true, uniqueness: { scope: :school_id }
index({ school_id: 1, registration_number: 1 }, { unique: true })
```

#### Subject
```ruby
validates :name, presence: true
validates :code, presence: true, uniqueness: { scope: :school_id }
validates :number_of_grades, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 3 }
index({ school_id: 1, code: 1 }, { unique: true })
```

#### Grade
```ruby
validates :student, presence: true
validates :subject, presence: true
validate :unique_grade_per_student_per_subject
validate :scores_count_matches_subject
validate :all_scores_are_valid
before_save :calculate_average
index({ student_id: 1, subject_id: 1 }, { unique: true })
```

## 🔒 Regras de Negócio

### Isolamento por Escola (Multitenancy)
- Todos os dados são filtrados por `current_school`
- Usuário só acessa dados da sua escola
- Tokens JWT contêm `school_id`

### Hierarquia de Permissões
```
Admin > Teacher
```

**Admin pode:**
- Gerenciar todas as entidades
- Ver todos os dados
- Excluir registros

**Teacher pode:**
- Ver alunos
- Gerenciar suas disciplinas
- Lançar notas nas suas disciplinas
- Editar seu perfil

### Regras de Notas
1. Quantidade limitada pela disciplina (1-3)
2. Valores entre 0 e 10
3. Cálculo automático de média
4. Status automático baseado nas médias configuradas
5. Um registro por aluno por disciplina

### Cálculo de Status
```ruby
if average >= passing_average
  'approved'
elsif average >= recovery_average
  'recovery'
else
  'failed'
end
```

## 🐳 Infraestrutura Docker

### Serviços

#### mongodb
- Imagem: mongo:7
- Porta: 27017
- Credenciais: admin/admin123
- Volume persistente: mongodb_data

#### api
- Build: Dockerfile local
- Porta: 3000
- Variáveis de ambiente via docker-compose
- Volume de código (desenvolvimento)
- Volume de gems cache

### Rede
- Bridge network `api-network`
- Comunicação interna entre serviços

## 📡 Formato de Resposta

### Sucesso
```json
{
  "id": "...",
  "name": "...",
  "created_at": "...",
  "updated_at": "..."
}
```

### Erro de Validação
```json
{
  "errors": [
    "Name can't be blank",
    "Email is invalid"
  ]
}
```

### Erro de Autenticação
```json
{
  "error": "Invalid or expired token"
}
```

### Erro de Permissão
```json
{
  "error": "Access denied"
}
```

## 🔄 Fluxo de Requisição

```
1. Cliente envia requisição HTTP
2. Rack::Cors verifica CORS
3. Rails Router direciona para controller
4. Before filters executam:
   - authenticate_user! (se necessário)
   - authorize_admin! (se necessário)
   - set_resource
5. Action do controller executa
6. Model realiza operações no MongoDB
7. Controller renderiza JSON
8. Response retorna ao cliente
```

## 🎨 Padrões de Código

### Clean Code
- Nomes descritivos e claros
- Métodos com responsabilidade única
- DRY (Don't Repeat Yourself)
- Concerns para lógica compartilhada

### Rails Conventions
- RESTful routes
- Naming conventions
- Fat models, skinny controllers
- Service objects para lógica complexa

### Segurança
- Tokens JWT com expiração
- Senhas criptografadas com BCrypt
- Validação de entrada
- Autorização em múltiplos níveis
- CORS configurado

## 📈 Escalabilidade

### Horizontal
- API stateless (JWT)
- Sem sessões no servidor
- Pode rodar múltiplas instâncias

### Vertical
- MongoDB suporta sharding
- Índices otimizados
- Queries eficientes por escola

## 🧪 Testabilidade

A arquitetura facilita testes:
- Models isolados
- Controllers com injeção de dependência
- Concerns testáveis independentemente
- MongoDB em memória para testes

## 📊 Monitoramento

Pontos de observabilidade:
- Health check: `/up`
- Logs estruturados
- Timestamps em todos os modelos
- Rastreamento por escola (multitenancy)
