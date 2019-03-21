cwlVersion: v1.0 
label: "kmer_compare_wnode"

class: CommandLineTool
#
# You might need something like this:
#
# requirements:
#  - class: InitialWorkDirRequirement
#    listing:
#      - entry: $(inputs.asn_cache)
#        writable: True
#      - entry: $(inputs.blastdb_dir)
#        writable: False

baseCommand: kmer_compare_wnode
# this is only one example
# 
# 
# 
# /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/bin/submit_kmer_compare \
#     -S \
#     GPIPE_SCHED1 \
#     -D \
#     GPipeSched_Prod1 \
#     -U \
#     gpipe_prod \
#     -P \
#     gpipe2007 \
#     -queue \
#     GPIPE_BCT.kmer_ref_compare_wnode.455674762.1521225984 \
#     -kmer-files-manifest \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/kmer_ref_compare_wnode.455674762/inp/kmer_file_list.mft \
#     -ref-kmer-files-manifest \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/kmer_ref_compare_wnode.455674762/inp/ref_kmer_file_list.mft
# 
# 
# 
# /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/bin/kmer_compare_wnode \
#     -dist-method \
#     minhash \
#     -minhash-signature \
#     minhash \
#     -score-method \
#     boolean \
#     -service \
#     GPipeExec_Prod \
#     -queue \
#     GPIPE_BCT.kmer_ref_compare_wnode.455674762.1521225984
# 
# 
# 
# /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/bin/gpx_make_outputs \
#     -num-partitions \
#     32 \
#     -output \
#     '/panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/kmer_ref_compare_wnode.455674762/out/distances.##.gz' \
#     -output-manifest \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/kmer_ref_compare_wnode.455674762/out/distances.mft \
#     -S \
#     GPIPE_SCHED1 \
#     -D \
#     GPipeSched_Prod1 \
#     -U \
#     gpipe_prod \
#     -P \
#     gpipe2007 \
#     -queue \
#     GPIPE_BCT.kmer_ref_compare_wnode.455674762.1521225984
# 
# 
# 
inputs:
  kmer_cache_sqlite:
        type: File
        inputBinding:
            prefix: -kmer-cache-uri
  dist_method:
    type: string?
    inputBinding:
      prefix: -dist-method
  minhash_signature:
    type: string?
    inputBinding:
      prefix: -minhash-signature
  score_method:
    type: string?
    inputBinding:
      prefix: -score-method
  jobs:
    type: File
    inputBinding:
      prefix: -input-jobs 
  O:
    type: string
    default: outdir
    inputBinding:
        prefix: -O
        
outputs: 
    outdir:
        type: Directory
        outputBinding:
            glob: $(inputs.O)