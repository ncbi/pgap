#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

label: "file concatenation"

baseCommand: cat
stdout: out.asn

inputs:
  file_in_1:
    type: File
    inputBinding:
      position: 1
  file_in_2:
    type: File
    inputBinding:
      position: 2
  
outputs: 
  file_out:
    type: stdout
