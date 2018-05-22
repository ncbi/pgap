#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

label: "Align reference proteins plane complete workflow"

requirements: 
  - class: SubworkflowFeatureRequirement 
 
inputs:
  asn_cache: Directory
  uniColl_asn_cache: Directory
  uniColl_path: Directory
  blastdb_dir: Directory
  clade: File
  taxid: string
  gc_assembly: File
  asn: File

outputs:
  universal_clusters:  
    type: File
    outputSource: bacterial_prot_src/universal_clusters
  align:  
    type: File
    outputSource: align_filter/align
  align_non_match:  
    type: File
    outputSource: align_filter/align_non_match

steps:
  bacterial_prot_src:
    run: bacterial_prot_src.cwl
    in:
      uniColl_asn_cache: uniColl_asn_cache
      uniColl_path: uniColl_path
      clade: clade
      taxid: taxid
    out: [ universal_clusters, all_prots ]

  wf_seed:
    run: wf_seed.cwl
    in:
      asn_cache: asn_cache
      uniColl_asn_cache: uniColl_asn_cache
      asn: asn
    out: [ blast_align ]

  wf_seed_1:
    run: wf_seed_1.cwl
    in:
      asn_cache: asn_cache
      uniColl_asn_cache: uniColl_asn_cache
      seqids: bacterial_prot_src/all_prots
      blastdb_dir: blastdb_dir
    out: [ blast_align ]

  cat:
    run: cat.cwl
    in:
      file_in_1: wf_seed_1/blast_align
      file_in_2: wf_seed/blast_align
    out: [ blast_all ]

  align_sort:
    run: align_sort.cwl
    in:
      asn_cache: asn_cache
      uniColl_asn_cache: uniColl_asn_cache
      blast_aligns: cat/blast_all
    out: [ sorted_aligns ]

  bacterial_protalign_filter:
    run: bacterial_protalign_filter.cwl
    in:
      asn_cache: asn_cache
      uniColl_asn_cache: uniColl_asn_cache
      sorted_seeds: align_sort/sorted_aligns
    out: [ blast_full_cov, blast_partial_cov ]

  compart_filter_prosplign:
    run: wf_compart_filter_prosplign.cwl
    in:
      asn_cache: asn_cache
      uniColl_asn_cache: uniColl_asn_cache
      seed_hits: bacterial_protalign_filter/blast_partial_cov
      gc_assembly: gc_assembly
    out: [ prosplign_align ]

  align_filter:
    run: wf_align_filter.cwl
    in:
      asn_cache: asn_cache
      uniColl_asn_cache: uniColl_asn_cache
      blast_full: bacterial_protalign_filter/blast_full_cov
      prosplign: compart_filter_prosplign/prosplign_align
    out: [ align, align_non_match ]

