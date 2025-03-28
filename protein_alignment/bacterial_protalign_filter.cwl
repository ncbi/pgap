#!/usr/bin/env cwl-runner

cwlVersion: v1.2
class: CommandLineTool

label: "Filter Full-Coverage Alignments"


requirements:
  - class: ResourceRequirement
    ramMax: 8000
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.asn_cache)
        writable: False
      - entry: $(inputs.uniColl_asn_cache)
        writable: False
    
baseCommand: bacterial_protalign_filter 

arguments: [ -nogenbank ]

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
  filter_accept:
    type: string?
    default: "pct_coverage = 100 AND qframe = 0 AND sframe = 0 AND cds_internal_stops = 0"
    inputBinding:
      prefix: -filter-accept   
  max_extent:
    type: int?
    inputBinding:
      prefix: -max_extent   
outputs:
  blast_full_cov:
    type: File
    outputBinding:
      glob: $(inputs.full_output)
  blast_partial_cov:
    type: File
    outputBinding:
      glob: $(inputs.part_output)
 
