cwlVersion: v1.2
label: "Run genomic CMsearch (Rfam rRNA), gather"
class: CommandLineTool
    
#gpx_qdump -output cmsearch.asn -output-manifest placements.mft -unzip '*' 
baseCommand: gpx_qdump
arguments: [ -unzip, '*', -produce-empty-file ]
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
