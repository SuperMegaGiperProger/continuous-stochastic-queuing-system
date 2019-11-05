class EventGenerator
  def initialize(event_generators)
    @generators = event_generators
  end

  def next(deprecated_events = [])
    times_to_events = @generators.transform_values(&:next)

    times_to_events.reduce({ time: Float::INFINITY, type: nil }) do |accum, (type, time_to_event)|
      next accum if deprecated_events.include? type

      if time_to_event < accum[:time]
        { time: time_to_event, type: type }
      else
        accum
      end
    end
  end
end
