#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

label: "Find ProSplign Alignments I, scatter"

hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest

requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.asn_cache)
        writable: False
      - entry: $(inputs.uniColl_asn_cache)
        writable: False
    
baseCommand: gpx_qsubmit
arguments: [ -NxM-threshold, "10000", -affinity, "subject", -nogenbank ]

inputs:
  asn_cache:
    type: Directory
    inputBinding:
      prefix: -asn-cache
      valueFrom: $(inputs.asn_cache.basename),$(inputs.uniColl_asn_cache.basename)
  uniColl_asn_cache:
    type: Directory
  asn:
    type: File
    inputBinding:
      prefix: -asn
  output:
    type: string?
    default: jobs.xml
    inputBinding:
      prefix: -output

outputs:
  jobs:
    type: File
    outputBinding:
      glob: $(inputs.output)
