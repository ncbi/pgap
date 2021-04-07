cwlVersion: v1.2
label: "asn2flat"

class: CommandLineTool
baseCommand: asn2flat
inputs:
  input:
    type: File
    inputBinding:
      prefix: -i
  no_external:
    type: boolean
    inputBinding:
      prefix: -no-external 
  gbload:
    type: boolean
    inputBinding:
      prefix: -gbload 
  type:
    type: string
    inputBinding:
      prefix: -type 
  mode:
    type: string
    inputBinding:
      prefix: -mode  
  style:
    type: string
    inputBinding:
      prefix: -style 
  oname:
    type: string
    default: annot.gbk
    inputBinding:
      prefix: -o
outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.oname)

  
  
