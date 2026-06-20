# frozen_string_literal: true

RSpec.describe ReformaTributariaBr::Cnpj do
  describe ".dv" do
    it "calcula o DV de um CNPJ numérico conhecido" do
      expect(described_class.dv("112223330001")).to eq("81")
    end

    it "aceita base com máscara e minúsculas" do
      expect(described_class.dv("11.222.333/0001")).to eq("81")
    end

    it "calcula um DV numérico para base alfanumérica" do
      expect(described_class.dv("12ABC34501DE")).to match(/\A\d{2}\z/)
    end

    it "levanta erro com base de tamanho inválido" do
      expect { described_class.dv("123") }.to raise_error(ReformaTributariaBr::CnpjInvalido)
    end
  end

  describe ".valido?" do
    it "valida um CNPJ numérico legado com máscara" do
      expect(described_class.valido?("11.222.333/0001-81")).to be(true)
    end

    it "rejeita DV incorreto" do
      expect(described_class.valido?("11.222.333/0001-99")).to be(false)
    end

    it "rejeita tamanho inválido" do
      expect(described_class.valido?("123")).to be(false)
    end

    it "rejeita nil sem levantar erro" do
      expect(described_class.valido?(nil)).to be(false)
    end
  end

  describe ".normalizar" do
    it "remove a máscara e coloca em maiúsculas" do
      expect(described_class.normalizar("12.abc.345/01de-35")).to eq("12ABC34501DE35")
    end
  end

  describe ".formatar" do
    it "aplica a máscara padrão" do
      expect(described_class.formatar("11222333000181")).to eq("11.222.333/0001-81")
    end

    it "levanta erro para tamanho inválido" do
      expect { described_class.formatar("123") }.to raise_error(ReformaTributariaBr::CnpjInvalido)
    end
  end

  describe ".gerar" do
    it "gera sempre um CNPJ válido (round-trip)" do
      20.times { expect(described_class.valido?(described_class.gerar)).to be(true) }
    end
  end
end
