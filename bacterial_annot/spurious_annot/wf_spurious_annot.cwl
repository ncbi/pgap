#!/usr/bin/env cwl-runner
label: "Spurious Annotation Detection (two-pass)"
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
  hmmsearch_antifam_I:
    run: wf_hmmsearch.cwl
    in:
      hmm_path: hmm_path
      seqids: seqids
    out:
      [hmmhits]

