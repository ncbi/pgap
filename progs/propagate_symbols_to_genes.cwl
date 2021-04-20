cwlVersion: v1.2 
label: "propagate_symbols_to_genes"
class: CommandLineTool

baseCommand: propagate_symbols_to_genes
inputs:
  input:
    type: File
    inputBinding:
      prefix: -input
  orthologs:
    type: File
    inputBinding:
      prefix: -orthologs
  prot_similarity_threshold:
    type: float?
    default: 0.8
    inputBinding:
      prefix: -prot_similarity_threshold
  q_coverage_threshold:
    type: float?
    default: 0.9
    inputBinding:
      prefix: -q_coverage_threshold
  s_coverage_threshold:
    type: float?
    default: 0.9
    inputBinding:
      prefix: -s_coverage_threshold
  it:
    type: boolean?
    default: false
    inputBinding:
      prefix: -it
  output_name:
    type: string?
    default: propagated_gene_symbols_annot.asn
    inputBinding:
      prefix: -output
outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.output_name)
