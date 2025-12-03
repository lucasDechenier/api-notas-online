---
applyTo: '**/*_spec.rb'
---
Coding standards, domain knowledge, and preferences that AI should follow.

## Sobre os testes neste projeto

*   **Framework:** RSpec
*   **Factory:** FactoryBot
*   **Foco:** Testes de unidade e integração, seguindo as melhores práticas do BDD (Behavior-Driven Development).

## Regras para escrita de testes

*   **Estrutura BDD:**
    *   **`describe`**: Use para o objeto, classe ou método que está sendo testado.
    *   **`context`**: Use para agrupar testes sob a mesma condição ou estado (ex: "when user is an admin", "with invalid attributes").
    *   **`it`**: Use para descrever o comportamento esperado. A descrição deve ser clara e em inglês, começando com um verbo na terceira pessoa (ex: `it 'creates a new document'`).

*   **Dados de Teste:**
    *   **Factories:** Use `FactoryBot` para criar instâncias de models (ex: `build(:user)`, user `create(:user)` somente quando o teste necessitar de persistencia).
    *   **`let` e `let!`**: Prefira `let` para inicialização preguiçosa (lazy-loading) de variáveis. Use `let!` apenas quando o objeto precisar ser criado antes de cada teste, como em testes de controller que esperam um registro no banco.
    *   **Datas fixas:** Para testes que envolvem datas em períodos fixos, use a gem `timecop` para controlar o tempo. Exemplo: `Timecop.freeze(Date.new(2023, 1, 1))` para fixar uma data específica durante o teste.
    *   **Clareza:** Evite lógica complexa na criação de dados de teste. Mantenha simples e direto.

*   **Asserções (Expectations):**
    *   **Matchers:** Use os matchers do RSpec que melhor expressam o comportamento esperado (ex: `change`, `be_valid`, `have_http_status(:ok)`).

*   **Mocks e Stubs:**
    *   Use `allow` e `receive` para stubar métodos de dependências externas (ex: chamadas a APIs como AWS S3, Sieg, etc.) para isolar o teste e torná-lo mais rápido e determinístico.
    *   Evite usar `have_received` para verificar se um método foi chamado, pois isso pode exigir a execução de código não desejado.
    *   Evite usar `double` para criar mocks, prefira `instance_double` para garantir que o mock tenha os métodos corretos, sempre utilize a referência da classe em si, nunca como string.
    *   Exemplo correto: `instance_double(Aws::S3::Client)` 
    *   Exemplo incorreto: `instance_double('Aws::S3::Client')`
    *   Evite usar `and_call_original` em stubs, pois isso pode levar a comportamentos inesperados. Use `and_return` para retornar valores específicos.
    *   Nunca use `instance_variable_get` ou `instance_variable_set` nos testes. Teste sempre através da interface pública da classe.
    *   Exemplo: `allow(Aws::S3::Client).to receive_message_chain(:new, :put_object).and_return(true)`

*   **Organização:**
    *   Sempre coloque o RSpec dentro do modulo da classe sendo testada
    *   Use `type: :model`, `type: :controller`, etc., para especificar o tipo de teste, para verificar o tipo correto olhar em qual pasta onde a classe sendo testada está localizada. Normalmente `app/{type}`.
    *   Se o teste não necessitar de persistencia adicione o parametro `nodb: true` para evitar que o RSpec crie uma transação de banco de dados, tornando o teste mais rápido.
*   **O que testar:**
    *   Teste sempre o comportamento esperado da classe ou método, não a implementação interna.
    *   Verifique se os métodos públicos estão funcionando corretamente.
    *   Nunca testar métodos privados diretamente, mas sim através de métodos públicos que os utilizam.
    *   Nunca testar métodos de classes de herança
    *   Teste as rotas e ações dos controllers.
    *   Verifique se os serviços externos estão sendo chamados corretamente (ex: APIs, serviços de terceiros).
    *   Teste cenários de sucesso e falha, incluindo casos de borda.
    **IMPORTANTE:** 
    *   Não use o parâmetro `-v` pois ele apenas exibe a versão do RSpec e não executa os testes. Para executar com output verboso use `--format documentation`.
    *   Para rodar os testes utilize o comando `bundle exec rspec` ou `rspec`

## Exemplo de um teste de model

```ruby
require 'rails_helper'

module Documents
  RSpec.describe Document, type: :model do
    describe 'validations' do
      context 'when creating a new document' do
        it 'is valid with valid attributes' do
          document = build(:document)
          expect(document).to be_valid
        end

        it 'is invalid without a title' do
          document = build(:document, title: nil)
          expect(document).not_to be_valid
          expect(document.errors[:title]).to include("can't be blank")
        end
      end
    end

    describe '#archive' do
      it 'sets archived_at timestamp' do
        document = create(:document)
        document.archive
        expect(document.archived_at).to be_present
      end
    end

    describe '#expires_at' do
      context 'when working with fixed dates' do
        around do |example|
          Timecop.freeze(Date.new(2023, 6, 15)) do
            example.run
          end
        end

        it 'sets expiration 30 days from creation' do
          document = create(:document)
          expect(document.expires_at).to eq(Date.new(2023, 7, 15))
        end
      end
    end
  end
end
```