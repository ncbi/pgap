#!/usr/bin/env cwl-runner

cwlVersion: v1.2
class: CommandLineTool

label: "Find ProSplign Alignments, gather"


baseCommand: gpx_qdump
arguments: [ -unzip, '*' ]
inputs:
  input_path:
    type: Directory
    inputBinding:
      prefix: -input-path
  output_name:
    type: string?
    default: "prosplign.asn"
    inputBinding:
      prefix: -output

outputs:
  prosplign_align:
    type: File
    outputBinding:
      glob: $(inputs.output_name)
