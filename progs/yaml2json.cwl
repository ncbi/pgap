#!/usr/bin/env cwl-runner
cwlVersion: v1.2
label: "yaml2json"
class: CommandLineTool
baseCommand: yaml2json.py

inputs:
    input:
        type: File
        inputBinding:
            position: 1
    output_name:
        type: string
        default: submol.json
        inputBinding:
            position: 2


outputs:
    output: 
        type: File
        outputBinding:
            glob: $(inputs.output_name)
