#!/usr/bin/env cwl-runner
label: "Execute CRISPR"
cwlVersion: v1.0
class: Workflow

#requirements:
  
inputs:
  asn_cache: Directory
  seqids: File

outputs:
  outdir:
    type: Directory
    outputSource: ncbi_crisper_wnode/outdir
  # annots:
  #   type: File
  #   outputSource: gpx_qdump/annots 
    
steps:
  gpx_qsubmit:
    run: gpx_qsubmit.cwl
    in:
      asn_cache: asn_cache
      seqids: seqids
    out: [jobs]
  
  ncbi_crisper_wnode:
    run: ncbi_crisper_wnode.cwl
    in:
      asn_cache: asn_cache
      input_jobs: gpx_qsubmit/jobs
    out: [outdir]

  gpx_qdump:
    run: gpx_qdump.cwl
    in:
      input_path: ncbi_crisper_wnode/outdir
    out: [annots]

