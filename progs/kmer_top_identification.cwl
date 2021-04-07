cwlVersion: v1.2
label: "kmer_top_identification"
class: CommandLineTool
baseCommand: kmer_top_identification
# this is only one example
# 
# 
# 
# kmer_top_identification  -N 20 \
#     -distances-manifest kmer_top_n.455674842/inp/distances.mft \
#     -omatches kmer_top_n.455674842/tmp/matches \
#     -oxml kmer_top_n.455674842/out/top_distances.xml \
#     -threshold 0.8
#

inputs:
  kmer_cache_sqlite:
        type: File
        inputBinding:
            prefix: -kmer-cache-uri
  N:
        type: int?
        inputBinding:
            prefix: -N
  distances:
    type: File
    inputBinding:
      prefix: -distances
  omatches:
    type: string
    default: matches.txt
    inputBinding:
      prefix: -omatches
  oxml:
    type: string
    default: top_distances.xml
    inputBinding:
      prefix: -oxml
  threshold:
    type: float
    inputBinding:
      prefix: -threshold
outputs:
    matches:
        type: File
        outputBinding:
            glob: $(inputs.omatches)
    top_distances:
        type: File
        outputBinding:
            glob: $(inputs.oxml)
