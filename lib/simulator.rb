require_relative './characteristics/average_count_in_queue'
require_relative './characteristics/average_count_in_system'
require_relative './characteristics/average_time_in_queue'
require_relative './characteristics/average_time_in_system'
require_relative './event_generator'
require_relative './generators/exponential'
require_relative './components/channel'
require_relative './components/queue'

class Simulator
  TACTS_COUNT = 1_000_000

  def initialize(lambda:, mu:, t_r:)
    @lambda = lambda
    @mu = mu
    @nu = 1 / t_r
  end

  def simulate
    characteristics = {
      average_count_in_queue: Characteristics::AverageCountInQueue.new,
      average_count_in_system: Characteristics::AverageCountInSystem.new,
      average_time_in_queue: Characteristics::AverageTimeInQueue.new(TACTS_COUNT),
      average_time_in_system: Characteristics::AverageTimeInSystem.new(TACTS_COUNT),
    }

    event_generator = EventGenerator.new({
      generated: Generators::Exponential.new(@lambda),
      processed: Generators::Exponential.new(@mu),
      warmed: Generators::Exponential.new(@nu),
    })

    queue   = Components::Queue.new
    channel = Components::Channel.new

    TACTS_COUNT.times do |i|
      deprecated_events = []
      deprecated_events.push :processed if !channel.warm? || !channel.busy?
      deprecated_events.push :warmed if channel.warm? || queue.empty?

      event = event_generator.next deprecated_events

      characteristics.each do |_key, characteristic|
        characteristic.update queue: queue, channel: channel, spend_time: event[:time]
      end

      case event[:type]
      when :generated
        queue.inc
      when :processed
        if queue.empty?
          channel.busy = false
        else
          channel.busy = true
          queue.dec
        end
      when :warmed
        channel.warm!
        channel.busy = true
        queue.dec
      end
    end

    characteristics.transform_values(&:value)
  end
end
