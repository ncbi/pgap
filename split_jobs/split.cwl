#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

label: "cwl split wrapper"

hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest

        
baseCommand: split
#arguments: 
inputs:
  chunk_size:
    type: string?
    inputBinding:
      position: 1
      prefix: -l
  nchunks:
    type: string?
    inputBinding:
      position: 2
      prefix: -n
  suffix:
    type: string?
    default: .xml
    inputBinding:
      position: 3
      separate: False
      prefix: --additional-suffix=
  input: 
    type: File
    inputBinding:
      position: 4
  mask:
    type:  string?
    default: jobs
    inputBinding:
      position: 5
      valueFrom: $(inputs.mask)

outputs:
  jobs:
    type:
      type: array
      items: File
    outputBinding:
      glob: $(inputs.mask)?*$(inputs.suffix)
