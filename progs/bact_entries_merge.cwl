cwlVersion: v1.0 
label: "bact_entries_merge"
class: CommandLineTool
baseCommand: bact_entries_merge
inputs:
  annotation:
    type: File[]
  annotation_mft:
    type: string?
    default: annotation.mft
    inputBinding:
      prefix: -input-manifest
  output_name:
    type: string?
    default: models.asn
    inputBinding:
      prefix: -o
      
outputs:
  out_annotation:
    type: File
    outputBinding:
      glob: $(inputs.output_name)


