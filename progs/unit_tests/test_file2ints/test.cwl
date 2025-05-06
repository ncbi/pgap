#!/usr/bin/env cwl-runner
cwlVersion: v1.2
label: "file2ints"

class: Workflow
inputs:
    input:
        type: File
steps:
    step1:            
        run: ../../file2ints.cwl
        in:
            input: input
        out: [values] 
outputs: 
  output_values:
    type: int[]
    outputSource: step1/values