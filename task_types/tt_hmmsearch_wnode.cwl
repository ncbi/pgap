#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow

    
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
    outputSource: gpx_qdump/output
    
steps:
  hmmsearch_create_jobs:
    run: ../progs/hmmsearch_create_jobs.cwl
    in:
      hmm_path: hmm_path
      seqids: seqids
    out:
      [jobs, workdir]

  hmmsearch_wnode:
    run: ../progs/hmmsearch_wnode.cwl
    in:
      hmm_path: hmm_path
      workdir: hmmsearch_create_jobs/workdir
      proteins: proteins
      lds2: lds2
      asn_cache: asn_cache
      hmms_tab: hmms_tab
      input_jobs: hmmsearch_create_jobs/jobs
    out: [output]

  gpx_qdump:
    run: ../progs/gpx_qdump.cwl
    in:
      input_path: hmmsearch_wnode/output
      output_name:
        default: hmm_hits.asn
      unzip:
        default: '*'
    out: [output]
