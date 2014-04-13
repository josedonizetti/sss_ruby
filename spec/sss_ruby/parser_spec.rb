require 'spec_helper'

module SSS
  describe Parser do
    before do
      @parser = Parser.new
    end


    it "should parse basic assigment" do
      tokens = [[:VARIABLE, "v2"], [":", ":"], [:DIMENSION, "10px"]]
      stylesheet = @parser.parse(tokens)

      expect(stylesheet).to  eq(StyleSheet.new([
        Assign.new("v2", [ Literal.new("10px") ])
      ]))
    end

    it "should parse basic selector" do

      tokens = [
        [:VARIABLE, "v1"], [":", ":"], [:DIMENSION, "10px"], [:NEWLINE, "\n"],
        [:NEWLINE, "\n"],
        [:SELECTOR, ".selector"], [:NEWLINE, "\n"],
        [:INDENT, 2],
        [:VARIABLE, "v2"], ["=", "="], [:DIMENSION, "20px"],
        [:DEDENT, 0]
      ]

      stylesheet = @parser.parse(tokens)

      expect(stylesheet).to eq(StyleSheet.new([
        Assign.new("v1", [ Literal.new("10px") ]),
        Rule.new(".selector", [
          Assign.new("v2", [ Literal.new("20px") ])
        ])
      ]))
    end

    it "should parse properties with different values" do
      tokens =
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

      stylesheet = @parser.parse(tokens)

      expect(stylesheet).to eq(StyleSheet.new([
        Assign.new("v1", [ Literal.new("10px") ]),
        Rule.new(".selector", [
          Assign.new("v2", [ Literal.new("20px") ]),
          Property.new("property0", [ Variable.new("v1") ]),
          Property.new("property1", [ Literal.new("10px"), Variable.new("v2")]),
          Property.new("property2", [ Literal.new("10px"), Literal.new("10px")]),
        ]),
      ]))
    end

    it "should parse multiple rules" do
      tokens  =
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

      stylesheet = @parser.parse(tokens)

      expect(stylesheet).to eq(StyleSheet.new([
        Assign.new("v1", [ Literal.new("10px") ]),
        Rule.new(".selector", [
          Assign.new("v2", [ Literal.new("20px") ]),
          Property.new("property0", [ Variable.new("v1") ]),
          Property.new("property1", [ Literal.new("10px"), Variable.new("v2")]),
          Property.new("property2", [ Literal.new("10px"), Literal.new("10px")]),
          Rule.new("h1", [
            Property.new("property3", [ Literal.new("10px") ]),
            Property.new("property4", [ Variable.new("v2"), Literal.new("10px")]),
            Property.new("property5", [ Literal.new("10px"), Literal.new("10px")]),
          ])
        ]),
      ]))
    end

    it "should parse nested rules" do
      tokens =
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
       [:DEDENT, 0]]

       stylesheet = @parser.parse(tokens)

       expect(stylesheet).to eq(StyleSheet.new([
         Assign.new("v1", [ Literal.new("10px") ]),
         Rule.new(".selector", [
           Assign.new("v2", [ Literal.new("20px") ]),
           Rule.new("h1", [
             Rule.new(".div", [
               Property.new("property3", [ Literal.new("10px") ])
             ]),
             Rule.new(".div2", [])
           ]),
           Rule.new(".div3", [])
         ]),
         Rule.new(".div4", [
           Rule.new(".div5", [])
         ])
       ]))
    end

    it "should paser import directives" do
      tokens = [
        [:IMPORT, "'lib/another.sss'"],
        [:NEWLINE, "\n"],
        [:IMPORT, "\"lib/another.css\""]
      ]

      stylesheet = @parser.parse(tokens)

      expect(stylesheet).to eq(StyleSheet.new([
        Import.new("'lib/another.sss'"),
        Import.new("\"lib/another.css\"")
      ]))
    end
  end
end
