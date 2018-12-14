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
  16s_blastdb_dir: Directory
  23s_blastdb_dir: Directory
  5s_model_path: File
  AntiFamLib: Directory
  CDDdata: Directory
  CDDdata2: Directory
  asn2pas_xsl: File
  blast_rules_db:
    type: string
    default: blast_rules_db
  blast_rules_db_dir: Directory
  defline_cleanup_rules: File
  fasta: File
  gc_assm_name: string
  gene_master_ini: File
  genemark_path: Directory
  hmm_path: Directory
  hmms_tab: File
  naming_blast_db: Directory
  naming_hmms_combined: Directory
  naming_hmms_tab: File
  naming_sqlite: File
  report_usage: boolean
  rfam_amendments: File
  rfam_model_path: File
  rfam_stockholm: File
  selenoproteins: Directory
  submol: File
  taxid: int
  taxon_db: File
  thresholds: File
  uniColl_cache: Directory
  univ_prot_xml: File
  val_res_den_xml: File
  wp_hashes: File
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
  prepare_input_template:
    in:
      fasta: fasta
      submol: submol
      taxon_db: taxon_db
    out: [output_fasta, submit_block_template, locus_tag_prefix]
    run: prepare_user_input2.cwl
    label: Prepare user input
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
      16s_blastdb_dir: 16s_blastdb_dir
      23s_blastdb_dir: 23s_blastdb_dir
      5s_model_path: 5s_model_path
      AntiFamLib: AntiFamLib
      CDDdata: CDDdata
      CDDdata2: CDDdata2
      asn2pas_xsl: asn2pas_xsl
      blast_rules_db: blast_rules_db
      blast_rules_db_dir: blast_rules_db_dir
      defline_cleanup_rules: defline_cleanup_rules
      fasta: prepare_input_template/output_fasta
      gc_assm_name: gc_assm_name
      gene_master_ini: gene_master_ini
      genemark_path: genemark_path
      hmm_path: hmm_path
      hmms_tab: hmms_tab
      locus_tag_prefix: prepare_input_template/locus_tag_prefix
      naming_blast_db: naming_blast_db
      naming_hmms_combined: naming_hmms_combined
      naming_hmms_tab: naming_hmms_tab
      naming_sqlite: naming_sqlite
      report_usage: report_usage
      rfam_amendments: rfam_amendments
      rfam_model_path: rfam_model_path
      rfam_stockholm: rfam_stockholm
      selenoproteins: selenoproteins
      submit_block_template: prepare_input_template/submit_block_template
      taxid: taxid
      taxon_db: taxon_db
      thresholds: thresholds
      uniColl_cache: uniColl_cache
      univ_prot_xml: univ_prot_xml
      val_res_den_xml: val_res_den_xml
      wp_hashes: wp_hashes
    out: [gbent, gbk, gff, nucleotide_fasta, protein_fasta]
    run: wf_common.cwl
    label: PGAP Pipeline
