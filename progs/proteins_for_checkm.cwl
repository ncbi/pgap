#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool
baseCommand: proteins_for_checkm
inputs:
  seqids:
    type: File
    inputBinding:
      prefix: -input
  jobs_name:
    type: string?
    default: 'checkm-jobs.xml'
    inputBinding:
      prefix: -output
  taxid:
    type: int
    inputBinding:
      prefix: -taxid
  output_seqids_name:
    type: string?
    default: "annotation.seqids"
    inputBinding:
      prefix: -output-seqids
  local:
    type: boolean?
    default: true
outputs:
  jobs:
    type: File
    outputBinding:
      glob: $(inputs.jobs_name)    
  output_seqids:
    type: File
    outputBinding:
      glob: $(inputs.output_seqids_name)    
      

