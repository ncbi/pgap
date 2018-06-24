#!/usr/bin/env cwl-runner
label: "Run tRNAScan"
cwlVersion: v1.0
class: Workflow

#requirements:

inputs:
  asn_cache: Directory
  seqids: File
  taxid: int
  taxon_db: File
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
  Run_tRNAScan_wnode:
    run: trnascan_wnode.cwl
    in:
      #asn_cache: Run_tRNAScan_submit/asncache
      asn_cache: asn_cache
      input_jobs: Run_tRNAScan_submit/jobs
      #input_jobs: jobs
      taxid: taxid
      gcode_othmito: Get_TRNA_model/output
      taxon_db: taxon_db
      superkingdom: Compute_Superkingdom_int_for_trna/value
    #out: [asncache, outdir]
    out: [outdir]

  Run_tRNAScan_dump:
    run: gpx_qdump.cwl
    in:
      input_path: Run_tRNAScan_wnode/outdir
    out: [intermediate]
    
  Run_tRNAScan_trnascan_dump:
    run: trnascan_dump.cwl
    in:
      input: Run_tRNAScan_dump/intermediate
    out: [outasn, outstruct]
