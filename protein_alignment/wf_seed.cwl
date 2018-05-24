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
  
  tblastn_wnode:
    run: tblastn_wnode.cwl
    in:
      asn_cache: asn_cache
      uniColl_asn_cache: uniColl_asn_cache
      input_jobs: gpx_qsubmit/jobs
      #blastdb_dir: blastdb_dir
    out: [outdir]

  gpx_dump:
    run: gpx_qdump.cwl
    in:
      input_path: tblastn_wnode/outdir
    out: [seed_align]


