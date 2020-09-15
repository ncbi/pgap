#!/usr/bin/env cwl-runner
label: "Run genomic CMsearch"
cwlVersion: v1.0
class: Workflow

#requirements:
  
inputs:
  asn_cache: Directory
  seqids: File
  model_path: File
  rfam_amendments: File
  rfam_stockholm: File
  taxon_db: File

outputs:
  annots:
    type: File
    outputSource: Post_process_CMsearch_annotations_rRNA/annots 
    
steps:
  Run_genomic_CMsearch_rRNA_submit:
    run: gpx_qsubmit_gcmsearch.cwl
    in:
      asn_cache: asn_cache
      seqids: seqids
    out: [jobs]
  
  Run_genomic_CMsearch_rRNA_wnode:
    run: cmsearch_wnode.cwl
    in:
      asn_cache: asn_cache
      input_jobs: Run_genomic_CMsearch_rRNA_submit/jobs
      model_path: model_path
      rfam_amendments: rfam_amendments
      rfam_stockholm: rfam_stockholm
      taxon_db: taxon_db
    out: [outdir]

  Run_genomic_CMsearch_rRNA_dump:
    run: gpx_qdump.cwl
    in:
      input_path: Run_genomic_CMsearch_rRNA_wnode/outdir
    out: [annots]

  Post_process_CMsearch_annotations_rRNA:
    run: annot_merge.cwl
    in:
      asn_cache: asn_cache
      input: Run_genomic_CMsearch_rRNA_dump/annots
    out: [annots]
