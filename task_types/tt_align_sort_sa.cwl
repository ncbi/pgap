cwlVersion: v1.0
label: "align_sort_sa"
class: Workflow # task type
hints:
  DockerRequirement:
    dockerPull: ncbi/pgap:latest
inputs:
  align: File
  asn_cache: Directory
  group: int
  k: string
  top: int
outputs:
  out_align:
    type: File
    outputSource: align_sort/output
steps:
  align_sort:
    run: ../progs/align_sort.cwl
    in:
      asn_cache: asn_cache
      group: group
      ifmt: 
        default: seq-align
      input: align
      k: k
      top: top
      nogenbank:
        default: false
    out: [output]