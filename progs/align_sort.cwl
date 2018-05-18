cwlVersion: v1.0 
label: "align_sort"
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest


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
#     'query -score subject' \
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
  group:
    type: int
    inputBinding:
      prefix: -group
  ifmt:
    type: string
    inputBinding:
      prefix: -ifmt
  input_manifest:
    type: File?
    inputBinding:
      prefix: -input-manifest
  input:
    type: File?
    inputBinding:
      prefix: -input
  k:
    type: string?
    inputBinding:
      prefix: -k
  nogenbank:
    type: boolean
    inputBinding:
      prefix: -nogenbank
  output_name:
    type: string
    default: align.asn
    inputBinding:
      prefix: -o
  top:
    type: int
    inputBinding:
      prefix: -top
outputs:
    output:
        type: File
        outputBinding:
            glob: $(inputs.output_name)
            
