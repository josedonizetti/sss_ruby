module SSS
  class Context
    def initialize(rule = nil, parent = nil)
      @rule = rule
      @parent = parent
      @variables = {}
    end

    def selectors
      selectors = []

      selectors = @parent.selectors if @parent
      selectors.push @rule.selector if @rule

      selectors
    end

    def selector
      selectors.join(' ')
    end


    def set(name, values)
      @variables[name] = values
    end

    def get(name)
      return @variables[name] if @variables[name]
      return @parent.get(name) if @parent 

      raise 'Undeclared variable ' + name
    end

  end
end
