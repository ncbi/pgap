cwlVersion: v1.2
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

  
  
