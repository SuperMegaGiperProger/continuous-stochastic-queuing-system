require_relative './base_characteristic'

module Characteristics
  class AverageTimeInQueue < BaseCharacteristic
    def initialize
      @prev_count = 0
      @queue_requests = []

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
      reduced = @queue_requests.shift(count)

      @sum   += reduced.sum
      @count += count
    end

    def increase_queue(count)
      new_requests = Array.new(count, 0.0)

      @queue_requests.concat new_requests
    end

    def update_requests(spend_time)
      @queue_requests.map! { |time| time + spend_time }
    end
  end
end
