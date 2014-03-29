require 'spec_helper'

module SSS

  describe Lexer do
    let (:lexer) { Lexer.new }


    it "should tokenize basic assigment" do
      code = "@v1 : 10px"
      tokens = lexer.tokenize(code)
      expect(tokens).to eq([[:VARIABLE, "v1"], [":", ":"], [:DIMENSION, "10px"]])
    end

    it "should tokenize basic selector" do
      expected_tokens = [
        [:VARIABLE, "v1"], [":", ":"], [:DIMENSION, "10px"], [:NEWLINE, "\n"],
        [:NEWLINE, "\n"],
        [:SELECTOR, ".selector"], [:NEWLINE, "\n"],
        [:INDENT, 2],
        [:VARIABLE, "v2"], ["=", "="], [:DIMENSION, "20px"],
        [:DEDENT, 0]
      ]

      code =
<<-CODE
@v1 : 10px

.selector
  @v2 = 20px
CODE

      tokens = lexer.tokenize(code)
      expect(tokens).to eq(expected_tokens)
    end

    it "should tokenize properties with different values" do
      expected_tokens =
      [ [:VARIABLE, "v1"], [":", ":"], [:DIMENSION, "10px"], [:NEWLINE, "\n"],
        [:NEWLINE, "\n"],
        [:SELECTOR, ".selector"], [:NEWLINE, "\n"],
        [:INDENT, 2],
        [:VARIABLE, "v2"], ["=", "="], [:DIMENSION, "20px"], [:NEWLINE, "\n"],
        [:IDENTIFIER, "property0"], [":", ":"], [:VARIABLE, "v1"], [:NEWLINE, "\n"],
        [:IDENTIFIER, "property1"], [":", ":"], [:DIMENSION, "10px"], [:VARIABLE, "v2"], [:NEWLINE, "\n"],
        [:IDENTIFIER, "property2"], [":", ":"], [:DIMENSION, "10px"], [",", ","], [:DIMENSION, "10px"], [";", ";"],
        [:DEDENT, 0]
      ]

      code =
<<-CODE
@v1 : 10px

.selector
  @v2 = 20px
  property0: @v1
  property1: 10px @v2
  property2: 10px, 10px;
CODE

      tokens = lexer.tokenize(code)
      expect(tokens).to eq(expected_tokens)
    end

    it "should tokenize multiple level of indentation" do
      expected_tokens =
      [ [:VARIABLE, "v1"], [":", ":"], [:DIMENSION, "10px"], [:NEWLINE, "\n"],
        [:NEWLINE, "\n"],
        [:SELECTOR, ".selector"], [:NEWLINE, "\n"],
        [:INDENT, 2],
        [:VARIABLE, "v2"], ["=", "="], [:DIMENSION, "20px"], [:NEWLINE, "\n"],
        [:IDENTIFIER, "property0"], [":", ":"], [:VARIABLE, "v1"], [:NEWLINE, "\n"],
        [:IDENTIFIER, "property1"], [":", ":"], [:DIMENSION, "10px"], [:VARIABLE, "v2"], [:NEWLINE, "\n"],
        [:IDENTIFIER, "property2"], [":", ":"], [:DIMENSION, "10px"], [",", ","], [:DIMENSION, "10px"], [";", ";"], [:NEWLINE, "\n"],
        [:NEWLINE, "\n"],
        [:SELECTOR, "h1"], [:NEWLINE, "\n"], #tem como reconhecer como selector?
        [:INDENT, 4],
        [:IDENTIFIER, "property3"], [":", ":"], [:DIMENSION, "10px"], [:NEWLINE, "\n"],
        [:IDENTIFIER, "property4"], [":", ":"], [:VARIABLE, "v2"], [:DIMENSION, "10px"], [:NEWLINE, "\n"],
        [:IDENTIFIER, "property5"], [":", ":"], [:DIMENSION, "10px"], [",", ","], [:DIMENSION, "10px"], [";", ";"],
        [:DEDENT, 2],
        [:DEDENT, 0]
      ]


      code =
<<-CODE
@v1 : 10px

.selector
  @v2 = 20px
  property0: @v1
  property1: 10px @v2
  property2: 10px, 10px;

  h1
    property3: 10px
    property4: @v2 10px
    property5: 10px, 10px;
CODE

      tokens = lexer.tokenize(code)
      expect(tokens).to eq(expected_tokens)
    end

    it "should tokenize nested rules" do
      expected_tokens =
      [[:VARIABLE, "v1"], [":", ":"], [:DIMENSION, "10px"], [:NEWLINE, "\n"],
       [:NEWLINE, "\n"],
       [:SELECTOR, ".selector"], [:NEWLINE, "\n"],
       [:INDENT, 2],
       [:VARIABLE, "v2"], ["=", "="], [:DIMENSION, "20px"], [:NEWLINE, "\n"],
       [:NEWLINE, "\n"],
       [:SELECTOR, "h1"], [:NEWLINE, "\n"],
       [:INDENT, 4],
       [:SELECTOR, ".div"], [:NEWLINE, "\n"],
       [:INDENT, 6], [:IDENTIFIER, "property3"], [":", ":"], [:DIMENSION, "10px"], [:NEWLINE, "\n"],
       [:DEDENT, 4], [:SELECTOR, ".div2"], [:NEWLINE, "\n"],
       [:DEDENT, 2], [:SELECTOR, ".div3"], [:NEWLINE, "\n"],
       [:DEDENT, 0], [:SELECTOR, ".div4"], [:NEWLINE, "\n"],
       [:INDENT, 2], [:SELECTOR, ".div5"],
       [:DEDENT, 0]
     ]

      code =
<<-CODE
@v1 : 10px

.selector
  @v2 = 20px

  h1
    .div
      property3: 10px
    .div2
  .div3
.div4
  .div5
CODE

      tokens = lexer.tokenize(code)
      expect(tokens).to eq(expected_tokens)
    end

  end
end
