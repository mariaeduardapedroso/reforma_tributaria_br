# frozen_string_literal: true

module ReformaTributariaBr
  module Tributos
    # Trio de alíquotas (em %) efetivamente aplicado em um cálculo.
    Aliquotas = Struct.new(:cbs, :ibs, :is) do
      # Resolve alíquotas omitidas (nil) para os defaults da configuração global.
      def self.resolver(cbs: nil, ibs: nil, is: nil)
        config = ReformaTributariaBr.configuration
        new(
          Float(cbs.nil? ? config.aliquota_cbs : cbs),
          Float(ibs.nil? ? config.aliquota_ibs : ibs),
          Float(is.nil? ? config.aliquota_is : is)
        )
      end
    end
  end
end
