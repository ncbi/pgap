#!/usr/bin/env cwl-runner

cwlVersion: v1.2
class: Workflow

label: "Seed Protein Alignments"

inputs:
  asn_cache: Directory
  uniColl_asn_cache: Directory
  seqids: File
  blastdb_dir: Directory
  db_gencode: int

outputs: 
  blast_align:
    type: File
    outputSource: gpx_make_outputs/blast_align

steps:
  gpx_qsubmit:
    run: gpx_qsubmit_1.cwl
    in:
      asn_cache: asn_cache
      uniColl_asn_cache: uniColl_asn_cache
      seqids: seqids
      blastdb_dir: blastdb_dir
    out: [jobs]
  
  tblastn_wnode:
    run: tblastn_wnode_1.cwl
    in:
      db_gencode: db_gencode
      asn_cache: asn_cache
      uniColl_asn_cache: uniColl_asn_cache
      input_jobs: gpx_qsubmit/jobs
      blastdb_dir: blastdb_dir
    out: [outdir]

  gpx_make_outputs:
    run: gpx_make_outputs.cwl
    in:
      input_path: tblastn_wnode/outdir
    out: [blast_align]


