cwlVersion: v1.0
label: "Execute CRISPR, gather"
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest
    
#gpx_qdump -output ncbi_crispr.out -output-manifest annots.mft -unzip '*'
baseCommand: gpx_qdump
arguments: [ -unzip, '*', -failed-jobs-tolerate-failures ]
inputs:
  input_path:
    type: Directory
    inputBinding:
      prefix: -input-path
  output_name:
    type: string?
    default: "ncbi_crispr.out"
    inputBinding:
      prefix: -output

outputs:
  annots:
    type: File
    outputBinding:
      glob: $(inputs.output_name)
