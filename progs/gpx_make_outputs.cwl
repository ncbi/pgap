cwlVersion: v1.0 
label: "gpx_make_outputs program"
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/pgap:latest
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

baseCommand: gpx_make_outputs
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
  input_path:
    type: Directory
    inputBinding:
      prefix: -input-path
  num_partitions:
    type: int
    default: 32
    inputBinding:
      prefix: -num-partitions
  output:
    type: string?
    # this needs to match outputs/blast_align/outputBinding/glob
    default: "blast.#.asn"
    inputBinding:
      prefix: -output
#  output_manifest:
#    type: string
#    default: blastn.mft
#    inputBinding:
#      prefix: -output-manifest
  unzip:
    type: string?
    default: "*"
    inputBinding:
      prefix: -unzip
outputs:
  blast_align:
    type: File
    outputBinding:
        # this needs to match inputs/output_name/default
      glob: blast.*.asn
