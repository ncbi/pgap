#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

label: "Assign Clade, align_sort"


baseCommand: align_sort
arguments: [ -ifmt, seq-align-set,  -k, "query,subject", -nogenbank ]

inputs:
  hits:
    type: File
    inputBinding:
      prefix: -input
  output:
    type: string?
    default: sorted-aligns.asn
    inputBinding:
      prefix: -o


outputs: 
  sorted_aligns:
    type: File
    outputBinding:
      glob: $(inputs.output)
