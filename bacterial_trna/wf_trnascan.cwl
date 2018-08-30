#!/usr/bin/env cwl-runner
label: "Run tRNAScan"
cwlVersion: v1.0
class: Workflow

requirements:
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement

inputs:
  asn_cache: Directory
  seqids: File
  taxid: int
  taxon_db: File
  scatter_gather_nchunks: string

outputs:
  annots:
    type: File
    outputSource: Run_tRNAScan_trnascan_dump/outasn
  
steps:
  Run_tRNAScan_submit:
    run: gpx_qsubmit_trnascan.cwl
    in:
      asn_cache: asn_cache
      seqids: seqids
    #out: [asncache, jobs]
    out: [jobs]
  Compute_Gencode_for_trna:
    run: ../progs/compute_gencode.cwl
    in:
        taxid: taxid
        taxon_db: taxon_db
        gencode:
            default: true
    out: [ output ]
  Compute_Superkingdom_for_trna:
    run: ../progs/compute_gencode.cwl
    in:
        taxid: taxid
        taxon_db: taxon_db
        superkingdom:
            default: true
    out: [ output ]
  Compute_Gencode_int_for_trna:
    run: ../progs/file2int.cwl
    in:
        input: Compute_Gencode_for_trna/output
    out: [ value ]
  Compute_Superkingdom_int_for_trna:
    run: ../progs/file2int.cwl
    in:
        input: Compute_Superkingdom_for_trna/output
    out: [ value ]
  Get_TRNA_model: 
    run: ../progs/gencode2trnamodel.cwl
    in:
        gencode: Compute_Gencode_int_for_trna/value
    out: [output]
  split_jobs:
    run: ../split_jobs/split.cwl
    in:
      input: Run_tRNAScan_submit/jobs
      nchunks: scatter_gather_nchunks
#      chunk_size: scatter_gather_chunk_size
    out:  [ jobs ]
  Run_scan_and_dump:
    run: wf_scan_and_dump.cwl
    scatter: input_jobs
    in:
      asn_cache: asn_cache
      input_jobs: split_jobs/jobs
      #input_jobs: jobs
      taxid: taxid
      gcode_othmito: Get_TRNA_model/output
      taxon_db: taxon_db
      superkingdom: Compute_Superkingdom_int_for_trna/value
    out: [intermediate]
  collect_intermediate:
    run: ../split_jobs/cat_array_of_files.cwl
    in: 
      files_in: Run_scan_and_dump/intermediate
    out: [ file_out ]
  Run_tRNAScan_trnascan_dump:
    run: trnascan_dump.cwl
    in:
      input: collect_intermediate/file_out
    out: [outasn, outstruct]
