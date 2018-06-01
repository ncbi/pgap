#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

label: "Seed Search Compartments"

inputs:
  asn_cache: Directory
  uniColl_asn_cache: Directory
  asn: File

outputs: 
  blast_align:
    type: File
    outputSource: gpx_dump/seed_align

steps:
  gpx_qsubmit:
    run: gpx_qsubmit.cwl
    in:
      asn_cache: asn_cache
      uniColl_asn_cache: uniColl_asn_cache
      asn: asn
    out: [jobs]
  
  cut_job_path:
    run: cut_job_path.cwl
    in:
      file_in: gpx_qsubmit/jobs
    out: [ file_out ]

  tblastn_wnode:
    run: tblastn_wnode.cwl
    in:
      asn_cache: asn_cache
      uniColl_asn_cache: uniColl_asn_cache
      asn: asn
      input_jobs: cut_job_path/file_out
      #blastdb_dir: blastdb_dir
    out: [outdir]

  gpx_dump:
    run: gpx_qdump.cwl
    in:
      input_path: tblastn_wnode/outdir
    out: [seed_align]


