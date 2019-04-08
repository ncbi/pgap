cwlVersion: v1.0
label: "asn_cleanup"

class: CommandLineTool
requirements:
  - class: InlineJavascriptRequirement

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
      valueFrom: ${ if ( inputs.type1 != 'seq-entry' ) return inputs.type1; else return null; }
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

  
  
