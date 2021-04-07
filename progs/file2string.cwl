#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: ExpressionTool

requirements: { InlineJavascriptRequirement: {} }

inputs:
  input:
    type: File
    inputBinding:
      loadContents: true

expression: |
  ${ return { "value": String(inputs.input.contents).trim() }; }

outputs:
  value: string
