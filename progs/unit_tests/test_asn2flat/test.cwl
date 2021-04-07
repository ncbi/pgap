cwlVersion: v1.2
label: "asn2flat"

class: Workflow
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
                default: false
        out: [output]
outputs:
    output: 
        type: File
        outputSource: test/output
    
