cwlVersion: v1.0 
label: "gpx_qsubmit"
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/pgap:latest
requirements:
  - class: InitialWorkDirRequirement
    listing:
#      - entry: $(inputs.asn_cache)
#        writable: True
      - entry: $(inputs.blastdb_dir)
        writable: False


baseCommand: gpx_qsubmit
# this is only one example
# 
# 
# 
# /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/bin/gpx_qsubmit \
#     -affinity \
#     subject \
#     -asn-cache \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/sequence_cache,/panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/third-party/data/BacterialPipeline/uniColl/ver-3.2/cache \
#     -max-batch-length \
#     10000 \
#     -nogenbank \
#     -S \
#     GPIPE_SCHED1 \
#     -D \
#     GPipeSched_Prod1 \
#     -U \
#     gpipe_prod \
#     -P \
#     gpipe2007 \
#     -queue \
#     GPIPE_BCT.tblastn_wnode.455674222.1521226579 \
#     -db-manifest \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/tblastn_wnode.455674222/inp/blastdb.mft \
#     -ids-manifest \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/tblastn_wnode.455674222/inp/gilist.mft
# 
# 
# 
# /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/bin/tblastn_wnode \
#     -align_filter \
#     'pct_identity_gapopen_only \
#     >= \
#     75' \
#     -asn-cache \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/sequence_cache,/panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/third-party/data/BacterialPipeline/uniColl/ver-3.2/cache \
#     -backlog \
#     1 \
#     -comp_based_stats \
#     F \
#     -db_gencode \
#     4 \
#     -dbsize \
#     6000000000 \
#     -delay \
#     0 \
#     -evalue \
#     0.1 \
#     -gapextend \
#     2 \
#     -gapopen \
#     9 \
#     -matrix \
#     BLOSUM62 \
#     -max-jobs \
#     1 \
#     -seg \
#     no \
#     -service \
#     GPipeExec_Prod \
#     -soft_masking \
#     true \
#     -threshold \
#     21 \
#     -word_size \
#     6 \
#     -nogenbank \
#     -queue \
#     GPIPE_BCT.tblastn_wnode.455674222.1521226579
# 
# 
# 
# /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/bin/gpx_make_outputs \
#     -output \
#     '/panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/tblastn_wnode.455674222/out/blast.#.asn' \
#     -output-manifest \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/tblastn_wnode.455674222/out/blast_align.mft \
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
#     GPIPE_BCT.tblastn_wnode.455674222.1521226579 \
#     -num-partitions \
#     1
# 
# 
# 
# /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/bin/gp_register_stats \
#     -ifmt \
#     seq-align-set \
#     -input-manifest \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/tblastn_wnode.455674222/out/blast_align.mft
# 
# 
# 
inputs:
  ids:
    type: File?
    inputBinding: 
        prefix: -ids
  NxM_threshold:
    type: int?
    inputBinding:
      prefix: -NxM-threshold
  affinity:
    type: string?
    default: subject
    inputBinding:
      prefix: -affinity
  asn_cache:
    type: Directory
    inputBinding:
      prefix: -asn-cache
  batch_size:
    type: int?
    inputBinding:
      prefix: -batch-size
  max_batch_length:
    type: int?
    default: 50000
    inputBinding:
      prefix: -max-batch-length
  nogenbank:
    type: boolean?
    inputBinding:
      prefix: -nogenbank
  overlap:
    type: int?
    inputBinding:
      prefix: -overlap
  subseq_size:
    type: int?
    inputBinding:
      prefix: -subseq-size
  xml_jobs:
    type: string
    default: jobs.xml
    inputBinding:
      prefix: -o
  blastdb_dir:
    type: Directory?
  blastdb:
    type: string?
    inputBinding:
      prefix: -db
      valueFrom: $(inputs.blastdb_dir.path)/$(inputs.blastdb)
outputs:
#  asncache:
#    type: Directory
#    outputBinding:
#      glob: $(inputs.asn_cache.basename)
  jobs:
    type: File
    outputBinding:
      glob: $(inputs.xml_jobs)    
