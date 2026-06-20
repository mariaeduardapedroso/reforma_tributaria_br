# frozen_string_literal: true

require "reforma_tributaria_br"

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :expect }
  config.disable_monkey_patching!
  config.order = :random
  Kernel.srand config.seed

  # Cada exemplo começa com a configuração de alíquotas zerada.
  config.after { ReformaTributariaBr.reset_configuration! }
end
