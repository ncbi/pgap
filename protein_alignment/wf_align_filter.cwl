#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

label: "Filter Protein Alignments I"

inputs:
  asn_cache: Directory
  uniColl_asn_cache: Directory
  blast_full: File
  prosplign: File

outputs: 
  align:
    type: File
    outputSource: align_filter/align
  align_non_match:
    type: File
    outputSource: align_filter/align_non_match
    
steps:
  cat:
    run: cat.cwl
    in:
      file_in_1: blast_full
      file_in_2: prosplign
    out: [ file_out ]
     
  align_filter:
    run: align_filter.cwl
    in:
      asn_cache: asn_cache
      uniColl_asn_cache: uniColl_asn_cache
      file_in: cat/file_out
    out: [ align, align_non_match ]
