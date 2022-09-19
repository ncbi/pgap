#!/usr/bin/env cwl-runner
cwlVersion: v1.2
label: "checkm"
class: Workflow
requirements:
    # this is propagated from the top, but in order to validate the CheckM workflow
    # independently, we must have this, since this is the top workflow for CheckM:
    - class: SubworkflowFeatureRequirement

inputs:
  models: File
    # final.asn from Final Bacterial Package
  checkm_data_path: Directory
  filter_for_raw_checkm: File
  taxid: int
  taxon_db: File
outputs:
  checkm_raw: 
    type: File
    outputSource: run_checkm/checkm_raw
  checkm_results: 
    type: File
    outputSource: run_checkm/checkm_results
steps:
  extract_final_proteins:
    label: 'Extract final proteins'
    run: ../progs/protein_extract.cwl
    in: 
      input: models
      nogenbank:
        default: true
      it: 
        default: true
      oproteins:
        default: proteins-for-checkm.asn
      olds2:
        default: checkm.LDS2
    out: [lds2, seqids, proteins]
  convert_seqids_to_jobs:
    label: 'Convert final protein seqid list to XML jobs'
    run: ../progs/proteins_for_checkm.cwl
    in:
      seqids: extract_final_proteins/seqids
      taxid: taxid
    out: [jobs, output_seqids]
  run_checkm:
    label: 'Run CheckM'
    run: ../task_types/tt_checkm_wnode.cwl
    in:
      assm_to_prots: convert_seqids_to_jobs/jobs
      lds2: extract_final_proteins/lds2
      proteins: extract_final_proteins/proteins
      checkm_data_path: checkm_data_path
      filter_for_raw_checkm: filter_for_raw_checkm
      taxon_db: taxon_db
      seqids: convert_seqids_to_jobs/output_seqids
    out: [checkm_raw, checkm_results]

