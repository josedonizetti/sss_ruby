module SSS
  class StyleSheet
    def initialize(nodes)
      @nodes = nodes
    end

    def to_css
      context = Context.new
      @nodes.map {|node| node.to_css(context) }
    end

    def ==(o)
      o.class == self.class && o.state == state
    end

    protected
    def state
      @nodes
    end
  end
end
