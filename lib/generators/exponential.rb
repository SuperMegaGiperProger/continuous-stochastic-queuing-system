require_relative './base_generator'
require_relative './uniform'

module Generators
  class Exponential < BaseGenerator
    def initialize(intensity)
      @lambda = intensity

      @uniform = Uniform.new
    end

    def next
      - Math.log(rand) / @lambda
    end
  end
end
