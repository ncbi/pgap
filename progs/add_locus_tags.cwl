cwlVersion: v1.0
label: "add_locus_tags"

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
    type: string?
    default: "NoSubmit_"
    inputBinding:
      prefix: -locus-tag-prefix
  dbname:
    type: string?
    default: "extdb"
    inputBinding:
      prefix: -dbname
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

  
  
