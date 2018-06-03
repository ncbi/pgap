cwlVersion: v1.0
label: "Standard Toolkit-wide cleanup"
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest
baseCommand: asn_cleanup
inputs:
  inp_annotation:
    type: File
    inputBinding:
      prefix: -i
  out_annotation_name:
    type: string
    default: cleaned-annotation.asn
    inputBinding:
      prefix: -o
  serial: # binary
    type: string
    inputBinding:
      prefix: -serial 
outputs:
  annotation:
    type: File
    outputBinding:
      glob: $(inputs.out_annotation_name)

  
  
