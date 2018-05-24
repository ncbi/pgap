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

arguments: [ -max_compart_count, "5000", -min_prot_coverage, "0.05", -min_scaffold_coverage, "0.50", -nogenbank ] 

inputs:
  asn_cache:
    type: Directory
    inputBinding:
      prefix: -asn-cache
      valueFrom: $(inputs.asn_cache.basename),$(inputs.uniColl_asn_cache.basename)
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
