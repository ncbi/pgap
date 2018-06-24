cwlVersion: v1.0 
label: "gencode2trnamodel"

class: Workflow
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest
inputs:
    gencode: int
steps:
    test: 
        run: ../../gencode2trnamodel.cwl
        in:
            gencode: gencode
        out: [output]
outputs:
    output: 
        type: string?
        outputSource: test/output
    