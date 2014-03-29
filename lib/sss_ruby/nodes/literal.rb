module SSS
  class Literal
    def initialize(value)
      @value = value
    end

    def to_css(context)
      @value.to_s
    end

    def ==(o)
      o.class == self.class && o.state == state
    end

    protected
    def state
      @values
    end
  end
end
