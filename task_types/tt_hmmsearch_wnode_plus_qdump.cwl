#!/usr/bin/env cwl-runner
cwlVersion: v1.2

class: Workflow

label: "hmmsearch_wnode and gpx_qdump combined workflow to apply scatter/gather"

inputs:
  hmm_path: Directory
  workdir: Directory
  proteins: File
  lds2: File
  hmms_tab: File?
  asn_cache: Directory
  input_jobs: File

outputs:
  output: 
    type: File
    outputSource: gpx_qdump/output

steps:
  hmmsearch_wnode:
    run: ../progs/hmmsearch_wnode.cwl
    in:
      hmm_path: hmm_path
      workdir: workdir
      proteins: proteins
      lds2: lds2
      asn_cache: asn_cache
      hmms_tab: hmms_tab
      input_jobs: input_jobs
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
