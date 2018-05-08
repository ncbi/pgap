cwlVersion: v1.0 
label: "gpx_qdump"
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest
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

baseCommand: gpx_qdump
# this is only one example
# 
# 
# 
# /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/bin/gpx_qsubmit \
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
#     GPIPE_BCT.gcmsearch_wnode.455675022.1521225916 \
#     -ids-manifest \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/gcmsearch_wnode.455675022/inp/seqids.mft
# 
# 
# 
# /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/bin/cmsearch_wnode \
#     -asn-cache \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/sequence_cache \
#     -cmsearch-cpu \
#     0 \
#     -cmsearch-path \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/third-party/infernal/arch/x86_64/bin/ \
#     -model-path \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/third-party/data/Rfam/pgap-3.1/CMs/RF00001.cm \
#     -rfam-amendments \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/etc/bacterial_pipeline/rfam-amendments.xml \
#     -rfam-stockholm \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/third-party/data/Rfam/pgap-3.1/Rfam.seed \
#     -service \
#     GPipeExec_Prod \
#     -queue \
#     GPIPE_BCT.gcmsearch_wnode.455675022.1521225916
# 
# 
# 
# /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/bin/gpx_qdump \
#     -output \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/gcmsearch_wnode.455675022/out/cmsearch.asn \
#     -output-manifest \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/gcmsearch_wnode.455675022/out/placements.mft \
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
#     GPIPE_BCT.gcmsearch_wnode.455675022.1521225916
# 
# 
# 
inputs:
  input_path:
    type: Directory
    inputBinding:
      prefix: -input-path
  output_name:
    type: string?
    default: "blast_align.asn"
    inputBinding:
      prefix: -output
  unzip:
    type: string?
    inputBinding:
      prefix: -unzip
outputs:
  blast_align:
    type: File
    outputBinding:
      glob: $(inputs.output_name)
