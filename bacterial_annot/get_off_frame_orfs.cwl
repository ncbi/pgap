cwlVersion: v1.0
label: "Get off-frame ORFs"
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest
    
#get_off_frame_orfs -aligns-manifest aligns.mft -o prot.ids -seq_entries-manifest seq_entries.mft
baseCommand: get_off_frame_orfs
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
