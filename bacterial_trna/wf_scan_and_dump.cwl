#!/usr/bin/env cwl-runner

cwlVersion: v1.2

class: Workflow

# make a workflow with jobs.xml as an input and a single file as an output to apply scatter/gather

label: "trnascan_wnode and gpx_qdump combined"

inputs:
  asn_cache: Directory
  input_jobs: File
  taxid: int
  gcode_othmito: string?
  taxon_db: File
  superkingdom: int

outputs:
  intermediate:
    type: File
    outputSource: Run_tRNAScan_dump/intermediate
  
steps:
  Run_tRNAScan_wnode:
    run: trnascan_wnode.cwl
    in:
      asn_cache: asn_cache
      input_jobs: input_jobs
      taxid: taxid
      gcode_othmito: gcode_othmito
      taxon_db: taxon_db
      superkingdom: superkingdom
    out: [outdir]

  Run_tRNAScan_dump:
    run: gpx_qdump.cwl
    in:
      input_path: Run_tRNAScan_wnode/outdir
    out: [intermediate]
