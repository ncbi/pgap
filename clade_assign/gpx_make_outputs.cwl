#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

label: "Find Marker Alignments, gather"

hints:
  DockerRequirement:
    dockerPull: ncbi/pgap:latest
    
baseCommand: gpx_make_outputs
arguments: [ -unzip, '*', -num-partitions, "1" ]

inputs:
  input_path:
    type: Directory
    inputBinding:
      prefix: -input-path
  output_name:
    type: string?
    default: "blast.#.asn"
    inputBinding:
      prefix: -output

outputs:
  blast_align:
    type: File
    outputBinding:
      #glob: $(inputs.output_name)
      glob: blast.*.asn
