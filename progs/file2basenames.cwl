#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: ExpressionTool

requirements: { InlineJavascriptRequirement: {} }

inputs:
  input:
    type: File
    inputBinding:
      loadContents: true

expression: |
  ${
    var values=[];
    var lines=[];
    if(inputs.input != null) {
        lines = inputs.input.contents.split("\n");
    }
    for(var i = 0; i<lines.length; i++) {
      var basename = lines[i];
      var last_slash_i = basename.lastIndexOf("/");
      if(last_slash_i>-1) {
        basename = basename.substr(last_slash_i + 1).trim();
      }
      if(basename.length > 0) {
        values.push (basename);
      }
    }
    return { "values": values }; 
  }

outputs:
  values: string[]
