#!/usr/bin/env cwl-runner

label: "Prepare user input"
cwlVersion: v1.0
class: CommandLineTool
doc: Prepare user input for  NCBI-PGAP pipeline

requirements:
  - class: MultipleInputFeatureRequirement
  - class: InlineJavascriptRequirement

baseCommand: cat  
stdout: complete.template
inputs:
  tech: 
    type: string? # wgs
  completeness: 
    type: string? # complete
  submit_block_template_static: 
    type: File
    inputBinding:
        position: 1
  molinfo_complete_asn: 
    type: File
  molinfo_wgs_asn: 
    type: File
    inputBinding:
        position: 2
        valueFrom: ${ if(inputs.tech != null) { return inputs.molinfo_wgs_asn; } else {return inputs.molinfo_complete_asn; } }
outputs:
  submit_block_template: 
    type: stdout
