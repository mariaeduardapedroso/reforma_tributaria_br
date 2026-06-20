# frozen_string_literal: true

module ReformaTributariaBr
  module Rails
    # Ponto de integração com o boot do Rails. Carregado apenas quando o Rails
    # está presente. Mantido enxuto na v0.1 — é o espaço reservado para, no
    # futuro, registrar traduções (I18n pt-BR), generators e configuração.
    class Railtie < ::Rails::Railtie
      # Ganchos de inicialização entram aqui em versões futuras.
    end
  end
end
