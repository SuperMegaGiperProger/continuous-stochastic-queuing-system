require_relative './base_characteristic'

module Characteristics
  class AverageTimeInQueue < BaseCharacteristic
    def initialize(max_count)
      @prev_count = 0
      @requests = Array.new(max_count)
      @l = 0
      @r = -1

      @sum   = 0
      @count = 0
    end

    def update(queue:, channel:, spend_time:)
      curr_count = queue.size
      
      if curr_count < @prev_count
        reduce_queue(@prev_count - curr_count)
      elsif curr_count > @prev_count
        increase_queue(curr_count - @prev_count)
      end

      update_requests spend_time
      @prev_count = curr_count
    end

    def value
      @sum / @count.to_f
    end

    private

    def reduce_queue(count)
      count.times do
        @sum += @requests[@l]
        @l += 1
      end

      @count += count
    end

    def increase_queue(count)
      count.times do
        @r += 1
        @requests[@r] = 0
      end
    end

    def update_requests(spend_time)
      @l.upto @r do |i|
        @requests[i] += spend_time
      end
    end
  end
end
