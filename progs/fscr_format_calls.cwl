cwlVersion: v1.0
class: CommandLineTool
baseCommand: fscr_format_calls
arguments: [ -nogenbank  ]
label: fscr_format_calls

inputs:
  calls:
    type: File
    inputBinding:
      prefix: '-calls'
  oname:
    type: string
    default: calls.tab
    inputBinding:
      prefix: '-o'
outputs:  
  o:
    type: File
    outputBinding:
      glob: $(inputs.oname)
