#!/usr/bin/env cwl-runner

class: Workflow
cwlVersion: v1.2
doc: |
  PGAP pipeline for external usage, powered via containers,
  simple user input:  (FASTA + yaml only, no template)
label: 'PGAP Pipeline, simple user input, PGAPX-134'
requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: LoadListingRequirement
    loadListing: deep_listing
  - class: NetworkAccess
    networkAccess: true
    
inputs:
  supplemental_data:
    type: Directory
    default:
      class: Directory
      location: input
  blast_hits_cache_data:
    type: Directory?
  fasta: File
  report_usage: boolean
  submol: File
  ignore_all_errors:
        type: boolean?
  no_internet:
    type: boolean?
  make_uuid:
    type: boolean?
    default: true
  uuid_in:
    type: File?
outputs:
  calls:
    outputSource: vecscreen/calls
    type: File
  gbk:
    outputSource: standard_pgap/gbk
    type: File
  gff:
    outputSource: standard_pgap/gff
    type: File
  gff_enhanced:
    outputSource: Generate_Annotation_Reports_gff_enhanced/output
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
  cds_nucleotide_fasta:
    outputSource: standard_pgap/cds_nucleotide_fasta
    type: File?
  cds_protein_fasta:
    outputSource:  standard_pgap/cds_protein_fasta
    type: File?
  initial_asndisc_error_diag:
    type: File?
    outputSource: standard_pgap/initial_asndisc_error_diag 
  initial_asnval_error_diag:
    type: File?
    outputSource: standard_pgap/initial_asnval_error_diag 
  final_asndisc_error_diag:
    type: File?
    outputSource: standard_pgap/final_asndisc_error_diag
  final_asnval_error_diag:
    type: File?
    outputSource: standard_pgap/final_asnval_error_diag  
  checkm_raw: 
    type: File
    outputSource: standard_pgap/checkm_raw
  fastaval_errors:
    type: File
    outputSource: fastaval/out
    
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
            if (l[i].basename == 'contam_in_prok_blastdb_dir') {
              r['contam_in_prok_blastdb_dir'] = l[i];
            }
            if (l[i].basename == 'adaptor_fasta.fna') {
              r['adaptor_fasta'] = l[i];
            }
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
        adaptor_fasta:
                type: File
        contam_in_prok_blastdb_dir:
                type: Directory
    out: 
        - taxon_db
        - adaptor_fasta 
        - contam_in_prok_blastdb_dir

  prepare_input_template:
    run: prepare_user_input2.cwl
    label: Prepare user input
    in:
      fasta: fasta
      submol: submol
      taxon_db: passdata/taxon_db
      ignore_all_errors: ignore_all_errors
      no_internet: no_internet
    out: [output_seq_submit, output_entries, locus_tag_prefix, submol_block_json, taxid]
  fastaval:
    run: progs/fastaval.cwl
    in:
        in: fasta
        check_min_seqlen:
            default: 200
        check_internal_ns:
            default: true
        ignore_all_errors: ignore_all_errors
    out: [success, out]
  vecscreen:
        run: vecscreen/vecscreen.cwl
        in:
            contig_fasta:   fasta
            adaptor_fasta:  passdata/adaptor_fasta
            contam_in_prok_blastdb_dir: passdata/contam_in_prok_blastdb_dir
            ignore_all_errors: ignore_all_errors
        out: [success, calls]
  standard_pgap:
    label: PGAP Pipeline
    in:
      go:
        - fastaval/success
        - vecscreen/success
      entries: prepare_input_template/output_entries
      seq_submit: prepare_input_template/output_seq_submit
      supplemental_data: supplemental_data
      gc_assm_name: 
        source: "#fasta"
        valueFrom: $(inputs.gc_assm_name.basename)
      locus_tag_prefix: prepare_input_template/locus_tag_prefix
      report_usage: report_usage
      taxid: prepare_input_template/taxid
      submol_block_json: prepare_input_template/submol_block_json
      ignore_all_errors: ignore_all_errors
      no_internet: no_internet
      make_uuid: make_uuid
      uuid_in: uuid_in
      blast_hits_cache_data: blast_hits_cache_data
    out: [gbent, gbk, gff, nucleotide_fasta, protein_fasta, cds_nucleotide_fasta, cds_protein_fasta, sqn, initial_asndisc_error_diag, initial_asnval_error_diag, final_asndisc_error_diag, final_asnval_error_diag, checkm_raw, checkm_results]
    run: wf_common.cwl
  Generate_Annotation_Reports_gff_enhanced:
    run: progs/produce_enhanced_gff.cwl
    in:
        gff: standard_pgap/gff
        fasta: fasta
    out: [output]
  
