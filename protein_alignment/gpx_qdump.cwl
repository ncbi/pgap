#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

label: "Seed Search Compartments, gather"


baseCommand: gpx_qdump
arguments: [ -unzip, '*', -produce-empty-file ]
inputs:
  input_path:
    type: Directory
    inputBinding:
      prefix: -input-path
  output_name:
    type: string?
    default: "blast.asn"
    inputBinding:
      prefix: -output

outputs:
  seed_align:
    type: File
    outputBinding:
      glob: $(inputs.output_name)
