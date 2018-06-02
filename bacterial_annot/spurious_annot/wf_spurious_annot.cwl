#!/usr/bin/env cwl-runner
label: "Spurious Annotation Detection (two-pass)"
cwlVersion: v1.0
class: Workflow

#requirements:
    
inputs:
  proteins: File
  hmm_path: Directory
  seqids: File
  lds2: File
  hmms_tab: File
  asn_cache: Directory
  
outputs:
  hmm_hits: 
    type: File
    outputSource: gpx_qdump/hmm_hits
    
steps:
  hmmsearch_antifam_I:
    run: ../task_types/tt_hmmsearch_wnode.cwl
    in:
      proteins: proteins
      hmm_path: hmm_path
      seqids: seqids
      lds2: lds2
      hmms_tab: hmms_tab
      asn_cache: asn_cache
    out:
      [hmmhits]

