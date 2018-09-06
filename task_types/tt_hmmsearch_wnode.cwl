#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow

requirements:
  - class: ScatterFeatureRequirement
  - class: SubworkflowFeatureRequirement
    
inputs:
  hmm_path: Directory
  proteins: File
  seqids: File
  lds2: File
  hmms_tab: File?
  asn_cache: Directory
  scatter_gather_nchunks: string
  
outputs:
  hmm_hits: 
    type: File
    outputSource: collect_hmm_results/file_out
  jobs: 
    type: File
    outputSource: hmmsearch_create_jobs/jobs
  workdir:
    type: Directory
    outputSource: hmmsearch_create_jobs/workdir

steps:
  hmmsearch_create_jobs:
    run: ../progs/hmmsearch_create_jobs.cwl
    in:
      hmm_path: hmm_path
      seqids: seqids
    out:
      [jobs, workdir]

  split_jobs:
    run: ../split_jobs/split.cwl
    in:
      input: hmmsearch_create_jobs/jobs
      nchunks: scatter_gather_nchunks
    out:  [ jobs ]

  hmmsearch_wnode_qdump:
    run: tt_hmmsearch_wnode_plus_qdump.cwl
    scatter: input_jobs
    in:
      hmm_path: hmm_path
      workdir: hmmsearch_create_jobs/workdir
      proteins: proteins
      lds2: lds2
      asn_cache: asn_cache
      hmms_tab: hmms_tab
      input_jobs: split_jobs/jobs
    out: [output]
      
  collect_hmm_results:
    run: ../split_jobs/cat_array_of_files.cwl
    in: 
      files_in: hmmsearch_wnode_qdump/output
    out: [ file_out ]
