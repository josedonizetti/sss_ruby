module SSS

  class Lexer

    def tokenize(code)
      code.chomp!

      i = 0
      tokens = []

      current_indent = 0

      indent_stack = []

      while i < code.size

        chunk = code[i..-1]
        if comment = chunk[/\A\/\/(.*)/,1]
          i += comment.size + 2
        elsif import = chunk[/\Aimport(\s+[\'\"].*[\'\"])/i,1]
          size = import.size
          tokens << [:IMPORT, import.strip]
          i += size + "import".size
        elsif variable = chunk[/\A@([a-z]\w*)/,1]
          tokens << [:VARIABLE, variable]
          i += variable.size + 1
        elsif dimension = chunk[/\A([0-9]+(px|em|%))/,1]
          tokens << [:DIMENSION, dimension]
          i += dimension.size
        elsif number = chunk[/\A([0-9]+)/,1]
          tokens << [:NUMBER, number]
          i += number.size
        elsif color = chunk[/\A(#[0-9A-Fa-f]{3,6})/,1]
          tokens << [:COLOR, color]
          i += color.size + 1
        elsif selector = chunk[/\A([a-zA-Z]\w*)\n/,1]
          tokens << [:SELECTOR, selector]
          i += selector.size
        elsif selector = chunk[/\A([a-zA-Z]\w*(\.|#|::|:)[a-zA-Z]\w*)/,1]
          tokens << [:SELECTOR, selector]
          i += selector.size
        elsif selector = chunk[/\A((\.|#|::|:)[a-zA-Z]\w*)/,1]
          tokens << [:SELECTOR, selector]
          i += selector.size
        elsif identifier = chunk[/\A([a-zA-Z][\w\-]*)/,1]
          tokens << [:IDENTIFIER, identifier]
          i += identifier.size
        elsif indent = chunk[/\A\n( +)/m, 1]

          if indent.size < current_indent
            indent_stack.pop
            current_indent = indent_stack.last || 0
            tokens << [:NEWLINE, "\n"]
            tokens << [:DEDENT, indent.size]
          elsif indent.size == current_indent
            tokens << [:NEWLINE, "\n"]
          else
            current_indent = indent.size
            indent_stack.push(current_indent)
            tokens << [:NEWLINE, "\n"]
            tokens << [:INDENT, indent.size]
          end

          i += indent.size + 1

        elsif chunk.match(/\A\n\n/)
          tokens << [:NEWLINE, "\n"]
          i += 1
        elsif indent = chunk[/\A\n( *)/, 1]

          if indent.size < current_indent
            indent_stack.pop
            current_indent = indent_stack.last || 0
            tokens << [:NEWLINE, "\n"]
            tokens << [:DEDENT, indent.size]
            i += indent.size + 1
          else
            tokens << [:NEWLINE, "\n"]
            i += indent.size + 1
          end

        elsif chunk.match(/\A /)
          i += 1
        else
          value = chunk[0,1]
          tokens << [value, value]
          i += 1
        end

      end

      while indent = indent_stack.pop
        tokens << [:DEDENT, indent_stack.last || 0]
      end

      tokens
    end
  end
end
