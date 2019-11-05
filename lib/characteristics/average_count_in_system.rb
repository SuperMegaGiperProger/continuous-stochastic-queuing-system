require_relative './base_characteristic'

module Characteristics
  class AverageCountInSystem < BaseCharacteristic
    def initialize
      @sum      = 0
      @all_time = 0
    end

    def update(queue:, channel:, spend_time:)
      count = queue.size
      count += 1 if channel.busy?

      @sum += count * spend_time
      @all_time += spend_time
    end

    def value
      @sum / @all_time.to_f
    end
  end
end
