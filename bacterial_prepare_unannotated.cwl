cwlVersion: v1.0
label: "Prepare Unannotated Sequences"
doc: "Prepare Unannotated Sequences"
class: CommandLineTool

baseCommand: bacterial_prepare_unannotated
arguments: [ -submission-mode-genbank, -nogenbank  ]
inputs:
  asn_cache:
    type: Directory
    inputBinding:
      prefix: -asn-cache
  gc_assembly:
    type: File
    inputBinding:
      prefix: -gc-assembly
  ids:
    type: File
    inputBinding:
      prefix: -ids
  submit_block:
    type: File
    inputBinding:
      prefix: -submit-block
  master_desc_name:
    type: string?
    default: master-desc.asn
    inputBinding:
      prefix: -master-desc
  sequences_name:
    type: string?
    default: sequences.asn
    inputBinding:
      prefix: -o
  taxon_db:
    type: File
    inputBinding:
        prefix: -taxon-db
  no_internet:
    type: boolean?            
    inputBinding:
        prefix: -no-internet
        
outputs:
  master_desc:
    type: File
    outputBinding:
      glob: $(inputs.master_desc_name)
  sequences:
    type: File
    outputBinding:
      glob: $(inputs.sequences_name)
   
