#!/usr/bin/env cwl-runner
label: "Search HMMs"
cwlVersion: v1.0
class: Workflow

#requirements:
    
inputs:
  hmm_path: Directory
  proteins: File
  seqids: File
  lds2: File
  hmms_tab: File
  asn_cache: Directory
  
outputs:
  hmm_hits: 
    type: File
    outputSource: gpx_qdump/hmm_hits
  # strace:
  #   type: File
  #   outputSource: hmmsearch_wnode/strace
    
steps:
  hmmsearch_create_jobs:
    run: hmmsearch_create_jobs.cwl
    in:
      hmm_path: hmm_path
      seqids: seqids
    out:
      [jobs, workdir]

  hmmsearch_wnode:
    run: hmmsearch_wnode.cwl
    in:
      hmm_path: hmm_path
      workdir: hmmsearch_create_jobs/workdir
      proteins: proteins
      lds2: lds2
      asn_cache: asn_cache
      hmms_tab: hmms_tab
      input_jobs: hmmsearch_create_jobs/jobs
    #out: [output, strace]
    out: [output]

  gpx_qdump:
    run: gpx_qdump.cwl
    in:
      input_path: hmmsearch_wnode/output
    out: [hmm_hits]
