cwlVersion: v1.0 
label: "asn2flat"

class: Workflow
hints:
inputs:
    input: File
steps:
    test: 
        run: ../../asn2flat.cwl
        in:
            input: input
            no_external:
                default: true
            type:
                default: seq-entry
            mode:
                default: entrez
            style:
                default: master
            gbload:
                default: true
        out: [output]
outputs:
    output: 
        type: File
        outputSource: test/output
    