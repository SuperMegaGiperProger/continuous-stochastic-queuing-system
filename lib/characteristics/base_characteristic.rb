module Characteristics
  class BaseCharacteristic
    def update(queue:, channel:, spend_time:)
      raise NotImplementedError
    end

    def value
      raise NotImplementedError
    end
  end
end
