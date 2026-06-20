# frozen_string_literal: true

require "active_model"
require "reforma_tributaria_br/rails/cnpj_validator"

RSpec.describe "CnpjValidator (integração ActiveModel)" do
  # Modelo ActiveModel "de mentira" — não precisa de um app Rails inteiro.
  let(:model_class) do
    Class.new do
      include ActiveModel::Validations
      attr_accessor :cnpj
      validates :cnpj, cnpj: true

      def self.name
        "Empresa"
      end
    end
  end

  it "aceita um CNPJ válido" do
    record = model_class.new
    record.cnpj = ReformaTributariaBr::Cnpj.gerar
    expect(record).to be_valid
  end

  it "rejeita um CNPJ inválido com mensagem em pt-BR" do
    record = model_class.new
    record.cnpj = "11.222.333/0001-99"

    expect(record).not_to be_valid
    expect(record.errors[:cnpj]).to include("não é um CNPJ válido")
  end

  context "com a opção normalizar: true" do
    let(:model_class) do
      Class.new do
        include ActiveModel::Validations
        attr_accessor :cnpj
        validates :cnpj, cnpj: { normalizar: true }

        def self.name
          "Empresa"
        end
      end
    end

    it "grava o valor normalizado no atributo" do
      record = model_class.new
      record.cnpj = "11.222.333/0001-81"
      record.valid?
      expect(record.cnpj).to eq("11222333000181")
    end
  end
end
