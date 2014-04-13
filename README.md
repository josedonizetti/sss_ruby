# sss_ruby

CSS transpiler based on (sass, less)
Not production ready, project goal was to hand write a lexer and parser(recursive descent).

# example

```
import "another.sss"
import "another.css"

// Variables
@font: Arial, Helvetica;

body#home
  font: 10px @font;
  font-weight: bold;

  background: #efefef url(/images/back.jpg) no-repeat;
  color: #111

  @pad: 10px;

  margin: @pad

  //Nested rules
  h1
    padding: @pad
    margin-bottom: 0;

    a:hover
      text-decoration: none
    a :hover
      text-decoration: none
```
