#!/usr/bin/env cwl-runner
label: "gc_extract_ids"
class: CommandLineTool
baseCommand: gc_extract_ids
cwlVersion: v1.2
inputs:
  input:
    type: File
    inputBinding:
      prefix: -input
  output_name:
    type: string?
    default: gencoll.ids
    inputBinding:
      prefix: -output
outputs:
  output:
    type: File  
    outputBinding:
      glob: $(inputs.output_name)
      
