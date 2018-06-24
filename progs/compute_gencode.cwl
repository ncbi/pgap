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
  gencode:  # output control flag
    type: boolean?
    inputBinding:
      prefix: -gencode
  superkingdom:  # output control flag
    type: boolean?
    inputBinding:
      prefix: -superkingdom
  taxid:
    type: int
    inputBinding:
      prefix: -taxid
  output_impl:
    type: string
    default: gencode.txt
    inputBinding:
      prefix: -output
  taxon_db:
    type: File
    inputBinding:
      prefix: -taxon-db
outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.output_impl)

  
  
