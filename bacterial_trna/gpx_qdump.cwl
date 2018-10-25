cwlVersion: v1.0
label: "Run tRNAScan, gather"
class: CommandLineTool
hints:
    
#gpx_qdump -output cmsearch.asn -output-manifest placements.mft -unzip '*' 
#gpx_qdump -o intermediate.asn -unzip '*'

baseCommand: gpx_qdump
arguments: [ -unzip, '*' ]
inputs:
  input_path:
    type: Directory
    inputBinding:
      prefix: -input-path
  output_name:
    type: string?
    default: "intermediate.asn"
    inputBinding:
      prefix: -output

outputs:
  intermediate:
    type: File
    outputBinding:
      glob: $(inputs.output_name)
