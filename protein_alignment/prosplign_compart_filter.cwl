#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

label: "Filter Protein Seeds I, compart filter"

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
    
baseCommand: prosplign_compart_filter

inputs:
  asn_cache:
    type: Directory
    inputBinding:
      prefix: -asn-cache
      valueFrom: $(inputs.asn_cache.basename),$(inputs.uniColl_asn_cache.basename)
  min_prot_coverage:
    type: float
    default: 0.05
    inputBinding:
        prefix: -min_prot_coverage
  min_scaffold_coverage:
    type: float
    default: 0.50
    inputBinding:
        prefix: -min_scaffold_coverage
  max_compart_count:
    type: int
    default: 5000
    inputBinding:
        prefix: -max_compart_count
  nogenbank:
    type: boolean?
    default: true
    inputBinding:
        prefix: -nogenbank
  uniColl_asn_cache:
    type: Directory
  unfilt_comp:
    type: File
    inputBinding:
      prefix: -i
  gc_assembly:
    type: File
    inputBinding:
      prefix: -gc-assembly
  sufficient_compart_length:
    type: int?
    inputBinding:
        prefix: -sufficient_compart_length 
  output:
    type: string?
    default: compartments.asn   
    inputBinding:
      prefix: -o
    
outputs:
  compartments:
    type: File
    outputBinding:
      glob: $(inputs.output)
