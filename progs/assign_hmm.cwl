cwlVersion: v1.0 
label: "assign_hmm"

class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest

baseCommand: assign_hmm
inputs:
  db:
    type: File
    inputBinding:
      prefix: -db
  input:
    type: File
    inputBinding:
      prefix: -input
  oname:
    type: string
    default: hmm-assignments.xml
    inputBinding:
        prefix: -o
outputs:
  assignments: # xml
    type: File
    outputBinding:
      glob: $(inputs.oname)
    