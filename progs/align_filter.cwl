cwlVersion: v1.0 
label: "align_filter"

class: CommandLineTool
    
baseCommand: align_filter
inputs:
  asn_cache:
    type: Directory[]
    inputBinding:
      prefix: -asn-cache
      itemSeparator: ","
  filter:
    type: string?
    inputBinding:
      prefix: -filter
  ifmt:
    type: string?
    inputBinding:
      prefix: -ifmt
  input:
    type: File?
    inputBinding:
      prefix: -input
  nogenbank:
    type: boolean
    inputBinding:
      prefix: -nogenbank
  subject_whitelist: 
    type: File?
    inputBinding:
      prefix: -subject-whitelist
  onon_match_name: 
    type: string
    default: align-nomatch.asn
    inputBinding:
        prefix:  -non-match-output
  o_name: 
    type: string
    default: align.asn
    inputBinding:
        prefix:  -o
outputs:
   o:
        type: File
        outputBinding:
            glob: $(inputs.o_name)
   onon_match:
        type: File
        outputBinding:
            glob: $(inputs.onon_match_name)
