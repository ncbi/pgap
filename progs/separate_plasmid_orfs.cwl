cwlVersion: v1.0
label: "separate_plasmid_orfs"
class: CommandLineTool
baseCommand: separate_plasmid_orfs
inputs:
  orf_ids: 
    type: File
    inputBinding:
      prefix: -orf_ids
  orf_entries: 
    type: File
    inputBinding:
      prefix: -orf_entries
  raw_seqs: 
    type: File
    inputBinding:
      prefix: -raw_seqs
  plasmids: 
    type: File
    inputBinding:
      prefix: -plasmids
  chomosome_orfs_out: 
    type: string
    default: chromosome_orf.ids
    inputBinding:
      prefix: -chromosome_orfs
  plasmid_orfs_out: 
    type: string
    default: plasmid_orf.ids
    inputBinding:
      prefix: -plasmid_orfs
  
outputs:
  chomosome_orfs:
    type: File
    outputBinding:
      glob: $(inputs.chomosome_orfs_out)
  plasmid_orfs:
    type: File
    outputBinding:
      glob: $(inputs.plasmid_orfs_out)

  
  
