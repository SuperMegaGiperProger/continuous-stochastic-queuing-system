module Components
  class Queue
    attr_reader :size

    def initialize
      @size = 0
    end

    def inc
      @size += 1
    end

    def dec
      @size -= 1
    end

    def empty?
      @size <= 0
    end
  end
end
