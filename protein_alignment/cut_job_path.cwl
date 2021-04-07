#!/usr/bin/env cwl-runner

cwlVersion: v1.2
class: CommandLineTool

label: "make path relative in a worker node job file"

baseCommand: perl
stdout: out.txt

arguments: [  "-pe", 's/<job file=".+\/(.+\")/<job file="$1/' ]

inputs:
  file_in:
    type: File
    inputBinding:
      position: 1

outputs:
  file_out:
    type: stdout

