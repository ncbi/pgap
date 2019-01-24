#!/usr/bin/env cwl-runner

class: Workflow
cwlVersion: v1.0
doc: |
  PGAP pipeline for external usage, powered via containers,
  simple user input:  (FASTA + yaml only, no template)
label: 'PGAP Pipeline, simple user input, PGAPX-134'
requirements:
  - class: SubworkflowFeatureRequirement
inputs:
  supplemental_data:
    type: Directory
    default:
      class: Directory
      location: input
  blast_rules_db:
    type: string
    default: blast_rules_db
  fasta: File
  gc_assm_name: string
  report_usage: boolean
  submol: File
  taxid: int
  
outputs:
  gbent:
    outputSource: standard_pgap/gbent
    type: File
  gbk:
    outputSource: standard_pgap/gbk
    type: File
  gff:
    outputSource: standard_pgap/gff
    type: File
  nucleotide_fasta:
    outputSource: standard_pgap/nucleotide_fasta
    type: File?
  protein_fasta:
    outputSource:  standard_pgap/protein_fasta
    type: File?
steps:
  passdata:
    in:
      data: supplemental_data
    run:
      class: CommandLineTool
      baseCommand: "true"
      requirements:
        InitialWorkDirRequirement:
          listing:
            - entry: $(inputs.data)
              writable: False
      inputs:
        data:
          type: Directory
      outputs:
        taxon_db:
          type: File
          outputBinding:
            glob: $(inputs.data.basename)/uniColl_path/taxonomy.sqlite3
    out: [ taxon_db ]

  prepare_input_template:
    run: prepare_user_input2.cwl
    label: Prepare user input
    in:
      fasta: fasta
      submol: submol
      taxon_db: passdata/taxon_db
    out: [output_seq_submit, output_entries, locus_tag_prefix]
  fastaval:
    run: progs/fastaval.cwl
    in:
        in: fasta
        check_min_seqlen:
            default: 200
        check_internal_ns:
            default: true
    out: []
  standard_pgap:
    in:
      entries: prepare_input_template/output_entries
      seq_submit: prepare_input_template/output_seq_submit
      supplemental_data: supplemental_data
      gc_assm_name: gc_assm_name
      locus_tag_prefix: prepare_input_template/locus_tag_prefix
      report_usage: report_usage
      taxid: taxid
    out: [gbent, gbk, gff, nucleotide_fasta, protein_fasta, sqn]
    run: wf_common.cwl
    label: PGAP Pipeline
