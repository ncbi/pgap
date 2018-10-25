cwlVersion: v1.0
label: "Run genomic CMsearch (5S rRNA), gather"
class: CommandLineTool
hints:
    
#gpx_qdump -output cmsearch.asn -output-manifest placements.mft -unzip '*' 
baseCommand: gpx_qdump
arguments: [ -unzip, '*' ]
inputs:
  input_path:
    type: Directory
    inputBinding:
      prefix: -input-path
  output_name:
    type: string?
    default: "cmsearch.asn"
    inputBinding:
      prefix: -output

outputs:
  annots:
    type: File
    outputBinding:
      glob: $(inputs.output_name)
