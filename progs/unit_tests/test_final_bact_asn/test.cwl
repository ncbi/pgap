#!/usr/bin/env cwl-runner
label: "PGAP Pipeline"
cwlVersion: v1.0
class: Workflow

requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
#  - class: DockerRequirement
#    dockerPull: ncbi/gpdev:latest
    
inputs:
  annotation: File
  sequence_cache: Directory
  gencoll: File
  master_desc: File
  submit_block_template: File
steps:
  test: # TO BE TESTED after GP-24254
    run: ../../final_bact_asn.cwl
    in:
      annotation: 
        source: [annotation] # [Final_Bacterial_Package_asn_cleanup/annotation]
        linkMerge: merge_flattened
      asn_cache: sequence_cache
      gc_assembly: gencoll # genomic_source_gencoll_asn_bypass # gc_create_from_sequences
      master_desc: master_desc # bacterial_prepare_unannotated_master_desc_bypass
      submit_block_template: 
        source: [submit_block_template]
        linkMerge: merge_flattened
      it:
        default: true
      submission_mode_genbank:
        default: true
      nogenbank:
        default: true
        
    out: [outfull]
   
outputs:
  gbent:
    type: File
    outputSource: test/outfull
 