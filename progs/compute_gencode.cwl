cwlVersion: v1.0
label: "compute_gencode"

class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest
requirements:
  - class: InlineJavascriptRequirement

baseCommand: compute_gencode
inputs:
  taxid:
    type: int
    inputBinding:
      prefix: -taxid
  output_impl:
    type: string
    default: gencode.txt
    inputBinding:
      prefix: -output
outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.output_impl)

  
  
