require_relative './base_generator'

module Generators
  class Uniform < BaseGenerator
    R0 = 104_999.0
    A  = 21_400_000.0
    M  = 42_949_672.0

    def initialize
      @enum = Enumerator.new do |enum|
        r = R0

        loop do
          r = (A * r) % M

          enum.yield r / M
        end
      end
    end

    def next
      @enum.next
    end
  end
end
