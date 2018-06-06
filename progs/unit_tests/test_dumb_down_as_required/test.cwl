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
steps:
  test: # Final_Bacterial_Package_dumb_down_as_required: # keep this section exactly as in original production workflow!
    run: ../../dumb_down_as_required.cwl
    in: 
      annotation:  annotation
      asn_cache: 
        source: [sequence_cache]
        linkMerge: merge_flattened
      max_x_ratio: 
        default: 0.1
      max_x_run: 
        default: 3
      partial_cov_threshold:
        default: 65
      partial_len_threshold:
        default: 30
      drop_partial_in_the_middle:
        default: true
      submission_mode_genbank:
        default: true
      nogenbank:
        default: true
      it:
        default: true
    out: [outent]
outputs:
  gbent:
    type: File
    outputSource: test/outent
 