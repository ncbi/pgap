cwlVersion: v1.2
label: "ent2sqn"

class: CommandLineTool
requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entryname: submit_block_template.mft
        entry: ${var blob = '# submit_block_template.mft created for ent2sqn from input submit_block_template Array of Files\n'; for (var i = 0; i < inputs.submit_block_template.length; i++) { blob += inputs.submit_block_template[i].path + '\n'; } return blob; }

baseCommand: ent2sqn
arguments: [ -nogenbank ]
inputs:
  annotation:
    type: File
    inputBinding:
      prefix: -annotation
  output_impl:
    type: string
    default: annot.sqn
    inputBinding:
      prefix: -out
  asn_cache: 
    type: Directory[]
    inputBinding:
      prefix: -asn-cache
      itemSeparator: ","
  gc_assembly:
    type: File
    inputBinding:
      prefix: -gc-assembly
  submit_block_template:
    type: File[]
  submit_block_template_mft:
    type: string
    default: submit_block_template.mft
    inputBinding:
      prefix: -submit-block-template
  it:
    type: boolean?
    inputBinding:
      prefix: -it
  contact_as_author_possible:
    type: boolean?
    default: true
    inputBinding:
      prefix: -contact-as-author-possible  
outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.output_impl)

  
  
