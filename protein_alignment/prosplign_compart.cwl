#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

label: "Filter Protein Seeds I, compart"

hints:

requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.asn_cache)
        writable: False
      - entry: $(inputs.uniColl_asn_cache)
        writable: False
    
baseCommand: prosplign_compart

arguments: [ -compartment_penalty, "0.10", -max_extent, "100", -max_intron, "100", -maximize, coverage, -min_compartment_idty, "0.05", -min_singleton_idty, "0.05", -nogenbank, -prosplign-gaps, -ifmt, seq-align ] 

inputs:
  asn_cache:
    type: Directory
    inputBinding:
      prefix: -asn-cache
      valueFrom: $(inputs.asn_cache.basename),$(inputs.uniColl_asn_cache.basename)
  uniColl_asn_cache:
    type: Directory
  seed_hits:
    type: File
    inputBinding:
      prefix: -input
  output:
    type: string?
    default: unfiltered_compartments.asn   
    inputBinding:
      prefix: -o
    
outputs:
  unfilt_comp:
    type: File
    outputBinding:
      glob: $(inputs.output)
