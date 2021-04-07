#!/usr/bin/env cwl-runner
label: "Execute CRISPR"
cwlVersion: v1.2
class: Workflow

#requirements:
  
inputs:
  go: 
        type: boolean[]
  asn_cache: Directory
  seqids: File

outputs:
  annots:
     type: File
     outputSource: Execute_CRISPR_dump/annots 
    
steps:
  Execute_CRISPR_submit:
    run: gpx_qsubmit.cwl
    in:
      asn_cache: asn_cache
      seqids: seqids
    out: [jobs]
  
  Execute_CRISPR_wnode:
    run: ncbi_crisper_wnode.cwl
    in:
      asn_cache: asn_cache
      input_jobs: Execute_CRISPR_submit/jobs
    out: [outdir]

  Execute_CRISPR_dump:
    run: gpx_qdump.cwl
    in:
      input_path: Execute_CRISPR_wnode/outdir
    out: [annots]

