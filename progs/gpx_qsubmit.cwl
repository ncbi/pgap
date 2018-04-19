cwlVersion: v1.0 
label: "gpx_qsubmit"
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/protein_alignment:pgap4.5
    dockerPull: ncbi/spurious_annot:pgap4.5
    dockerPull: ncbi/bacterial_mobile_elem:pgap4.5
    dockerPull: ncbi/AMR_naming:pgap4.5
    dockerPull: ncbi/bacterial_noncoding:pgap4.5
    dockerPull: ncbi/bacterial_annot:pgap4.5
    dockerPull: ncbi/bacterial_kmer:pgap4.5
    dockerPull: ncbi/bacterial_trna:pgap4.5
    dockerPull: ncbi/bacterial_ncrna:pgap4.5
    dockerPull: ncbi/clade_assign:pgap4.5
    dockerPull: ncbi/taxonomy_check_16S:pgap4.5
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
  NxM_threshold:
    type: int
    default: 10000
    inputBinding:
      prefix: -NxM-threshold
      valueFrom: 
  affinity:
    type: string?
    default: subject
    inputBinding:
      prefix: -affinity
      valueFrom: 
  asn_cache:
    type: Directory
    inputBinding:
      prefix: -asn-cache
      valueFrom: 
  batch_size:
    type: int
    default: 1
    inputBinding:
      prefix: -batch-size
      valueFrom: 
  max_batch_length:
    type: int
    default: 50000
    inputBinding:
      prefix: -max-batch-length
      valueFrom: 
  nogenbank:
    type: boolean
    inputBinding:
      prefix: -nogenbank
      valueFrom: 
  overlap:
    type: int
    default: 100
    inputBinding:
      prefix: -overlap
      valueFrom: 
  subseq_size:
    type: int
    default: 200
    inputBinding:
      prefix: -subseq-size
      valueFrom: 
  xml_jobs:
    type: File
    default: jobs.xml
    inputBinding:
      prefix: -xml-jobs
      valueFrom: 
  blastdb_dir:
    type: Directory?
  blastdb:
    type: string?
    inputBinding:
      prefix: -db
      valueFrom: $(inputs.blastdb_dir.path)/$(inputs.blastdb)
outputs:
  asncache:
    type: Directory
    outputBinding:
      glob: $(inputs.asn_cache.basename)
  jobs:
    type: File
    outputBinding:
      glob: $(inputs.xml_jobs)    
