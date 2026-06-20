# frozen_string_literal: true

require_relative "lib/reforma_tributaria_br/version"

Gem::Specification.new do |spec|
  spec.name = "reforma_tributaria_br"
  spec.version = ReformaTributariaBr::VERSION
  spec.authors = ["Maria Eduarda Pedroso"]
  spec.email = ["mpedroso@alunos.utfpr.edu.br"]

  spec.summary = "Utilidades da Reforma Tributária brasileira: CNPJ alfanumérico e cálculo de CBS/IBS/IS."
  spec.description = "Gem Ruby com validação, geração e formatação de CNPJ alfanumérico " \
                     "(vigente a partir de julho/2026) e cálculo configurável dos novos tributos " \
                     "CBS, IBS e IS da Reforma Tributária (EC 132/2023 + LC 214/2025). Núcleo em " \
                     "Ruby puro com integração opcional ao Rails via validador ActiveModel."
  spec.homepage = "https://github.com/mariaeduardapedroso/reforma_tributaria_br"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir["lib/**/*.rb", "README.md", "CHANGELOG.md", "LICENSE.txt"]
  spec.require_paths = ["lib"]
end
