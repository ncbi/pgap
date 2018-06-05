cwlVersion: v1.0 
label: "bact_filter_preserved"

class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest
baseCommand: bact_filter_preserved
inputs:
            # Run GeneMark 	bacterial_annot 	models 	ASNB_SEQ_ENTRY 	annotation
  annotation: 
    type: File
    inputBinding:
      prefix: -input
  ifmt: 
    type: string?
    inputBinding:
      prefix: -ifmt
  only_those_ids: 
    type: File
    inputBinding:
      prefix: -only-those-ids
  nogenbank:
    type: boolean?
    inputBinding:
      prefix: -nogenbank
  output_annotation_name:
    type: string?
    default: annotation.ent
    inputBinding:
        prefix: -o
outputs:
    out_annotation:
        type: File
        outputBinding:
            glob: $(inputs.output_annotation_name)