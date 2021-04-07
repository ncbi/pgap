#!/usr/bin/env cwl-runner
cwlVersion: v1.2
baseCommand: cat
class: CommandLineTool
doc: concatenates input File[] to output File
stdout: $(inputs.output_file_name)

inputs:
    input:
        type: File[]
        inputBinding: 
            position: 1
    output_file_name:
        type: string
        default: concatenated.file
outputs:
    output:     
        type: stdout