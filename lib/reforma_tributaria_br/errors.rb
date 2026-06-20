# frozen_string_literal: true

module ReformaTributariaBr
  # Erro base da biblioteca. Capture esta classe para tratar qualquer erro da gem.
  class Error < StandardError; end

  # CNPJ com formato ou dígitos inválidos onde um válido era esperado.
  class CnpjInvalido < Error; end

  # Configuração inválida (ex.: alíquota negativa ou não numérica).
  class ConfiguracaoInvalida < Error; end
end
