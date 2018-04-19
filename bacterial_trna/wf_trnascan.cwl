#!/usr/bin/env cwl-runner
label: "Run tRNAScan"
cwlVersion: v1.0
class: Workflow

#requirements:

inputs:
  asn_cache: Directory
  seqids: File
  taxid: int
  
outputs:
  annots:
    type: File
    outputSource: trnascan_dump/outasn
  
steps:
  gpx_qsubmit:
    run: gpx_qsubmit_trnascan.cwl
    in:
      asn_cache: asn_cache
      seqids: seqids
    #out: [asncache, jobs]
    out: [jobs]
  
  trnascan_wnode:
    run: trnascan_wnode.cwl
    in:
      #asn_cache: gpx_qsubmit/asncache
      asn_cache: asn_cache
      input_jobs: gpx_qsubmit/jobs
      #input_jobs: jobs
      taxid: taxid
    #out: [asncache, outdir]
    out: [outdir]

  gpx_qdump:
    run: gpx_qdump.cwl
    in:
      input_path: trnascan_wnode/outdir
    out: [intermediate]
    
  trnascan_dump:
    run: trnascan_dump.cwl
    in:
      input: gpx_qdump/intermediate
    out: [outasn, outstruct]
