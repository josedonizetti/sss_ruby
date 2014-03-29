module SSS
  class Engine
    def initialize
      @lexer = Lexer.new
      @parser = Parser.new
    end
    def compile(sss)
      tokens = @lexer.tokenize(sss)
      stylesheet = @parser.parse(tokens)
      stylesheet.to_css
    end
  end
end
