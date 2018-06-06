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
  sqn: File
steps:
  test:
    run: ../../sqn2gbent.cwl
    in:
      input: sqn
      it:
        default: true
    out: [output]
   
outputs:
  gbent:
    type: File
    outputSource: test/output
 