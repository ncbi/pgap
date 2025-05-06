#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: ExpressionTool

requirements: { InlineJavascriptRequirement: {} }

inputs:
  input:
    type: File?
    inputBinding:
      loadContents: true

expression: |
  ${
    var values=[];
    if(inputs.input != null) {
        var lines = inputs.input.contents.split("\n");
        for(var i=0; i<lines.length; i++) {
          if(lines[i].length == 0) {
            continue;
          }
          if(lines[i].startsWith("#")) {
            continue;
          }
          var myint = parseInt(lines[i]);
          if(myint != null) {
            values.push(myint)  ;
          }
        }
    }
    return { "values": values }; 
  }

outputs:
  values: int[]
