# reforma_tributaria_br

[![CI](https://github.com/mariaeduardapedroso/reforma_tributaria_br/actions/workflows/ci.yml/badge.svg)](https://github.com/mariaeduardapedroso/reforma_tributaria_br/actions/workflows/ci.yml)
[![Gem Version](https://img.shields.io/gem/v/reforma_tributaria_br.svg)](https://rubygems.org/gems/reforma_tributaria_br)

Utilidades em Ruby para a **Reforma Tributária brasileira** (EC 132/2023 + LC 214/2025):

- ✅ **CNPJ alfanumérico** — validação, cálculo de dígito verificador, normalização,
  formatação e geração (novo formato vigente a partir de **julho/2026**).
- ✅ **Cálculo de tributos** — CBS, IBS e IS (Imposto Seletivo) com alíquotas configuráveis.
- ✅ **Integração opcional com Rails** — `validates :cnpj, cnpj: true`.

O núcleo é **Ruby puro** (sem dependência de Rails). A camada Rails é autodetectada:
só liga se o `ActiveModel`/`Rails` estiver presente.

> ⚠️ **Sobre as alíquotas:** as alíquotas de referência e as regras de transição
> (2026→2033) ainda estão em regulamentação. Por isso esta gem **não crava** valores
> oficiais — você informa as alíquotas que se aplicam ao seu caso.

## Instalação

Adicione ao `Gemfile`:

```ruby
gem "reforma_tributaria_br"
```

E rode:

```bash
bundle install
```

Ou instale direto:

```bash
gem install reforma_tributaria_br
```

## CNPJ alfanumérico

```ruby
require "reforma_tributaria_br"

ReformaTributariaBr::Cnpj.valido?("11.222.333/0001-81")   # => true  (CNPJ numérico legado)
ReformaTributariaBr::Cnpj.valido?("12.ABC.345/01DE-35")   # => true/false (novo formato)

ReformaTributariaBr::Cnpj.dv("12ABC34501DE")              # => "35"  (os 2 dígitos verificadores)
ReformaTributariaBr::Cnpj.normalizar("12.abc.345/01de-35") # => "12ABC34501DE35"
ReformaTributariaBr::Cnpj.formatar("12ABC34501DE35")      # => "12.ABC.345/01DE-35"

ReformaTributariaBr::Cnpj.gerar                           # => CNPJ alfanumérico válido (seeds/testes)
```

### Como funciona o algoritmo

O CNPJ alfanumérico mantém **14 posições**: 12 caracteres de base alfanuméricos
(`A-Z` e `0-9`) + 2 dígitos verificadores que **permanecem numéricos**. O cálculo usa
o tradicional **módulo 11**, convertendo cada caractere pelo seu código **ASCII − 48**
(assim `'0'..'9'` → `0..9`, `'A'` → `17`, `'B'` → `18`, …). Totalmente retrocompatível
com o CNPJ numérico atual.

## Cálculo de tributos (CBS / IBS / IS)

```ruby
# Defina suas alíquotas uma vez (valores ilustrativos):
ReformaTributariaBr.configure do |c|
  c.aliquota_cbs = 8.8    # % — federal (substitui PIS/COFINS)
  c.aliquota_ibs = 17.7   # % — estadual + municipal (substitui ICMS/ISS)
end

r = ReformaTributariaBr::Tributos.calcular(base: 1_000.00)

r.cbs            # => 88.0
r.ibs            # => 177.0
r.is             # => 0.0
r.total_tributos # => 265.0
r.valor_total    # => 1265.0
r.to_h           # => { base: 1000.0, cbs: 88.0, ibs: 177.0, is: 0.0,
                 #      total_tributos: 265.0, valor_total: 1265.0,
                 #      aliquotas: { cbs: 8.8, ibs: 17.7, is: 0.0 } }
```

Você também pode passar alíquotas pontuais (sobrescrevem a configuração) e o
Imposto Seletivo:

```ruby
ReformaTributariaBr::Tributos.calcular(base: 500.0, aliquota_is: 8.0)
```

> **Convenção de base:** o cálculo padrão é "por fora" — cada tributo = `base × alíquota ÷ 100`
> e `valor_total = base + soma dos tributos`. Ajuste as alíquotas conforme a regulamentação vigente.

## Uso com Rails

Em um app Rails, a integração é carregada automaticamente. Use o validador nos models:

```ruby
class Empresa < ApplicationRecord
  validates :cnpj, cnpj: true

  # opção: grava o valor normalizado (sem máscara, maiúsculo) antes de validar
  # validates :cnpj, cnpj: { normalizar: true }
end

empresa = Empresa.new(cnpj: "12.ABC.345/01DE-99")
empresa.valid?            # => false
empresa.errors[:cnpj]     # => ["não é um CNPJ válido"]
```

## Tratamento de erros

- `ReformaTributariaBr::Error` — classe base (capture-a para tratar qualquer erro da gem).
- `ReformaTributariaBr::CnpjInvalido` — base/CNPJ com formato inválido em `dv`/`formatar`.
- `ReformaTributariaBr::ConfiguracaoInvalida` — alíquota inválida na configuração.

> `valido?` **nunca** levanta erro — retorna `true`/`false` (inclusive para `nil`).

## Desenvolvimento

```bash
bin/setup            # ou: bundle install
bundle exec rspec    # roda os testes
bundle exec rubocop  # checa o estilo
```

## Roadmap (próximas versões)

- Transição de alíquotas ano a ano (2026 → 2033).
- Helpers dos campos de NF-e (grupos IBS/CBS/IS — NT 2025.001).
- Generator Rails (`rails g reforma_tributaria_br:install`) e I18n pt-BR completo.

## Licença

[MIT](LICENSE.txt).

---

> ℹ️ Esta gem é uma ferramenta de apoio e **não substitui orientação contábil/fiscal**.
> Confirme alíquotas e regras com a legislação vigente e seu contador.
