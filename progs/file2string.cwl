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
  ${ return { "value": String(inputs.input.contents).trim() }; }

outputs:
  value: string
