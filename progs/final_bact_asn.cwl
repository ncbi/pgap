cwlVersion: v1.0
label: "Set operations on sets of lines"
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest
requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entryname: cleaned-annotation.mft
        entry: ${var blob = ''; for (var i = 0; i < inputs.annotation.length; i++) { blob += inputs.annotation[i].path + '\n'; } return blob; }
      - entryname: submit_block_template.mft
        entry: ${var blob = ''; for (var i = 0; i < inputs.submit_block_template.length; i++) { blob += inputs.submit_block_template[i].path + '\n'; } return blob; }

baseCommand: final_bact_asn
inputs:
  annotation: 
    type: File[]
  annotation_mft:
    type: string
    default: cleaned-annotation.mft
    inputBinding:
      prefix: -annotation
  asn_cache: # sequence_cache
    type: Directory
    inputBinding:
      prefix: -asn-cache
  gc_assembly:
    type: File
    inputBinding:
      prefix: -gc-assembly
  master_desc:
    type: File
    inputBinding:
      prefix: -master-desc
  outfull_name:
    type: string
    default: annot-full.ent
    inputBinding:
      prefix: -outfull
  submit_block_template:
    type: File[]
  submit_block_template_mft:
    type: File
    default: submit_block_template.mft
    inputBinding:
      prefix: -submit-block-template
  it:
    type: boolean?
    inputBinding:
      prefix: -it
  submission_mode_genbank:
    type: boolean?
    inputBinding:
      prefix: -submission-mode-genbank
  nogenbank:
    type: boolean?
    inputBinding:
      prefix: -nogenbank
    
outputs:
  outfull:
    type: File
    outputBinding:
      glob: $(inputs.outfull_name)

  
  
