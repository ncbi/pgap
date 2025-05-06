cwlVersion: v1.2
label: "align_sort_ma"
#
# the difference between this and align_sort is "ma" which stands for (M)ultiple (A)sn-caches
#

class: CommandLineTool


baseCommand: align_sort
inputs:
  asn_cache:
    type: Directory[]
    inputBinding:
      prefix: -asn-cache
      itemSeparator: ","
  group:
    type: int?
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
    type: int?
    inputBinding:
      prefix: -top
outputs:
    output:
        type: File
        outputBinding:
            glob: $(inputs.output_name)
            
