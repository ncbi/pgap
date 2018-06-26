cwlVersion: v1.0
label: "gp_annot_format"

class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest
baseCommand: gp_annot_format
inputs:
  input:
    type: File
    inputBinding:
      prefix: -input
  ifmt:
    type: string
    inputBinding:
      prefix: -ifmt
  ofmt:
    type: string
    inputBinding:
      prefix: -ofmt
  t:
    type: boolean?
    inputBinding:
      prefix: -t
  exclude_external:
    type: boolean?
    inputBinding:
      prefix: -exclude-external
  oname:
    type: string
    default: annot.gff
    inputBinding:
      prefix: -o
outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.oname)

  
  
