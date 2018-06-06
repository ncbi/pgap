#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

label: "Filter Protein Seeds I; Find ProSplign Alignments I"

inputs:
  asn_cache: Directory
  uniColl_asn_cache: Directory
  seed_hits: File
  gc_assembly: File
  
outputs: 
  prosplign_align:
    type: File
    outputSource: gpx_qdump_pro/prosplign_align

steps:
  prosplign_compart:
    run: prosplign_compart.cwl
    in:
      asn_cache: asn_cache
      uniColl_asn_cache: uniColl_asn_cache
      seed_hits: seed_hits
    out: [unfilt_comp]
  
  prosplign_compart_filter:
    run: prosplign_compart_filter.cwl
    in:
      asn_cache: asn_cache
      uniColl_asn_cache: uniColl_asn_cache
      unfilt_comp: prosplign_compart/unfilt_comp
      gc_assembly: gc_assembly
    out: [compartments]
  
  gpx_qsubmit_pro:
    run: gpx_qsubmit_pro.cwl
    in:
      asn_cache: asn_cache
      uniColl_asn_cache: uniColl_asn_cache
      asn: prosplign_compart_filter/compartments
    out: [jobs]
  
  prosplign_wnode:
    run: prosplign_wnode.cwl
    in:
      asn_cache: asn_cache
      uniColl_asn_cache: uniColl_asn_cache
      input_jobs: gpx_qsubmit_pro/jobs
      asn: prosplign_compart_filter/compartments
    out: [outdir]

  gpx_qdump_pro:
    run: gpx_qdump_pro.cwl
    in:
      input_path: prosplign_wnode/outdir
    out: [prosplign_align]
