cwlVersion: v1.0 
label: "kmer_top_n_extract"
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest
baseCommand: kmer_top_n_extract
# this is only one example
# 
# 
# 
# /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/bin/kmer_top_n_extract \
#     -input-manifest \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/kmer_top_n_extract.455674812/inp/top_distances.mft \
#     -otop-assms \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/kmer_top_n_extract.455674812/out/top-reference-assms \
#     -otop-assms-xml \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/kmer_top_n_extract.455674812/out/kmer-tax-report.xml \
#     -ref-assembly-id \
#     0 \
#     -ref-assembly-taxid \
#     243273 \
#     -threshold \
#     0.1
# 
# 
# 
inputs:
  input:
    type: File
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
    type: string?
    inputBinding:
      prefix: -threshold
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
    