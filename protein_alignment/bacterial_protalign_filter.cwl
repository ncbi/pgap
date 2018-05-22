#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

label: "Filter Full-Coverage Alignments I"

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
    
baseCommand: bacterial_protalign_filter 

arguments: [  -filter, "-accept pct_coverage = 100 AND qframe = 0 AND sframe = 0 AND cds_internal_stops = 0", -nogenbank ]

inputs:
  asn_cache:
    type: Directory
    inputBinding:
      prefix: -asn-cache
      valueFrom: $(inputs.asn_cache.basename),$(inputs.uniColl_asn_cache.basename)
  uniColl_asn_cache:
    type: Directory
  sorted_seeds:
    type: File
    inputBinding:
      prefix: -i    
  full_output:
    type: string?
    default: align_full_cov.asn   
    inputBinding:
      prefix: -ofull
  part_output:
    type: string?
    default: align_partial_cov.asn   
    inputBinding:
      prefix: -opartial


outputs:
  blast_full_cov:
    type: File
    outputBinding:
      glob: $(inputs.full_output)
  blast_partial_cov:
    type: File
    outputBinding:
      glob: $(inputs.part_output)
 
