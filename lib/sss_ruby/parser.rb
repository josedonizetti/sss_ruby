module SSS

  class Parser

    def parse(tokens)
      nodes = []
      StyleSheet.new(parse_nodes(tokens, nodes))
    end

    private
    def parse_nodes(tokens, nodes)
      token = tokens.shift

      if token[0] == :VARIABLE &&
        (tokens[0][0] == ":" || tokens[0][0] == "=" )
         nodes << parse_assign(token, tokens)
      elsif token[0] == :IDENTIFIER &&
        (tokens[0][0] == ":" || tokens[0][0] == "=" )
        nodes << parse_property(token, tokens)
      elsif token[0] == :SELECTOR
        nodes << parse_rule(token, tokens)
      elsif token[0] == :DEDENT
        return nodes
      end

      if !tokens.empty?
        parse_nodes(tokens, nodes)
      else
        return nodes
      end
    end

    def parse_assign(current_token, tokens)
      tokens.shift # remove =, :
      Assign.new(current_token[1], parse_values(tokens))
    end

    def parse_property(current_token, tokens)
      tokens.shift # remove =, :
      Property.new(current_token[1], parse_values(tokens))
    end

    def parse_rule(current_token, tokens)
      tokens.shift # newline

      if tokens[0].nil?
        Rule.new(current_token[1], [])
      elsif tokens[0][0] == :INDENT
        Rule.new(current_token[1], parse_nodes(tokens, []))
      else
        Rule.new(current_token[1], [])
      end
    end

    def parse_values(tokens)
      values = []
      while token = tokens.shift
        break if token[0] == :NEWLINE
        if token[0] == :VARIABLE
          values << Variable.new(token[1])
        elsif token[0] == :DIMENSION
          values << Literal.new(token[1])
        elsif token[0] == :IDENTIFIER
          values << Literal.new(token[1])
        elsif token[0] == :COLOR
            values << Literal.new(token[1])
        elsif token[0] == :NUMBER
            values << Literal.new(token[1])
        elsif token[0] == :SELECTOR # FIXME: bug
          values << Literal.new(token[1])
        end
      end

      values
    end

  end

end
