#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

label: "Sort Seed Hits, align_sort"

hints:

requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.asn_cache)
        writable: False
      - entry: $(inputs.uniColl_asn_cache)
        writable: False
    
baseCommand: align_sort
arguments: [ -ifmt, seq-align-set,  -k, "query,subject", -nogenbank ]

inputs:
  asn_cache:
    type: Directory
    inputBinding:
      prefix: -asn-cache
      valueFrom: $(inputs.asn_cache.basename),$(inputs.uniColl_asn_cache.basename)
  uniColl_asn_cache:
    type: Directory
  blast_aligns:
    type: File
    inputBinding:
      prefix: -input
  limit_mem:
    type: string?
    inputBinding:
        prefix: -limit-mem
        
  output:
    type: string?
    default: align.asn
    inputBinding:
      prefix: -o


outputs: 
  sorted_aligns:
    type: File
    outputBinding:
      glob: $(inputs.output)
