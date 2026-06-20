# frozen_string_literal: true

module ReformaTributariaBr
  module Tributos
    # Calcula CBS, IBS e IS sobre uma base de cálculo.
    #
    # Por padrão o cálculo é "por fora": cada tributo = base * alíquota / 100, e
    # o valor total = base + soma dos tributos. Alíquotas omitidas (nil) usam os
    # valores definidos em +ReformaTributariaBr.configure+.
    module Calculadora
      module_function

      def calcular(base:, aliquota_cbs: nil, aliquota_ibs: nil, aliquota_is: nil)
        base = Float(base)
        raise ArgumentError, "base não pode ser negativa: #{base}" if base.negative?

        aliquotas = Aliquotas.resolver(cbs: aliquota_cbs, ibs: aliquota_ibs, is: aliquota_is)

        Resultado.new(
          base.round(2),
          aplicar(base, aliquotas.cbs),
          aplicar(base, aliquotas.ibs),
          aplicar(base, aliquotas.is),
          aliquotas
        )
      end

      # Aplica uma alíquota (em %) sobre a base, arredondando a 2 casas.
      def aplicar(base, aliquota)
        (base * aliquota / 100.0).round(2)
      end
    end

    module_function

    # Atalho de conveniência: ReformaTributariaBr::Tributos.calcular(...).
    def calcular(...)
      Calculadora.calcular(...)
    end
  end
end
