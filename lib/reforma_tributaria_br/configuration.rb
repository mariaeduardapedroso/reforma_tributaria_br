# frozen_string_literal: true

module ReformaTributariaBr
  # Guarda as alíquotas padrão usadas pela calculadora de tributos.
  #
  # As alíquotas da Reforma Tributária ainda estão em regulamentação, por isso
  # ficam configuráveis e NÃO vêm cravadas com valores oficiais. Defina os
  # valores que se aplicam ao seu caso via +ReformaTributariaBr.configure+.
  class Configuration
    # Alíquota da CBS (Contribuição sobre Bens e Serviços), em %.
    attr_reader :aliquota_cbs
    # Alíquota do IBS (Imposto sobre Bens e Serviços), em %.
    attr_reader :aliquota_ibs
    # Alíquota padrão do IS (Imposto Seletivo), em %.
    attr_reader :aliquota_is

    def initialize
      @aliquota_cbs = 0.0
      @aliquota_ibs = 0.0
      @aliquota_is = 0.0
    end

    def aliquota_cbs=(valor)
      @aliquota_cbs = validar_aliquota(valor, "aliquota_cbs")
    end

    def aliquota_ibs=(valor)
      @aliquota_ibs = validar_aliquota(valor, "aliquota_ibs")
    end

    def aliquota_is=(valor)
      @aliquota_is = validar_aliquota(valor, "aliquota_is")
    end

    private

    def validar_aliquota(valor, nome)
      numero = Float(valor)
      raise ConfiguracaoInvalida, "#{nome} não pode ser negativa: #{valor.inspect}" if numero.negative?

      numero
    rescue ArgumentError, TypeError
      raise ConfiguracaoInvalida, "#{nome} deve ser numérica: #{valor.inspect}"
    end
  end
end
