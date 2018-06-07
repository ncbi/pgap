#!/usr/bin/env cwl-runner
label: "PGAP Pipeline"
cwlVersion: v1.0
class: Workflow

inputs:
  annotation: File
  sequence_cache: Directory
  ent: File
  gb: File
  sqn: File
  master_desc: File
  submit_block_template: File
steps:
  test:
    run: ../../std_validation.cwl
    in:
      annotation: annotation # Final_Bacterial_Package_dumb_down_as_required/outent
      asn_cache:
        # source: [genomic_source/asncache]
        source: [sequence_cache]
      exclude_asndisc_codes: # 
        default: ['OVERLAPPING_CDS']
      inent: ent
      ingb: gb
      insqn: sqn
      master_desc: 
        source: [master_desc]  # bacterial_prepare_unannotated_master_desc_bypass
        linkMerge: merge_flattened
      submit_block_template:
        source: [submit_block_template]
        linkMerge: merge_flattened
      it:
        default: true
      submission_mode_genbank:
        default: true
      nogenbank:
        default: true
    out:
      - id: outdisc
      - id: outdiscxml
      - id: outmetamaster
      - id: outval
   
outputs:
  gbent:
    type: File
    outputSource: test/outdiscxml
 