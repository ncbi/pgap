cwlVersion: v1.2
class: CommandLineTool
baseCommand: annot_ribo_operons
label: annot_ribo_operons
arguments: [ -nogenbank ]
inputs:
  input_5S:
    type: File
    inputBinding:
      prefix: '-input-5S'
  output_5S_name:
    type: string
    default: 5S.asn
    inputBinding:
      prefix: '-output-5S'
  input_16S:
    type: File
    inputBinding:
      prefix: '-input-16S'
  output_16S_name:
    type: string
    default: 16S.asn
    inputBinding:
      prefix: '-output-16S'
  input_23S:
    type: File
    inputBinding:
      prefix: '-input-23S'
  output_23S_name:
    type: string
    default: 23S.asn
    inputBinding:
      prefix: '-output-23S'
outputs:
  output_5S:
    type: File
    outputBinding:
      glob: $(inputs.output_5S_name)
  output_16S:
    type: File
    outputBinding:
      glob: $(inputs.output_16S_name)
  output_23S:
    type: File
    outputBinding:
      glob: $(inputs.output_23S_name)
