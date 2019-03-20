cwlVersion: v1.0
label: "kmer_top_n"
# file: task_types/tt_kmer_top_n.cwl
class: Workflow # task type
#/panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/bin/kmer_top_identification \
#    -N \
#    20 \
#    -distances-manifest \
#    /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/kmer_top_n.455674842/inp/distances.mft \
#    -omatches \
#    /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/kmer_top_n.455674842/tmp/matches \
#    -oxml \
#    /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/kmer_top_n.455674842/out/top_distances.xml \
#    -threshold \
#    0.8
inputs:
  distances: File
outputs:
  matches:
    type: File[]
    outputSource: kmer_top_identification/matches
  top_distances:
    type: File
    outputSource: kmer_top_identification/top_distances
steps:
  kmer_top_identification:
    run: ../progs/kmer_top_identification.cwl
    in:
      N:    
        default: 20
      distances: distances
      threshold: 
        default: 0.8
    out: [top_distances, matches]
