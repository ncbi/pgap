cwlVersion: v1.0 
label: "reduce"

class: CommandLineTool
hints:
baseCommand: reduce
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