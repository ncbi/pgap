#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool
baseCommand: xmlformat
requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entryname: empty
        entry:  ''
        
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
  entry_point_name:
    type: string?
    default: empty
    inputBinding:
      prefix: -entry-point
  
outputs: 
  out: 
    type: File
    outputBinding:
      glob: $(inputs.out_name)    

