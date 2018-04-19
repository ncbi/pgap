#!/usr/bin/env cwl-runner
label: "Run genomic CMsearch (5S rRNA)"
cwlVersion: v1.0
class: Workflow

#requirements:
  
inputs:
  asn_cache: Directory
  seqids: File
  model_path: File
  rfam_amendments: File
  rfam_stockholm: File

outputs:
  # asncache:
  #   type: Directory
  #   outputSource: gpx_qsubmit/asncache
  annots:
    type: File
    outputSource: annot_merge/annots 
    
steps:
  gpx_qsubmit:
    run: gpx_qsubmit_gcmsearch.cwl
    in:
      asn_cache: asn_cache
      seqids: seqids
    out: [asncache, jobs]
  
  cmsearch_wnode:
    run: cmsearch_wnode.cwl
    in:
      asn_cache: gpx_qsubmit/asncache
      input_jobs: gpx_qsubmit/jobs
      model_path: model_path
      rfam_amendments: rfam_amendments
      rfam_stockholm: rfam_stockholm
    out: [ asncache, outdir ]

  gpx_qdump:
    run: gpx_qdump.cwl
    in:
      input_path: cmsearch_wnode/outdir
    out: [ annots ]

  annot_merge:
    run: annot_merge.cwl
    in:
      asn_cache: cmsearch_wnode/asncache
      input: gpx_qdump/annots
    out: [ annots ]
