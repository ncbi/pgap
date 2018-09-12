#!/usr/bin/env cwl-runner

label: "PGAP Pipeline, simple user input"
cwlVersion: v1.0
class: Workflow
doc: |
    PGAP pipeline for external usage, powered via Docker containers, 
    simple user input:  (FASTA + yaml only, no template)

requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: DockerRequirement
    dockerPull: ncbi/gpdev:latest
  
inputs:
  #
  # User specified input for "standard" (wf_pgap.cwl) workflow
  #
  fasta: File
  submit_block_template: File
  taxid: int
  gc_assm_name: string
  #
  # User specified input for "simple user input" case (this)
  #
  tech: string?
  completeness: string? 
  
  #
  # User independent, static input for "standard" (wf_pgap.cwl) workflow
  # 
  hmm_path: Directory
  hmms_tab: File
  naming_hmms_tab: File
  uniColl_cache: Directory
  gene_master_ini: File
  16s_blastdb_dir: Directory
  23s_blastdb_dir: Directory
  5s_model_path: File
  rfam_model_path: File
  rfam_amendments: File
  rfam_stockholm: File
  AntiFamLib: Directory
  blast_rules_db_dir: Directory
  blast_rules_db: 
    type: string
    default: blast_rules_db
  thresholds: File
  naming_sqlite: File 
  selenoproteins: Directory
  naming_hmms_combined: Directory
  wp_hashes: File
  taxon_db: File   
  genemark_path: Directory
  naming_blast_db: Directory
  CDDdata: Directory
  CDDdata2: Directory
  defline_cleanup_rules: File
  univ_prot_xml: File
  val_res_den_xml: File
  asn2pas_xsl: File
  #
  # User independent, static input for "simple user input" case (this)
  # 
  submit_block_template_static: File
  molinfo_complete_asn: File
  molinfo_wgs_asn: File
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
    run: wf_pgap.cwl
    in:
        fasta: fasta
        submit_block_template: prepare_input_template/submit_block_template
        taxid: taxid
        gc_assm_name: gc_assm_name
        hmm_path: hmm_path
        hmms_tab: hmms_tab
        naming_hmms_tab: naming_hmms_tab
        uniColl_cache: uniColl_cache
        gene_master_ini: gene_master_ini
        16s_blastdb_dir: 16s_blastdb_dir
        23s_blastdb_dir: 23s_blastdb_dir
        5s_model_path: 5s_model_path
        rfam_model_path: rfam_model_path
        rfam_amendments: rfam_amendments
        rfam_stockholm: rfam_stockholm
        AntiFamLib: AntiFamLib
        blast_rules_db_dir: blast_rules_db_dir
        blast_rules_db: blast_rules_db
        thresholds: thresholds
        naming_sqlite: naming_sqlite
        selenoproteins: selenoproteins
        naming_hmms_combined: naming_hmms_combined
        wp_hashes: wp_hashes
        taxon_db: taxon_db
        genemark_path: genemark_path
        naming_blast_db: naming_blast_db
        CDDdata: CDDdata
        CDDdata2: CDDdata2
        defline_cleanup_rules: defline_cleanup_rules
        univ_prot_xml: univ_prot_xml
        val_res_den_xml: val_res_den_xml
        asn2pas_xsl: asn2pas_xsl
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
    
