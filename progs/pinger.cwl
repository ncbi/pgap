#!/usr/bin/env cwl-runner
cwlVersion: v1.2
label: "pinger"
class: CommandLineTool
baseCommand: pinger.sh

stdout: pinger.out
inputs:
  report_usage:
    type: boolean
    inputBinding:
      position: 0
      prefix: "do_report"
  make_uuid:
    type: boolean?
    inputBinding:
      position: 1
      prefix: "make_uuid"
  uuid_in:
    type: File?
    inputBinding:
      position: 2
  state:
    type: string 
    inputBinding:
      position: 3
      prefix: "state"
      itemSeparator: " "
  workflow:
    type: string 
    inputBinding:
      position: 4
      prefix: "workflow"
      itemSeparator: " "
  instring:
    type: string?
    default: "dummyarg"
  infile:
    type: File[]?
      
outputs:
  stdout:
    type: stdout
  outstring:
    type: string
    outputBinding:
      outputEval: $(inputs.instring)
  uuid_out:
    type: File
    outputBinding:
      glob: uuid.txt
