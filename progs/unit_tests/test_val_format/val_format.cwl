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
