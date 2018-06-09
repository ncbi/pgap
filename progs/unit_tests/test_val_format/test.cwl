cwlVersion: v1.0 
label: "val_format"

class: Workflow
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest
inputs:
    dummy:
        type: File?
steps:
    test: 
        run:
            label: "val_format"

            class: CommandLineTool
            hints:
              DockerRequirement:
                dockerPull: ncbi/gpdev:latest
            baseCommand: val_format    
            arguments: ['-i', 'annot.disc', '-ifmt', 'discrepancy', '-ofmt', 'xml', '-o', 'annot.disc.xml']
            inputs:
                dummy:
                    type: File?
            outputs:
                output:
                    type: File
                    outputBinding:
                        glob: 'annot.disc.xml'
        in:
            dummy: dummy
        out: [output]
outputs:
    output: 
        type: File
        outputSource: test/output
    