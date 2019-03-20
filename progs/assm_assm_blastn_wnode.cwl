cwlVersion: v1.0 
label: "assm_assm_blastn_wnode"

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

baseCommand: assm_assm_blastn_wnode
# this is only one example
# 
# 
# 
# /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/bin/gpx_qsubmit \
#     -affinity \
#     subject \
#     -asn-cache \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/sequence_cache \
#     -S \
#     GPIPE_SCHED1 \
#     -D \
#     GPipeSched_Prod1 \
#     -U \
#     gpipe_prod \
#     -P \
#     gpipe2007 \
#     -queue \
#     GPIPE_BCT.assm_assm_blastn_wnode.455674742.1521226198 \
#     -xml-jobs \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/assm_assm_blastn_wnode.455674742/inp/jobs.xml
# 
# 
# 
# /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/bin/assm_assm_blastn_wnode \
#     -target-set-manifest \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/assm_assm_blastn_wnode.455674742/inp/assemblies.mft \
#     -asn-cache \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/sequence_cache,/panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe_id_cache/full_id_cache/ \
#     -evalue \
#     0.0001 \
#     -gapextend \
#     1 \
#     -gapopen \
#     2 \
#     -max-bases-per-call \
#     500000000 \
#     -max_target_seqs \
#     250 \
#     -merge-align-filter \
#     '((reciprocity \
#     = \
#     3 \
#     AND \
#     align_length_ungap \
#     >= \
#     5) \
#     OR \
#     align_length \
#     > \
#     1000) \
#     AND \
#     pct_identity_gap \
#     > \
#     25' \
#     -merge-engine \
#     tree-merger \
#     -service \
#     GPipeExec_Prod \
#     -soft_masking \
#     true \
#     -task \
#     megablast \
#     -window_size \
#     150 \
#     -word_size \
#     28 \
#     -workers-per-cpu \
#     0.4 \
#     -compart \
#     -use-common-components \
#     -queue \
#     GPIPE_BCT.assm_assm_blastn_wnode.455674742.1521226198
# 
# 
# 
# /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/bin/gpx_qdump \
#     -output \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/assm_assm_blastn_wnode.455674742/out/blast.asn \
#     -output-manifest \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/assm_assm_blastn_wnode.455674742/out/blast_align.mft \
#     -unzip \
#     '*' \
#     -S \
#     GPIPE_SCHED1 \
#     -D \
#     GPipeSched_Prod1 \
#     -U \
#     gpipe_prod \
#     -P \
#     gpipe2007 \
#     -queue \
#     GPIPE_BCT.assm_assm_blastn_wnode.455674742.1521226198
# 
# 
# 
# /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/bin/gp_register_stats \
#     -ifmt \
#     seq-annot \
#     -input \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/assm_assm_blastn_wnode.455674742/out/blast.asn
# 
# 
# 
inputs:
  input_jobs:
    type: File?
    inputBinding:
        prefix: -input-jobs 
  asn_cache:
    type: Directory
    inputBinding:
      prefix: -asn-cache
  compart:
    type: boolean?
    inputBinding:
      prefix: -compart
  evalue:
    type: float?
    inputBinding:
      prefix: -evalue
  gapextend:
    type: int?
    inputBinding:
      prefix: -gapextend
  gapopen:
    type: int?
    inputBinding:
      prefix: -gapopen
  max_bases_per_call:
    type: int?
    inputBinding:
      prefix: -max-bases-per-call
  max_target_seqs:
    type: int?
    inputBinding:
      prefix: -max_target_seqs
  merge_align_filter:
    type: string?
    inputBinding:
      prefix: -merge-align-filter
  merge_engine:
    type: string?
    inputBinding:
      prefix: -merge-engine
  soft_masking:
    type: string?
    inputBinding:
      prefix: -soft_masking
  task:
    type: string?
    inputBinding:
      prefix: -task
  use_common_components:
    type: boolean
    inputBinding:
      prefix: -use-common-components
  window_size:
    type: int?
    inputBinding:
      prefix: -window_size
  word_size:
    type: int?
    inputBinding:
      prefix: -word_size
  workers_per_cpu:
    type: float?
    inputBinding:
      prefix: -workers-per-cpu
  output_dir:
    type: string?
    default: output
    inputBinding:
      prefix: -O
    
    
outputs:
  outdir:
    type: Directory
    outputBinding:
      glob: $(inputs.output_dir)    