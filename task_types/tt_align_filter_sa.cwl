cwlVersion: v1.2
label: "align_filter_sa"
class: Workflow # task type
requirements:
  - class: ScatterFeatureRequirement

inputs:
  asn_cache: Directory
  prosplign_align: File?
  align_full: File?
  align: File?
  nogenbank: boolean
  filter: string
outputs:
  out_align:
    type: File
    outputSource: align_filter/o
steps:
  align_filter:
    run: ../progs/align_filter.cwl
    in:
      asn_cache: asn_cache
      filter: filter
      ifmt: 
        default: seq-align
      input: 
        source: [align]
        linkMerge: merge_flattened
      nogenbank: nogenbank
        
    out: [o]
