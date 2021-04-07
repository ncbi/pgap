#!/usr/bin/env cwl-runner
label: "Create Genomic Collection for Bacterial Pipeline"
cwlVersion: v1.2
class: Workflow

requirements:
  - class: ScatterFeatureRequirement        

inputs:
  fasta: File
  submit_block_template: File
  taxid: int
  gc_assm_name: string
  taxon_db: File
    
steps:
  #### waiting for GP-24223
  #### commented out
  test:
    run: ../../prime_cache.cwl
    in:
      input: fasta
      submit_block_template: submit_block_template
      taxon_db: taxon_db
      taxid: taxid
    out: [oseq_ids, asn_cache]

    
outputs:
  oseq_ids:
    type: File
    outputSource: test/oseq_ids
    # outputSource: ids_out_shortcut
  asn_cache:
    type: Directory
    outputSource: test/asn_cache # waiting for GP-24223
    # outputSource: sequence_cache_shortcut # this is over when GP-24223 is resolved
    
  
  
