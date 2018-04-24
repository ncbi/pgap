cwlVersion: v1.0 
label: "align_sort"
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

baseCommand: align_sort
# this is only one example
# 
# 
# 
# /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/bin/align_sort \
#     -tmp \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/align_sort_sas.455674242/tmp \
#     -asn-cache \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/sequence_cache,/panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/third-party/data/BacterialPipeline/uniColl/ver-3.2/cache \
#     -ifmt \
#     seq-align-set \
#     -input-manifest \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/align_sort_sas.455674242/inp/align.mft \
#     -k \
#     'query \
#     subject' \
#     -logfile \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/align_sort_sas.455674242/log/align_sort.log \
#     -o \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/align_sort_sas.455674242/out/align.asn \
#     -nogenbank
# 
# 
# 
# /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/bin/gp_register_stats \
#     -ifmt \
#     seq-align \
#     -input \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/align_sort_sas.455674242/out/align.asn
# 
# 
# 
inputs:
  asn_cache:
    type: Directory
    inputBinding:
      prefix: -asn-cache
      valueFrom: 
  group:
    type: int
    inputBinding:
      prefix: -group
      valueFrom: 
  ifmt:
    type: string
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
  k:
    type: string?
    inputBinding:
      prefix: -k
      valueFrom: 
  nogenbank:
    type: boolean
    inputBinding:
      prefix: -nogenbank
      valueFrom: 
  output_name:
    type: string
    default: align.asn
    inputBinding:
      prefix: -o
      valueFrom: 
  top:
    type: int
    inputBinding:
      prefix: -top
      valueFrom: 
outputs:
    output:
        type: File
        outputBinding:
            glob: $(inputs.output_name)
            
