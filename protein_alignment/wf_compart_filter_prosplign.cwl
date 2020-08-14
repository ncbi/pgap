#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

label: "Filter Protein Seeds; Find ProSplign Alignments"

inputs:
  asn_cache: Directory
  uniColl_asn_cache: Directory
  seed_hits: File
  gc_assembly: File
  
outputs: 
  prosplign_align:
    type: File
    outputSource: Find_ProSplign_Alignments_gpx_qdump/prosplign_align

steps:
  Filter_Protein_Seeds_prosplign_compart:
    run: prosplign_compart.cwl
    in:
      asn_cache: asn_cache
      uniColl_asn_cache: uniColl_asn_cache
      seed_hits: seed_hits
    out: [unfilt_comp]
  
  Filter_Protein_Seeds_prosplign_compart_filter:
    run: prosplign_compart_filter.cwl
    in:
      asn_cache: asn_cache
      uniColl_asn_cache: uniColl_asn_cache
      unfilt_comp: Filter_Protein_Seeds_prosplign_compart/unfilt_comp
      gc_assembly: gc_assembly
      sufficient_compart_length:
        default: 1500
      
    out: [compartments]
  
  Find_ProSplign_Alignments_gpx_qsubmit:
    run: gpx_qsubmit_pro.cwl
    in:
      asn_cache: asn_cache
      uniColl_asn_cache: uniColl_asn_cache
      asn: Filter_Protein_Seeds_prosplign_compart_filter/compartments
    out: [jobs]
  
  Find_ProSplign_Alignments_prosplign_wnode:
    run: prosplign_wnode.cwl
    in:
      asn_cache: asn_cache
      uniColl_asn_cache: uniColl_asn_cache
      input_jobs: Find_ProSplign_Alignments_gpx_qsubmit/jobs
      asn: Filter_Protein_Seeds_prosplign_compart_filter/compartments
    out: [outdir]

  Find_ProSplign_Alignments_gpx_qdump:
    run: gpx_qdump_pro.cwl
    in:
      input_path: Find_ProSplign_Alignments_prosplign_wnode/outdir
    out: [prosplign_align]
