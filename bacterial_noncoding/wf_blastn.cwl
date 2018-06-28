#!/usr/bin/env cwl-runner
label: "BLAST against rRNA db"
cwlVersion: v1.0
class: Workflow

#requirements:

inputs:
  asn_cache: Directory
  seqids: File
  blastdb_dir: Directory
  blastdb: string
  product_name: string
  outname: string
  
outputs:
  annotations:
    type: File
    outputSource: Generate_nS_rRNA_Annotation/annotations
    
steps:
  BLAST_against_nS_rRNA_db_gpx_qsubmit:
    run: gpx_qsubmit_blastn.cwl
    in:
      asn_cache: asn_cache
      seqids: seqids
      blastdb_dir: blastdb_dir
      blastdb: blastdb
    out: [jobs]
  
  BLAST_against_nS_rRNA_db_blastn_wnode:
    run: blastn_wnode.cwl
    in:
      asn_cache: asn_cache
      input_jobs: BLAST_against_nS_rRNA_db_gpx_qsubmit/jobs
      blastdb_dir: blastdb_dir
    out: [outdir]

  BLAST_against_nS_rRNA_db_gpx_make_outputs:
    run: gpx_make_outputs.cwl
    in:
      input_path: BLAST_against_nS_rRNA_db_blastn_wnode/outdir
    out: [blast_align]

  Merge_nS_rRNA_Alignments:
    run: align_merge.cwl
    in:
      asn_cache: asn_cache
      blastdb_dir: blastdb_dir
      blastdb: blastdb
      alignments: BLAST_against_nS_rRNA_db_gpx_make_outputs/blast_align
    out: [aligns]

  Generate_nS_rRNA_Annotation:
    run: ribosomal_align2annot.cwl
    in:
      asn_cache: asn_cache
      blastdb_dir: blastdb_dir
      blastdb: blastdb
      product_name: product_name
      alignments: Merge_nS_rRNA_Alignments/aligns
      annotation: outname
    out: [annotations]
