require_relative './base_characteristic'

module Characteristics
  class AverageTimeInSystem < BaseCharacteristic
    def initialize
      @prev_count = 0
      @requests = []

      @sum   = 0
      @count = 0
    end

    def update(queue:, channel:, spend_time:)
      curr_count = queue.size
      curr_count += 1 if channel.busy?
      
      if curr_count < @prev_count
        reduce_requests(@prev_count - curr_count)
      elsif curr_count > @prev_count
        increase_requests(curr_count - @prev_count)
      end

      update_requests spend_time
      @prev_count = curr_count
    end

    def value
      @sum / @count.to_f
    end

    private

    def reduce_requests(count)
      reduced = @requests.shift(count)

      @sum   += reduced.sum
      @count += count
    end

    def increase_requests(count)
      new_requests = Array.new(count, 0.0)

      @requests.concat new_requests
    end

    def update_requests(spend_time)
      @requests.map! { |time| time + spend_time }
    end
  end
end
