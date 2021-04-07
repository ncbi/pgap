cwlVersion: v1.2
label: "kmer_top_n_extract"

class: CommandLineTool
baseCommand: kmer_top_n_extract
# this is only one example
# 
# kmer_top_n_extract \
#     -input-manifest kmer_top_n_extract.455674812/inp/top_distances.mft \
#     -otop-assms kmer_top_n_extract.455674812/out/top-reference-assms \
#     -otop-assms-xml kmer_top_n_extract.455674812/out/kmer-tax-report.xml \
#     -ref-assembly-id 0 -ref-assembly-taxid 243273 -threshold 0.1
# 
inputs:
  input:
    type: File # XML
    inputBinding:
      prefix: -input
  ref_assembly_id:
    type: int
    inputBinding:
      prefix: -ref-assembly-id
  ref_assembly_taxid:
    type: int
    inputBinding:
      prefix: -ref-assembly-taxid
  threshold:
    type: float?
    inputBinding:
      prefix: -threshold
  taxon_db:
    type: File
    inputBinding:
      prefix: -taxon-db
  gcextract2_sqlite:
    type: File
    inputBinding:
        prefix: -gcextract2-sqlite
  otop_assms_xml:
    type: string
    default: kmer-tax-report.xml 
    inputBinding:
      prefix: -otop-assms-xml 
  otop_assms:
    type: string
    default: top-reference-assms  
    inputBinding:
      prefix: -otop-assms  
outputs: 
    tax_report:
        type: File
        outputBinding:
            glob: $(inputs.otop_assms_xml)
    gc_id_list:
        type: File
        outputBinding:
            glob: $(inputs.otop_assms)
    