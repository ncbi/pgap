#!/usr/bin/env cwl-runner
class: CommandLineTool
baseCommand: annot_checksum
cwlVersion: v1.2
inputs:
    input:
        type: File?
        inputBinding:
            prefix: -input
    output_name:
        type: string?
        default: annot_checksum.asn
        inputBinding:
            prefix: -output
    it:
        type: boolean?
        inputBinding:
            prefix: -it
    ot:
        type: boolean?
        inputBinding:
            prefix: -ot
    t:
        type: boolean?
        inputBinding:
            prefix: -t
    ifmt:
        type: string?
        inputBinding:
            prefix: -ifmt
    mode:
        type: string?
        inputBinding:
            prefix: -mode
        
outputs:
    output:
        type: File
        outputBinding:
            glob: $(inputs.output_name)