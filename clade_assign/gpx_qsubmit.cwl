#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

label: "Find Marker Alignments, scatter"

hints:
  DockerRequirement:
    dockerPull: ncbi/pgap:latest

requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.asn_cache)
        writable: False
      - entry: $(inputs.CladeMarkers_asn_cache)
        writable: False
      - entry: $(inputs.blastdb_dir)
        writable: False
    
baseCommand: gpx_qsubmit
arguments: [ -affinity, "subject", -max-batch-length, "10000", -nogenbank ]

inputs:
  asn_cache:
    type: Directory
    inputBinding:
      prefix: -asn-cache
      valueFrom: $(inputs.asn_cache.basename),$(inputs.CladeMarkers_asn_cache.basename)
  CladeMarkers_asn_cache:
    type: Directory
  seqids:
    type: File
    inputBinding:
      prefix: -ids
  blastdb_dir:
    type: Directory
  blastdb:
    type: string?
    default: blastdb
    inputBinding:
      prefix: -db
      valueFrom: $(inputs.blastdb_dir.path)/$(inputs.blastdb)
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
