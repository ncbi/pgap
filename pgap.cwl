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
  supplemental_data: Directory
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
    in:
      fasta: fasta
      submol: submol
      taxon_db: passdata/taxon_db
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
      supplemental_data: supplemental_data
      gc_assm_name: gc_assm_name
      locus_tag_prefix: prepare_input_template/locus_tag_prefix
      submit_block_template: prepare_input_template/submit_block_template
      fasta: prepare_input_template/output_fasta
      report_usage: report_usage
      taxid: taxid
      #16s_blastdb_dir: 16s_blastdb_dir
      #23s_blastdb_dir: 23s_blastdb_dir
      #5s_model_path: 5s_model_path
      #AntiFamLib: AntiFamLib
      #CDDdata: CDDdata
      #CDDdata2: CDDdata2
      #asn2pas_xsl: asn2pas_xsl
      #blast_rules_db: blast_rules_db
      #blast_rules_db_dir: blast_rules_db_dir
      #defline_cleanup_rules: defline_cleanup_rules
      #gene_master_ini: gene_master_ini
      #genemark_path: genemark_path
      #hmm_path: hmm_path
      #hmms_tab: hmms_tab
      #naming_blast_db: naming_blast_db
      #naming_hmms_combined: naming_hmms_combined
      #naming_hmms_tab: naming_hmms_tab
      #naming_sqlite: naming_sqlite
      #rfam_amendments: rfam_amendments
      #rfam_model_path: rfam_model_path
      #rfam_stockholm: rfam_stockholm
      #selenoproteins: selenoproteins
      #taxon_db: taxon_db
      #thresholds: thresholds
      #uniColl_cache: uniColl_cache
      #univ_prot_xml: univ_prot_xml
      #val_res_den_xml: val_res_den_xml
      #wp_hashes: wp_hashes
    out: [gbent, gbk, gff, nucleotide_fasta, protein_fasta]
    run: wf_common.cwl
    label: PGAP Pipeline
