#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool
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
outputs:
  jobs:
    type: File
    outputBinding:
      glob: $(inputs.jobs_name)    

