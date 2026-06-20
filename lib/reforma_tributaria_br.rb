# frozen_string_literal: true

require_relative "reforma_tributaria_br/version"
require_relative "reforma_tributaria_br/errors"
require_relative "reforma_tributaria_br/configuration"
require_relative "reforma_tributaria_br/cnpj/alfanumerico"
require_relative "reforma_tributaria_br/tributos/aliquotas"
require_relative "reforma_tributaria_br/tributos/resultado"
require_relative "reforma_tributaria_br/tributos/calculadora"

# Utilidades da Reforma Tributária brasileira (EC 132/2023 + LC 214/2025):
# CNPJ alfanumérico e cálculo dos novos tributos CBS, IBS e IS.
#
# O núcleo é Ruby puro. A camada de integração com o Rails (validador
# ActiveModel + Railtie) é carregada automaticamente apenas quando o Rails
# está presente, então nada quebra em scripts Ruby simples.
module ReformaTributariaBr
  class << self
    # Configuração global (alíquotas padrão). Singleton preguiçoso.
    def configuration
      @configuration ||= Configuration.new
    end

    # Bloco de configuração:
    #
    #   ReformaTributariaBr.configure do |c|
    #     c.aliquota_cbs = 8.8
    #     c.aliquota_ibs = 17.7
    #   end
    def configure
      yield(configuration) if block_given?
      configuration
    end

    # Restaura a configuração para os valores padrão (zerados). Útil em testes.
    def reset_configuration!
      @configuration = Configuration.new
    end
  end
end

# Integração opcional com o Rails — autodetectada, sem dependência obrigatória.
require_relative "reforma_tributaria_br/rails/cnpj_validator" if defined?(ActiveModel)
require_relative "reforma_tributaria_br/rails/railtie" if defined?(::Rails::Railtie)
