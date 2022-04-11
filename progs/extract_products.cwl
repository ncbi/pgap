cwlVersion: v1.2
label: "extract_products"

class: CommandLineTool
arguments: [-exclude-readthrough]
baseCommand: extract_products
inputs:
  input:
    type: File
    inputBinding:
      prefix: -input
  asn_cache:
    type: Directory[]
    inputBinding:
      prefix: -asn-cache
      itemSeparator: ","
  ifmt:
    type: string?
    inputBinding:
      prefix: -ifmt
  rna_ids_name: 
    type: string?
    default: rna.ids
    inputBinding:
      prefix: -rna-ids
  prot_ids_name:
    type: string?
    default: prot.ids
    inputBinding:
      prefix: -prot-ids
outputs:
  rna_ids:
    type: File
    outputBinding: 
      glob: $(inputs.rna_ids_name)  
  prot_ids:
    type: File
    outputBinding: 
      glob: $(inputs.prot_ids_name)  
  

