cwlVersion: v1.0 
label: "blastn_wnode"

class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest
requirements:
  - class: InitialWorkDirRequirement
    listing:
#      - entry: $(inputs.asn_cache)
#        writable: True
      - entry: $(inputs.blastdb_dir)
        writable: False

baseCommand: blastn_wnode
# this is only one example
# 
# 
# 
# /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/bin/gpx_qsubmit \
#     -affinity \
#     subject \
#     -asn-cache \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/sequence_cache \
#     -max-batch-length \
#     50000 \
#     -S \
#     GPIPE_SCHED1 \
#     -D \
#     GPipeSched_Prod1 \
#     -U \
#     gpipe_prod \
#     -P \
#     gpipe2007 \
#     -queue \
#     GPIPE_BCT.blastn_wnode.455674942.1521225914 \
#     -db-manifest \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/blastn_wnode.455674942/inp/blastdb.mft \
#     -ids-manifest \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/blastn_wnode.455674942/inp/gilist.mft
# 
# 
# 
# /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/bin/blastn_wnode \
#     -asn-cache \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/sequence_cache \
#     -evalue \
#     0.01 \
#     -max_target_seqs \
#     250 \
#     -service \
#     GPipeExec_Prod \
#     -soft_masking \
#     true \
#     -task \
#     blastn \
#     -word_size \
#     12 \
#     -swap-rows \
#     -queue \
#     GPIPE_BCT.blastn_wnode.455674942.1521225914
# 
# 
# 
# /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/bin/gpx_make_outputs \
#     -output \
#     '/panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/blastn_wnode.455674942/out/blast.#.asn' \
#     -output-manifest \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/blastn_wnode.455674942/out/blast_align.mft \
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
#     GPIPE_BCT.blastn_wnode.455674942.1521225914 \
#     -num-partitions \
#     1
# 
# 
# 
# /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/bin/gp_register_stats \
#     -ifmt \
#     seq-align-set \
#     -input-manifest \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/blastn_wnode.455674942/out/blast_align.mft
# 
# 
# 
inputs:
  asn_cache:
    type: Directory
    inputBinding:
      prefix: -asn-cache
  evalue:
    type: float
    default: 0.01
    inputBinding:
      prefix: -evalue
  max_target_seqs:
    type: int
    default: 250
    inputBinding:
      prefix: -max_target_seqs
  input_jobs:
    type: File
    inputBinding:
      prefix: -input-jobs
  soft_masking:
    type: string
    default: true
    inputBinding:
      prefix: -soft_masking
  swap_rows:
    type: boolean
    inputBinding:
      prefix: -swap-rows
  task:
    type: string?
    default: blastn
    inputBinding:
      prefix: -task
  word_size:
    type: int
    default: 12
    inputBinding:
      prefix: -word_size
  output_dir:
    type: string?
    default: output
    inputBinding:
      prefix: -O
  blastdb_dir:
    type: Directory?
  blastdb:
    type: string?
    inputBinding:
      prefix: -blastdb
      valueFrom: $(inputs.blastdb_dir.path)/$(inputs.blastdb)
outputs:
  outdir:
    type: Directory
    outputBinding:
      glob: $(inputs.output_dir)
