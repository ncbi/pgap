cwlVersion: v1.0
label: "bact_asn_stats"

class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest
baseCommand: bact_asn_stats
inputs:
  input_annotation:
    type: File
    inputBinding:
      prefix: -input
  it:
    type: boolean
    inputBinding:
      prefix: -it 
  output_name:
    type: string
    default: my_external_pgap.annotation.summary.txt \
    inputBinding:
      prefix: -o
  xml_output_name:
    type: string
    default: my_external_pgap.annotation.summary.xml \
    inputBinding:
      prefix: -xml-output

outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.output_name)
  xml_output:
    type: File
    outputBinding:
      glob: $(inputs.xml_output_name)

  
  
