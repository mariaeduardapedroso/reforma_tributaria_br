# frozen_string_literal: true

module ReformaTributariaBr
  module Tributos
    # Resultado imutável de um cálculo de tributos. Todos os valores monetários
    # em R$, arredondados a 2 casas decimais.
    Resultado = Struct.new(:base, :cbs, :ibs, :is, :aliquotas) do
      # Soma dos três tributos (CBS + IBS + IS).
      def total_tributos
        (cbs + ibs + is).round(2)
      end

      # Base de cálculo acrescida dos tributos.
      def valor_total
        (base + total_tributos).round(2)
      end

      # Hash com todos os campos — útil para preencher NF-e ou relatórios.
      def to_h
        {
          base: base,
          cbs: cbs,
          ibs: ibs,
          is: is,
          total_tributos: total_tributos,
          valor_total: valor_total,
          aliquotas: { cbs: aliquotas.cbs, ibs: aliquotas.ibs, is: aliquotas.is }
        }
      end
    end
  end
end
