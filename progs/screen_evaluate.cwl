cwlVersion: v1.0
class: CommandLineTool
baseCommand: screen_evaluate
label: screen_evaluate
requirements:
  - class: InlineJavascriptRequirement
  
inputs:
  asn:
    type: File?
    inputBinding:
      prefix: '-asn'
  tab:
    type: File?
    inputBinding:
      prefix: '-tab'
  ifmt:
        type: string
        inputBinding:
            prefix: '-ifmt'
  ignore_all_errors:
        type: boolean?
        default: false
        inputBinding:
            prefix: '-ignore-all-errors'
  it:
        type: boolean?
        default: false
        inputBinding:
            prefix: -it
outputs:
  success:
        type: boolean
        outputBinding:
            outputEval: $(true)
            
