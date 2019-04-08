cwlVersion: v1.0
label: "asn_cleanup"

class: CommandLineTool
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
  serial: 
    type: string?
    default: binary
    inputBinding:
      prefix: -serial 
  type1: 
    type: string?
    inputBinding:
      prefix: -type
  outformat:
    type: string?
    default: 'text' 
    inputBinding:
      prefix: -outformat

outputs:
  annotation:
    type: File
    outputBinding:
      glob: $(inputs.out_annotation_name)

  
  
