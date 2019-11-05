module Components
  class Channel
    def initialize
      @busy = false
      @warm = false
    end

    def busy=(val)
      @warm = false unless val

      @busy = val
    end

    def busy?
      @busy == true
    end

    def warm!
      @warm = true
    end

    def warm?
      @warm == true
    end
  end
end
