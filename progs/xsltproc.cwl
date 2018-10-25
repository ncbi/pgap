cwlVersion: v1.0
label: "xsltproc"

class: CommandLineTool
baseCommand: xsltproc
inputs:
  output_name: 
    type: string
    default: var_proc_annot_stats.val.xml
    inputBinding:
      prefix: --output
  xslt: 
    type: File
    inputBinding:
        position: 1
  xml:
    type: File
    inputBinding:
        position: 2
outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.output_name)

  
  
