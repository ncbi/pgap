cwlVersion: v1.0
label: "Preserve Product Accessions"
class: CommandLineTool

baseCommand: preserve_annot_markup
arguments: [-locus-tag-prefix, pgaptmp, -ltp-table, vLTPs, -create-missing-LTPs, -preserve-product-ID, -submission-mode-genbank, -nogenbank ]
inputs:
  full_id_cache:
    type: Directory?
  asn_cache:
    type: Directory[]
    inputBinding:
      prefix: -asn-cache
      itemSeparator: ","
  egene_ini:
    type: File
    inputBinding:
      prefix: -egene-ini
  gc_assembly:
    type: File
    inputBinding:
      prefix: -gc_assembly
  input:
    type: File
    inputBinding:
      prefix: -input
  prok_entrez_gene_stuff:
    type: File
    inputBinding:
      prefix: -prok-entrez-gene-stuff
  outfile:
    type: string?
    default: annotation.asn
    inputBinding:
      prefix: -o

outputs:
  annotations:
    type: File
    outputBinding:
      glob: $(inputs.outfile)

   
