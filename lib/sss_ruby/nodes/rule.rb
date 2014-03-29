module SSS
  class Rule

    attr_reader :selector

    def initialize(selector, declarations)
      @selector = selector
      @declarations = declarations
    end

    def to_css(parentContext)
      context = Context.new(self, parentContext)
      propertiesCSS = []
      nestedRulesCSS = []

      @declarations.each do |declaration|
        css = declaration.to_css(context)

        if declaration.kind_of? Property
          propertiesCSS.push(css)
        elsif declaration.kind_of? Rule
          nestedRulesCSS.push(css)
        end
      end

      ([ context.selector + ' { ' + propertiesCSS.join(' ') + ' }' ] + nestedRulesCSS).join("\n")
    end

    def ==(o)
      o.class == self.class && o.state == state
    end

    protected
    def state
      [@selector] + @declarations
    end
  end
end
