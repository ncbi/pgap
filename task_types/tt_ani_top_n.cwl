cwlVersion: v1.0
label: "ani_top_n"
# file: task_types/tt_ani_top_n.cwl
class: Workflow # task type
inputs:
  gencoll_asn: File
  blast_align: File
  ANI_cutoff: File
  asn_cache: Directory
  ref_assembly_taxid: int
outputs:
  top:
    type: File
    outputSource: ani_top_identification/top
  annot:
    type: File
    outputSource: ani_top_identification/annot
#/panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/bin/ani_top_identification \
#    -ANI_cutoff \
#    /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/third-party/data/BacterialPipeline/ANI_cutoff/ANI_cutoff.xml \
#    -N \
#    25 \
#    -asn-cache \
#    /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/sequence_cache,/panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe_id_cache/full_id_cache \
#    -input-manifest \
#    /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/ani_top_n.455674852/inp/assm_aligns.mft \
#    -min-gap \
#    10000 \
#    -min-region \
#    1000 \
#    -o \
#    /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/ani_top_n.455674852/out/ani-tax-report.xml \
#    -o-annot \
#    /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/ani_top_n.455674852/out/annot.asn \
#    -query-assembly \
#    /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/gc_create_from_sequences.455674892/out/gencoll.asn \
#    -ref-assembly-id \
#    0 \
#    -ref-assembly-taxid \
#    243273
    
steps:
  ani_top_identification:
    run: ../progs/ani_top_identification.cwl
    in:
      ANI_cutoff: ANI_cutoff
      N: 
        default: 25
      asn_cache: asn_cache
      input: blast_align
      min_gap: 
        default: 10000
      min_region: 
        default: 1000
      query_assembly: gencoll_asn
      ref_assembly_id: 
        default: 0
      ref_assembly_taxid: ref_assembly_taxid
    out: [annot, top]
