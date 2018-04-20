cwlVersion: v1.0 
label: "align_merge"
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/pgap:latest
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

baseCommand: align_merge
# this is only one example
# 
# 
# 
# /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/bin/align_merge \
#     -blastdb \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/ThirdParty/ExternalData/BacterialPipeline/23S_rRNA/2013-05-15/Ribosom23S \
#     -asn-cache \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/sequence_cache \
#     -filter \
#     'align_length \
#     >= \
#     50' \
#     -ifmt \
#     seq-align-set \
#     -input-manifest \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/align_merge_sas.455675002/inp/align.mft \
#     -logfile \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/align_merge_sas.455675002/log/align_merge.log \
#     -max-discontinuity \
#     20 \
#     -o \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/align_merge_sas.455675002/out/align.asn \
#     -collated \
#     -compart \
#     -fill-gaps
# 
# 
# 
# /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/bin/gp_register_stats \
#     -ifmt \
#     seq-align \
#     -input \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/align_merge_sas.455675002/out/align.asn
# 
# 
# 
inputs:
  allow_intersection:
    type: boolean
    inputBinding:
      prefix: -allow-intersection
      valueFrom: 
  asn_cache:
    type: Directory
    inputBinding:
      prefix: -asn-cache
      valueFrom: 
  collated:
    type: boolean
    inputBinding:
      prefix: -collated
      valueFrom: 
  compart:
    type: boolean
    inputBinding:
      prefix: -compart
      valueFrom: 
  fill_gaps:
    type: boolean
    inputBinding:
      prefix: -fill-gaps
      valueFrom: 
  filter:
    type: string?
    inputBinding:
      prefix: -filter
      valueFrom: 
  ifmt:
    type: string?
    inputBinding:
      prefix: -ifmt
      valueFrom: 
  input_manifest:
    type: File?
    inputBinding:
      prefix: -input-manifest
      valueFrom: 
  input:
    type: File?
    inputBinding:
      prefix: -input
      valueFrom: 
  max_discontinuity:
    type: int?
    default: 20
    inputBinding:
      prefix: -max-discontinuity
      valueFrom: 
  top_compartment_only:
    type: boolean
    inputBinding:
      prefix: -top-compartment-only
      valueFrom: 
  align_name:
    type: string
    default: align.asn
    inputBinding:
        prefix: -o
outputs:
   align:
        type: File
        outputBinding:
            glob: $(input.align_name)
