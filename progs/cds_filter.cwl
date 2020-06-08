cwlVersion: v1.0
label: "cds_filter"
class: CommandLineTool
    
#cds_filter -aligns-manifest aligns.mft -o prot.ids -seq_entries-manifest seq_entries.mft
baseCommand: cds_filter
arguments: [ -nogenbank, -max-len, "7500"  ]
inputs:
  aligns:
    type: File
    inputBinding:
      prefix: -aligns
  seq_entries:
    type: File
    inputBinding:
      prefix: -seq_entries
  outfile:
    type: string?
    default: "prot.ids"
    inputBinding:
      prefix: -o
outputs:
  prot_ids:
    type: File
    outputBinding:
      glob: $(inputs.outfile)
