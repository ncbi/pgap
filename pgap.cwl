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
  gc_assm_name: 
    type: string
    default: my_gc_assm_name
  report_usage: boolean
  submol: File
  ignore_all_errors:
        type: boolean?
  
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
  sqn:
    outputSource: standard_pgap/sqn
    type: File
  input_fasta:
    outputSource: fasta
    type: File
  input_submol:
    outputSource: submol
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
      class: ExpressionTool
      requirements:
        InlineJavascriptRequirement: {}
      inputs:
        data:
          type: Directory
      expression: |
        ${
          var r = {};
          var l = inputs.data.listing;
          var n = l.length;
          for (var i = 0; i < n; i++) {
            if (l[i].basename == 'uniColl_path') {
              var ul = l[i].listing;
              var un = ul.length;
              for (var j = 0; j < un; j++) {
                if (ul[j].basename == 'taxonomy.sqlite3') {
                  r['taxon_db'] = ul[j];
                }
              }
            }
          }
          return r;
        }
      outputs:
        taxon_db:
          type: File
    out: [ taxon_db ]

  prepare_input_template:
    run: prepare_user_input2.cwl
    label: Prepare user input
    in:
      fasta: fasta
      submol: submol
      taxon_db: passdata/taxon_db
      ignore_all_errors: ignore_all_errors
    out: [output_seq_submit, output_entries, locus_tag_prefix, submol_block_json, taxid]
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
    label: PGAP Pipeline
    in:
      entries: prepare_input_template/output_entries
      seq_submit: prepare_input_template/output_seq_submit
      supplemental_data: supplemental_data
      gc_assm_name: gc_assm_name
      locus_tag_prefix: prepare_input_template/locus_tag_prefix
      report_usage: report_usage
      taxid: prepare_input_template/taxid
      submol_block_json: prepare_input_template/submol_block_json
      ignore_all_errors: ignore_all_errors
    out: [gbent, gbk, gff, nucleotide_fasta, protein_fasta, sqn]
    run: wf_common.cwl
