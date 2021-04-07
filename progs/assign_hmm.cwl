cwlVersion: v1.2
label: "assign_hmm"

class: CommandLineTool

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
    