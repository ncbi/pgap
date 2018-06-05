#!/usr/bin/env cwl-runner
label: "Run tRNAScan"
cwlVersion: v1.0
class: Workflow

#requirements:

inputs:
  asn_cache: Directory
  seqids: File
  taxid: int
  taxon_db: File
outputs:
  annots:
    type: File
    outputSource: Run_tRNAScan_trnascan_dump/outasn
  
steps:
  Run_tRNAScan_submit:
    run: gpx_qsubmit_trnascan.cwl
    in:
      asn_cache: asn_cache
      seqids: seqids
    #out: [asncache, jobs]
    out: [jobs]
  
  Run_tRNAScan_wnode:
    run: trnascan_wnode.cwl
    in:
      #asn_cache: Run_tRNAScan_submit/asncache
      asn_cache: asn_cache
      input_jobs: Run_tRNAScan_submit/jobs
      #input_jobs: jobs
      taxid: taxid
      taxon_db: taxon_db
    #out: [asncache, outdir]
    out: [outdir]

  Run_tRNAScan_dump:
    run: gpx_qdump.cwl
    in:
      input_path: Run_tRNAScan_wnode/outdir
    out: [intermediate]
    
  Run_tRNAScan_trnascan_dump:
    run: trnascan_dump.cwl
    in:
      input: Run_tRNAScan_dump/intermediate
    out: [outasn, outstruct]
