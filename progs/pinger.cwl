#!/usr/bin/env cwl-runner
cwlVersion: v1.0
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
      
outputs:
  stdout:
    type: stdout
  outstring:
    type: string
    outputBinding:
      outputEval: $(inputs.instring)
  # outfile:
  #   type: File
  #   outputBinding:
  #     outputEval: $(inputs.infile)
