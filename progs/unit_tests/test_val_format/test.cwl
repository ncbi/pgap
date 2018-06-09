cwlVersion: v1.0 
label: "val_format"

class: Workflow
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest
inputs:
    input: File
steps:
    test: 
        run:
            label: "val_format"
            class: CommandLineTool
            hints:
              DockerRequirement:
                dockerPull: ncbi/gpdev:latest
            baseCommand: val_format    
            arguments: ['-ifmt', 'discrepancy', '-ofmt', 'xml']
            inputs:
                input:
                    type: File
                    inputBinding:
                        prefix: -i
                output_name:
                    type: string
                    default: annot.disc.xml
                    inputBinding:
                        prefix: -o
            outputs:
                output:
                    type: File
                    outputBinding:
                        glob: $(inputs.output_name)
        in:
            input: input
        out: [output]
outputs:
    output: 
        type: File
        outputSource: test/output
    