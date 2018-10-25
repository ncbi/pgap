cwlVersion: v1.0 
label: "align_filter"

class: CommandLineTool
hints:
    
baseCommand: align_filter
# this is only one example
# 
# 
# 
# /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/bin/align_filter \
#     -onon-match \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/align_filter_sa.455675142/out/align-nomatch.asn \
#     -asn-cache \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/sequence_cache \
#     -filter \
#     'pct_coverage \
#     >= \
#     20' \
#     -ifmt \
#     seq-align \
#     -input-manifest \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/align_filter_sa.455675142/inp/align.mft \
#     -logfile \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/align_filter_sa.455675142/log/align_filter.log \
#     -o \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/align_filter_sa.455675142/out/align.asn
# 
# 
# 
# /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/bin/gp_register_stats \
#     -ifmt \
#     seq-align \
#     -input \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/align_filter_sa.455675142/out/align.asn
# 
# 
# 
inputs:
  asn_cache:
    type: Directory[]
    inputBinding:
      prefix: -asn-cache
      itemSeparator: ","
  filter:
    type: string?
    inputBinding:
      prefix: -filter
  ifmt:
    type: string?
    inputBinding:
      prefix: -ifmt
  input:
    type: File?
    inputBinding:
      prefix: -input
  nogenbank:
    type: boolean
    inputBinding:
      prefix: -nogenbank
  onon_match_name: 
    type: string
    default: align-nomatch.asn
    inputBinding:
        prefix:  -onon-match
  o_name: 
    type: string
    default: align.asn
    inputBinding:
        prefix:  -o
outputs:
   o:
        type: File
        outputBinding:
            glob: $(inputs.o_name)
   onon_match:
        type: File
        outputBinding:
            glob: $(inputs.onon_match_name)
