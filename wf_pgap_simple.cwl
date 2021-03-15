#!/usr/bin/env cwl-runner

label: "PGAP Pipeline, simple user input"
cwlVersion: v1.0
class: Workflow
doc: |
    PGAP pipeline for external usage, powered via containers, 
    simple user input:  (FASTA + yaml only, no template)

requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
  
inputs:
  #
  # User specified input for "standard" (wf_pgap.cwl) workflow
  #
  fasta: File
  submit_block_template: File
  taxid: int
  gc_assm_name: string
  report_usage: boolean
    
  #
  # User specified input for "simple user input" case (this)
  #
  tech: string?
  completeness: string? 
  
  #
  # User independent, static input for "standard" (wf_pgap.cwl) workflow
  # 
  blast_rules_db: 
    type: string
    default: blast_rules_db
  supplemental_data:
    type: Directory
    default:
      class: Directory
      location: input

  #
  # User independent, static input for "simple user input" case (this)
  # 
  submit_block_template_static: File
  molinfo_complete_asn: File
  molinfo_wgs_asn: File
  make_uuid:
    type: boolean?
    default: true
  uuid_in:
    type: File?
steps:
  prepare_input_template:
    run: prepare_user_input.cwl
    in: 
        tech: tech
        completeness: completeness
        submit_block_template_static: submit_block_template_static
        molinfo_complete_asn: molinfo_complete_asn
        molinfo_wgs_asn: molinfo_wgs_asn
    out: [submit_block_template]
  standard_pgap:
    run: wf_common.cwl
    in:
        taxid: taxid
        gc_assm_name: gc_assm_name
        report_usage: report_usage
        supplemental_data: supplemental_data
        blast_rules_db: blast_rules_db
        make_uuid: make_uuid
        uuid_in: uuid_in        
    out: [gbent, gff, gbk, nucleotide_fasta, protein_fasta]
outputs:
  gbent:
    type: File
    outputSource: standard_pgap/gbent
  gff:
    type: File
    outputSource:  standard_pgap/gff
  gbk:
    type: File
    outputSource:  standard_pgap/gbk
  nucleotide_fasta:
    type: File?
    outputSource: standard_pgap/nucleotide_fasta
  protein_fasta:
    type: File?
    outputSource: standard_pgap/protein_fasta
    
