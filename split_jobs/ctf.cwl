#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

label: "create a folder and copy files to it"

hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest

        
baseCommand: bash 
arguments: [ -c, 'dirname=$0; mkdir $dirname; cp "$@" $dirname' ]
inputs:
  outdir_name:
    type: string?
    default: JOBS
    inputBinding:
      position: 1
  files:
    type: 
      type: array
      items: File
    inputBinding:
      position: 2

outputs:
  outdir:
    type: Directory
    outputBinding:
      glob: $(inputs.outdir_name)
