#!/usr/bin/env cwl-runner
cwlVersion: v1.0
label: "pinger"
class: CommandLineTool
baseCommand: pinger.sh

stdout: pinger.out
inputs:
  state:
    type: string 
    inputBinding:
      position: 1
      prefix: "state"
      itemSeparator: " "
  instring:
    type: string?
    default: "dummyarg"
  infile:
    type: File?
    default:
      class: File
      path: /dev/null
      
outputs:
  stdout:
    type: stdout
  outstring:
    type: string
    outputBinding:
      outputEval: $(inputs.instring)
  outfile:
    type: File
    outputBinding:
      outputEval: $(inputs.infile)
