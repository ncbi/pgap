cwlVersion: v1.0
label: "pgaap_prepare_review"

class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest
requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entryname: annotation.mft
        entry: $(inputs.annotation.path)
      - entryname: blast_full_cov_mft.mft
        entry: $(inputs.blast_full_cov.path)
      - entryname: blast_partial_cov.mft
        entry: $(inputs.blast_partial_cov.path)

baseCommand: pgaap_prepare_review
inputs:
  asn_cache: 
        type: Directory[]
        inputBinding:
          prefix: -asn-cache
          itemSeparator: ","
  annotation: # dumb down/outent
    type: File
  annotation_mft:
    type: string
    default: annotation.mft
    inputBinding:
      prefix: -annotation-mft
  blast_full_cov: # Filter Full-Coverage Alignments I/align_full_cov.asn
    type: File
  blast_full_cov_mft:
    type: string
    default: blast_full_cov.mft
    inputBinding:
      prefix: -blast-full-cov-mft
  blast_partial_cov: # Filter Full-Coverage Alignments I/align_full_cov.asn
    type: File
  blast_partial_cov_mft:
    type: string
    default: blast_partial_cov.mft
    inputBinding:
      prefix: -blast-partial-cov-mft
    # -cluster-best-mft \
    # /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/home/badrazat/local-install/data/dev/Mycoplasma_genitalium_G37/GP-23495-Create-FASTA-based-Mycoplasma_ge_20180517_1128_my_external_pgap.250744/305417/export_bacterial_annot.10054032/inp/cluster_prot_aligns.mft \
    # -fs-align-mft \
    # /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/home/badrazat/local-install/data/dev/Mycoplasma_genitalium_G37/GP-23495-Create-FASTA-based-Mycoplasma_ge_20180517_1128_my_external_pgap.250744/305417/export_bacterial_annot.10054032/inp/frameshift_aligns.mft \
    # -full-annotation-mft \
    # /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/home/badrazat/local-install/data/dev/Mycoplasma_genitalium_G37/GP-23495-Create-FASTA-based-Mycoplasma_ge_20180517_1128_my_external_pgap.250744/305417/export_bacterial_annot.10054032/inp/annotation_full.mft \
    # -gc-assembly-mft \
    # /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/home/badrazat/local-install/data/dev/Mycoplasma_genitalium_G37/GP-23495-Create-FASTA-based-Mycoplasma_ge_20180517_1128_my_external_pgap.250744/305417/export_bacterial_annot.10054032/inp/gencoll_asn.mft \
    # -output-path \
    # /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/home/badrazat/local-install/data/dev/Mycoplasma_genitalium_G37/GP-23495-Create-FASTA-based-Mycoplasma_ge_20180517_1128_my_external_pgap.250744/305417/export_bacterial_annot.10054032/var/data \
    # -pre-genemark-align-mft \
    # /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/home/badrazat/local-install/data/dev/Mycoplasma_genitalium_G37/GP-23495-Create-FASTA-based-Mycoplasma_ge_20180517_1128_my_external_pgap.250744/305417/export_bacterial_annot.10054032/inp/pre_genemark_align.mft \
    # -pre-genemark-mft \
    # /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/home/badrazat/local-install/data/dev/Mycoplasma_genitalium_G37/GP-23495-Create-FASTA-based-Mycoplasma_ge_20180517_1128_my_external_pgap.250744/305417/export_bacterial_annot.10054032/inp/pre_genemark.mft \
    # -prosplign-filtered-mft \
    # /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/home/badrazat/local-install/data/dev/Mycoplasma_genitalium_G37/GP-23495-Create-FASTA-based-Mycoplasma_ge_20180517_1128_my_external_pgap.250744/305417/export_bacterial_annot.10054032/inp/prosplign_filtered.mft \
    # -prosplign-raw-mft \
    # /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/home/badrazat/local-install/data/dev/Mycoplasma_genitalium_G37/GP-23495-Create-FASTA-based-Mycoplasma_ge_20180517_1128_my_external_pgap.250744/305417/export_bacterial_annot.10054032/inp/prosplign_raw.mft \
    # -nogenbank
      
      
outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.output_impl)

  
  
