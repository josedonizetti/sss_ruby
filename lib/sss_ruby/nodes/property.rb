module SSS
  class Property
    def initialize(name, values)
      @name = name
      @values = values
    end

    def to_css(context)
      valuesCSS = []
      @values.each do |value|
        valuesCSS << value.to_css(context)
      end
      "#{@name}: #{valuesCSS.join(' ')};"
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
