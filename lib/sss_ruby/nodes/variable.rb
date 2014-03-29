module SSS
  class Variable
    def initialize(name)
      @name = name
    end

    def to_css(context)
      context.get(@name)
    end

    def ==(o)
      o.class == self.class && o.state == state
    end

    protected
    def state
      [@name]
    end
  end
end
