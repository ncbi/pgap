# called by Extract_Proteins_From_Compartments
cwlVersion: v1.2
label: cross_origin_fasta
class: CommandLineTool
baseCommand: cross_origin_fasta
# arguments: [?]
inputs:
  gilist:
    type: File?
    inputBinding:
      prefix: -input 
  align: 
    type: File?
    inputBinding:
      prefix: -input     
  delta_seqs_input:
    type: File?
    inputBinding:
      prefix: -delta-seqs
    
  delta_seqs_name:
    type: string?
    default: sequences.asn
    inputBinding:
      prefix: -odelta-seqs 
  fasta_name:
    type: string?
    default: genomic.fa       
    inputBinding:
      prefix: -o
  mapped_aligns_name:
    type: string?
    default: protein.fa          
    inputBinding:
      prefix: -out
      
  asn_cache:
    type: Directory[]
    inputBinding:
      prefix: -asn-cache
      itemSeparator: ","
  action: 
    type: string?
  min_pct_ident: 
    type: float?
    inputBinding:
      prefix: -min-pct-ident
  window: 
    type: int?
    inputBinding:
      prefix: -window
      
      
    
      
outputs:
  delta_seqs:
    type: File
    outputBinding:
      glob: $(inputs.delta_seqs_name)      
  fasta:
    type: File
    outputBinding:
      glob: $(inputs.fasta_name)       
  mapped_aligns:
    type: File
    outputBinding:
      glob: $(inputs.mapped_aligns_name)             