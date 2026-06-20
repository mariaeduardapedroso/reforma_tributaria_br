# frozen_string_literal: true

module ReformaTributariaBr
  module Rails
    # Validador ActiveModel: habilita +validates :campo, cnpj: true+ em models.
    #
    # Opções:
    #   normalizar: true  => grava o valor normalizado (sem máscara, maiúsculo)
    #                        de volta no atributo antes de validar.
    #   message: "..."    => mensagem de erro customizada.
    class CnpjValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        if options[:normalizar] && !value.nil?
          value = ReformaTributariaBr::Cnpj.normalizar(value)
          record.public_send("#{attribute}=", value)
        end

        return if ReformaTributariaBr::Cnpj.valido?(value.to_s)

        record.errors.add(attribute, :invalid_cnpj, message: options[:message] || "não é um CNPJ válido")
      end
    end
  end
end

# Disponibiliza como `validates :campo, cnpj: true` — ao encontrar a chave :cnpj,
# o ActiveModel procura a constante de topo `CnpjValidator`.
CnpjValidator = ReformaTributariaBr::Rails::CnpjValidator unless defined?(CnpjValidator)
