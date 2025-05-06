# called by Extract_Proteins_From_Compartments
cwlVersion: v1.2
label: cross_origin_fasta
class: CommandLineTool
baseCommand: cross_origin_fasta
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
    inputBinding:
      prefix: -odelta-seqs 
  generic_output_name:
    type: string?
    # default: genomic.fa       
    inputBinding:
      prefix: -o

  trim_low_quality:
    type: boolean?
    inputBinding:
      prefix: -trim-low-quality
  uniquify:
    type: boolean?
    inputBinding:
      prefix: -uniquify

      
  asn_cache:
    type: Directory[]
    inputBinding:
      prefix: -asn-cache
      itemSeparator: ","
  action: 
    type: string
    inputBinding:
      prefix: -action
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
    type: File?
    outputBinding:
      glob: $(inputs.delta_seqs_name)      
  generic_output:
    type: File
    outputBinding:
      glob: $(inputs.generic_output_name)       
