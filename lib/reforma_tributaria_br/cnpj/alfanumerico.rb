# frozen_string_literal: true

module ReformaTributariaBr
  # Validação, cálculo de dígito verificador, normalização, formatação e geração
  # de CNPJ no novo formato alfanumérico (vigente a partir de julho/2026).
  #
  # O CNPJ alfanumérico mantém 14 posições: 12 caracteres de base alfanuméricos
  # (A-Z e 0-9) + 2 dígitos verificadores, que permanecem numéricos. O cálculo
  # usa o algoritmo de módulo 11, convertendo cada caractere pelo seu código
  # ASCII menos 48 (assim '0'..'9' => 0..9, 'A' => 17, 'B' => 18, ...).
  #
  # É retrocompatível com o CNPJ puramente numérico atual.
  module Cnpj
    PESOS_DV1 = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2].freeze
    PESOS_DV2 = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2].freeze

    BASE_REGEX = /\A[0-9A-Z]{12}\z/
    COMPLETO_REGEX = /\A[0-9A-Z]{12}\d{2}\z/
    CARACTERES_VALIDOS = (("0".."9").to_a + ("A".."Z").to_a).freeze

    module_function

    # Converte um caractere para seu valor de cálculo (código ASCII - 48).
    def valor(caractere)
      caractere.ord - 48
    end

    # Remove a máscara (pontos, barra, hífen, espaços) e coloca em maiúsculas.
    def normalizar(cnpj)
      String(cnpj).gsub(/[^0-9A-Za-z]/, "").upcase
    end

    # Calcula um único DV a partir de uma sequência e seus pesos (módulo 11).
    def calcular_digito(sequencia, pesos)
      soma = sequencia.chars.each_with_index.sum { |c, i| valor(c) * pesos[i] }
      resto = soma % 11
      resto < 2 ? 0 : 11 - resto
    end

    # Calcula os dois dígitos verificadores a partir dos 12 caracteres de base.
    # Retorna uma String de 2 dígitos (ex.: "81").
    def dv(base)
      base = normalizar(base)
      unless base.match?(BASE_REGEX)
        raise CnpjInvalido, "base deve ter 12 caracteres alfanuméricos: #{base.inspect}"
      end

      d1 = calcular_digito(base, PESOS_DV1)
      d2 = calcular_digito(base + d1.to_s, PESOS_DV2)
      "#{d1}#{d2}"
    end

    # Indica se um CNPJ (com ou sem máscara) é válido.
    def valido?(cnpj)
      limpo = normalizar(cnpj)
      return false unless limpo.match?(COMPLETO_REGEX)

      dv(limpo[0, 12]) == limpo[12, 2]
    end

    # Aplica a máscara 00.000.000/0000-00 ao CNPJ informado.
    def formatar(cnpj)
      limpo = normalizar(cnpj)
      raise CnpjInvalido, "CNPJ deve ter 14 caracteres: #{cnpj.inspect}" unless limpo.match?(COMPLETO_REGEX)

      format("%s.%s.%s/%s-%s", limpo[0, 2], limpo[2, 3], limpo[5, 3], limpo[8, 4], limpo[12, 2])
    end

    # Gera um CNPJ alfanumérico válido (útil para seeds e testes).
    def gerar
      base = Array.new(12) { CARACTERES_VALIDOS.sample }.join
      base + dv(base)
    end
  end
end
