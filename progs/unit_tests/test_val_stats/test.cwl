#!/usr/bin/env cwl-runner
label: "PGAP Pipeline"
cwlVersion: v1.2
class: Workflow

requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
    
inputs:
  annot_val: File
steps:
  test:
    run: ../..//val_stats.cwl  
    in:
      annot_val: annot_val # Final_Bacterial_Package_std_validation/outval
      c_toolkit: 
        default: true
    out: [output, xml]
   
outputs:
  output:
    type: File
    outputSource: test/output
  xml:
    type: File
    outputSource: test/xml
