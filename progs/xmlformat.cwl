#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool
baseCommand: xmlformat
inputs:
  input: 
    type: File
    inputBinding:
      prefix: -input
  axml: 
    type: File
    inputBinding:
      prefix: -axml
  text_only: 
    type: boolean?
    inputBinding:
      prefix: -text-only
  out_name:
    type: string?
    default: checkm_raw.txt 
    inputBinding:
      prefix: -out
outputs: 
  out: 
    type: File
    outputBinding:
      glob: $(inputs.out_name)    

