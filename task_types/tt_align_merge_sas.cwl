cwlVersion: v1.0
label: "align_merge_sas"
class: Workflow # task type
hints:
  DockerRequirement:
    dockerPull: ncbi/bacterial_noncoding:pgap4.5
    dockerPull: ncbi/taxonomy_check_16S:pgap4.5
inputs:
  blastdb: File
  blastdb_dir: Directory
  asn_cache: Directory
  blast_align: File
  allow_intersection: boolean
  collated: boolean
  compart: boolean
  fill_gaps: boolean
  filter: string?
  max_discontinuity: int?
  top_compartment_only: boolean
outputs:
  align:
    type: File
    outputSource: align_merge/align
steps:
  align_merge:
    run: ../progs/align_merge.cwl
    in:
      allow_intersection: allow_intersection
      asn_cache: asn_cache
      collated: collated
      compart: compart
      fill_gaps: fill_gaps
      filter: filter
      ifmt: 
        default: seq-align-set
      input: 
        default: $(inputs.blast_align)
      max_discontinuity: max_discontinuity
      top_compartment_only: top_compartment_only
      blastdb: blastdb
      blastdb_dir: blastdb_dir
    out: [align]