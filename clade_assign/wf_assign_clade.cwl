#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

label: "Assign Clade"

inputs:
  asn_cache: Directory
  CladeMarkers_asn_cache: Directory
  assembly_id: string
  hits: File
  ani: File
#  clade_tree: File
  reference_set: File

outputs:
  clade_assignment:
    type: File
    outputSource: assign_clade_bacteria/clade_assignment

steps:
  align_sort:
    run: align_sort.cwl
    in:
      hits: hits
    out: [ sorted_aligns ]

  assign_clade_bacteria:
    run: assign_clade_bacteria.cwl
    in:
      sorted_aligns: align_sort/sorted_aligns
      assembly_id: assembly_id
      asn_cache: asn_cache
      CladeMarkers_asn_cache: CladeMarkers_asn_cache
      ani: ani
#      clade_tree: clade_tree
      reference_set: reference_set
    out: [ clade_assignment ]

