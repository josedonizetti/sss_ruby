module SSS
  class Assign
    def initialize(name, values)
      @name = name
      @values = values
    end

    def to_css(context)
      valuesCSS = @values.map { |value| value.to_css(context) }
      context.set(@name, valuesCSS.join(' '))
      ""
    end

    def ==(o)
      o.class == self.class && o.state == state
    end

    protected
    def state
      [@name] + @values
    end
  end
end
