#!/usr/bin/env cwl-runner
cwlVersion: v1.2
label: "checkm_wnode"
class: Workflow

inputs:
  assm_to_prots: File
  lds2: File
  proteins: File
  checkm_data_path: Directory
  filter_for_raw_checkm: File
outputs: 
  checkm_raw:
    type: File
    outputSource: xmlformat/out
  checkm_results:
    type: File
    outputSource: gpx_qdump/output
steps:
  gpx_qsubmit:
    run: ../progs/gpx_qsubmit_proteins_xml.cwl
    in:
      xml_jobs: assm_to_prots
    out: [jobs]
  checkm_wnode:
    run: ../progs/checkm_wnode.cwl
    in:
      input_jobs: gpx_qsubmit/jobs
      checkm_data_path: checkm_data_path
      lds2: lds2
      proteins: proteins
    out: [outdir]    
  gpx_qdump:
    run: ../progs/gpx_qdump.cwl
    in:
      input_path: checkm_wnode/outdir
      unzip:
        default: '*'
    out: [output]
  xmlformat:
    run: ../progs/xmlformat.cwl
    in:
      input: gpx_qdump/output
      axml: filter_for_raw_checkm
      text_only:
        default: true
    out: [out]
  
