cwlVersion: v1.0
label: "ent2sqn"

class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest
baseCommand: add_locus_tags
inputs:
  input:
    type: File
    inputBinding:
      prefix: -input
  locus_tag_prefix:
    type: string
    inputBinding:
      prefix: -locus-tag-prefix
  output_impl:
    type: string
    default: annotation.asn
    inputBinding:
      prefix: -output
outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.output_impl)

  
  
