cwlVersion: v1.0 
label: "gp_annot_format"

class: Workflow
hints:
inputs:
    input: File
steps:
    test: 
        run: ../../gp_annot_format.cwl
        in:
            input: input
            ifmt: 
                default: seq-entry
            t:
                default: true
            ofmt:
                default: gff3 
            exclude_external:
                default: true
        out: [output]
outputs:
    output: 
        type: File
        outputSource: test/output
    