cwlVersion: v1.0
label: "xsltproc"

class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest
baseCommand: xsltproc
inputs:
  output_name: 
    type: string
    default: var_proc_annot_stats.val.xml
    inputBinding:
      prefix: --output
  xslt: # /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/home/badrazat/local-install/2018-05-17/etc/asn2pas.xsl)
    type: File
    default: asn2pas.xsl
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

  
  
