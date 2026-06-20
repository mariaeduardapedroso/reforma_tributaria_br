# frozen_string_literal: true

RSpec.describe ReformaTributariaBr::Tributos do
  describe ".calcular" do
    it "usa alíquotas explícitas (cálculo por fora)" do
      r = described_class.calcular(base: 1_000.0, aliquota_cbs: 8.8, aliquota_ibs: 17.7, aliquota_is: 0.0)

      expect(r.cbs).to eq(88.0)
      expect(r.ibs).to eq(177.0)
      expect(r.is).to eq(0.0)
      expect(r.total_tributos).to eq(265.0)
      expect(r.valor_total).to eq(1_265.0)
    end

    it "cai para as alíquotas configuradas quando omitidas" do
      ReformaTributariaBr.configure do |c|
        c.aliquota_cbs = 10.0
        c.aliquota_ibs = 20.0
      end

      r = described_class.calcular(base: 200.0)

      expect(r.cbs).to eq(20.0)
      expect(r.ibs).to eq(40.0)
    end

    it "aplica o Imposto Seletivo quando informado" do
      r = described_class.calcular(base: 500.0, aliquota_is: 8.0)
      expect(r.is).to eq(40.0)
    end

    it "expõe um hash completo via to_h" do
      r = described_class.calcular(base: 100.0, aliquota_cbs: 10.0)
      expect(r.to_h).to include(base: 100.0, cbs: 10.0, valor_total: 110.0)
    end

    it "rejeita base negativa" do
      expect { described_class.calcular(base: -1) }.to raise_error(ArgumentError)
    end
  end
end
