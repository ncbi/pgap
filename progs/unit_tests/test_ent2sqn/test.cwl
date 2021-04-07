#!/usr/bin/env cwl-runner
label: "PGAP Pipeline"
cwlVersion: v1.2
class: Workflow

inputs:
      gencoll: File
      submit_block_template: File
      sequence_cache: Directory
      annotation: File
steps:
  test:
    run: ../../ent2sqn.cwl
    in:
      annotation: annotation
      asn_cache: 
        source: [sequence_cache]
        linkMerge: merge_flattened
        
      # gc_assembly: genomic_source/gencoll_asn # gc_create_from_sequences
      gc_assembly: gencoll # gc_create_from_sequences
      submit_block_template: 
        source: [submit_block_template]
        linkMerge: merge_flattened
      it:
        default: true
    out: [output]
   
outputs:
  gbent:
    type: File
    outputSource: test/output
 