#!/usr/bin/env cwl-runner
label: taxonomy_check_16S
cwlVersion: v1.0
class: Workflow
requirements: 
    - class: SubworkflowFeatureRequirement    
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest
inputs:
  Format_16S_rRNA___entry: File
  asn_cache: Directory
  blastdb_dir: Directory
  taxid: int
  taxon_db: File
outputs:
  report:
    type: File
    outputSource: Taxonomic_consistency_check_based_on_16S_Analysis/report
steps:
  Format_16S_rRNA:
    label: Format 16S rRNA
    doc: finds 16S in input annotations and makes a seq-entry
    run: ../task_types/tt_format_rrnas_from_seq_entry.cwl
    in:
      entry: Format_16S_rRNA___entry
    out: [rna]
  # Get_16S_rRNA_BLASTdb_for_taxonomic_consistency_check: 
  #  run: ../task_types/tt_const_blastdb.cwl
  #  out: [blastdb]
  Cache_Genomic_16S_Sequences:
    label: Cache Genomic 16S Sequences
    run: ../task_types/tt_cache_asnb_entries.cwl
    in:
      rna: Format_16S_rRNA/rna
      cache: asn_cache
      ifmt: 
        default: asnb-seq-entry
      taxid: taxid
    out: [ids_out, asncache]
  BLAST_against_16S_rRNA_db_for_taxonomic_consistency_check:
    label: BLAST against 16S rRNA db for taxonomic consistency check
    run: ../task_types/tt_blastn_wnode.cwl
    in:
      ids_out: Cache_Genomic_16S_Sequences/ids_out
      blastdb_dir: blastdb_dir
      blastdb: 
        default: "blastdb"
      gilist: Cache_Genomic_16S_Sequences/ids_out
      evalue:
        default: 0.01
      max_target_seqs:
        default: 250
      word_size: 
        default: 12
      asn_cache: Cache_Genomic_16S_Sequences/asncache
      affinity: 
        default: subject
      max_batch_length:
        default: 50000
      soft_masking:
        default: 'true'
    out: [blast_align]
  Consolidate_alignments_for_taxonomic_consistency_check:
    label: Consolidate alignments for taxonomic consistency check
    run: ../task_types/tt_align_merge_sas.cwl
    in:
      blastdb_dir: blastdb_dir
      blastdb: 
        default: "blastdb"
      blast_align: BLAST_against_16S_rRNA_db_for_taxonomic_consistency_check/blast_align
      asn_cache: Cache_Genomic_16S_Sequences/asncache
      allow_intersection: 
        default: true
      collated:
        default: true
      compart:
        default: true
      fill_gaps:
        default: false
      top_compartment_only:
        default: true
    out: [align]
  Well_covered_alignments_for_taxonomic_consistency_check:
    label: Well covered alignments for taxonomic consistency check
    run: ../task_types/tt_align_filter_sa.cwl
    in:
      # prosplign_align: 
      #  default: ""
      # align_full: 
      #  default: ""
      align: Consolidate_alignments_for_taxonomic_consistency_check/align
      asn_cache: Cache_Genomic_16S_Sequences/asncache
      filter: 
        default: "pct_coverage >= 20"
      nogenbank:
        default: false
    out: [out_align]
  Pick_tops_for_taxonomic_consistency_check:
    label: Pick tops for taxonomic consistency check
    run: ../task_types/tt_align_sort_sa.cwl
    in:
      align: Well_covered_alignments_for_taxonomic_consistency_check/out_align
      asn_cache: Cache_Genomic_16S_Sequences/asncache
      group: 
        default: 1
      k: 
        default: "query subject"
      top:
        default: 20
    out: [out_align]
  Taxonomic_consistency_check_based_on_16S_Analysis:
    label: Taxonomic consistency check based on 16S Analysis
    run: ../task_types/tt_taxonomy_check_16S.cwl
    in: 
      blastdb_dir: blastdb_dir
      blastdb: 
        default: "blastdb"
      asn_cache: Cache_Genomic_16S_Sequences/asncache
      align: Pick_tops_for_taxonomic_consistency_check/out_align
      taxon_db: taxon_db
    out: [report]
