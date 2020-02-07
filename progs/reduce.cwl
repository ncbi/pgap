cwlVersion: v1.0 
label: "reduce"

class: CommandLineTool
baseCommand: reduce
arguments: [ -nogenbank  ]
inputs:
  aligns:
    type: File
    inputBinding:
      prefix: -aligns
  oseqids_name:
    type: string
    default: protein.seqids
    inputBinding:
      prefix: -oseqids
outputs:
    oseqids:
        type: File
        outputBinding:
            glob: $(inputs.oseqids_name)
