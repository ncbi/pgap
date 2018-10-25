cwlVersion: v1.0 
label: "prime_cache"

class: CommandLineTool
hints:
baseCommand: prime_cache    
inputs:
  input:
    type: File
    inputBinding:
        prefix: -i
  taxon_db:
    type: File
    inputBinding:
        prefix: -taxon-db
  biosource:
    type: string?
    inputBinding:
      prefix: -biosource
  cache_dir:
    type: string
    default: sequence_cache
    inputBinding:
      prefix: -cache
  ifmt:
    type: string?
    default: fasta
    inputBinding:
      prefix: -ifmt
  inst_mol:
    type: string?
    inputBinding:
      prefix: -inst-mol
  molinfo:
    type: string?
    inputBinding:
      prefix: -molinfo
  taxid:
    type: int?
    inputBinding:
      prefix: -taxid
  seq_ids_name:
    type: string
    default: "oseq-ids.seqids"
    inputBinding:
        prefix: -oseq-ids
  submit_block_template: 
    type: File
    inputBinding:
        prefix: -submit-block-template
outputs:
  oseq_ids:
     type: File
     outputBinding: 
       glob: $(inputs.seq_ids_name)   
  asn_cache:
    type: Directory
    outputBinding:
        glob: $(inputs.cache_dir)
