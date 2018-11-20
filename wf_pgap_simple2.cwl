class: Workflow
cwlVersion: v1.0
doc: |
  PGAP pipeline for external usage, powered via containers, 
  simple user input:  (FASTA + yaml only, no template)
label: 'PGAP Pipeline, simple user input, PGAPX-134'
requirements:
  - class: SubworkflowFeatureRequirement
inputs:
  16s_blastdb_dir:
    type: Directory
  23s_blastdb_dir:
    type: Directory
  5s_model_path:
    type: File
  AntiFamLib:
    type: Directory
  CDDdata:
    type: Directory
  CDDdata2:
    type: Directory
  asn2pas_xsl:
    type: File
  blast_rules_db:
    type: string
    default: blast_rules_db
  blast_rules_db_dir:
    type: Directory
  defline_cleanup_rules:
    type: File
  fasta:
    type: File
  gc_assm_name:
    type: string
  gene_master_ini:
    type: File
  genemark_path:
    type: Directory
  hmm_path:
    type: Directory
  hmms_tab:
    type: File
  naming_blast_db:
    type: Directory
  naming_hmms_combined:
    type: Directory
  naming_hmms_tab:
    type: File
  naming_sqlite:
    type: File
  rfam_amendments:
    type: File
  rfam_model_path:
    type: File
  rfam_stockholm:
    type: File
  selenoproteins:
    type: Directory
  submol:
    type: File
  taxid:
    type: int
  taxon_db:
    type: File
  thresholds:
    type: File
  uniColl_cache:
    type: Directory
  univ_prot_xml:
    type: File
  val_res_den_xml:
    type: File
  wp_hashes:
    type: File
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
    out: [output_fasta, submit_block_template, locus_tag_prefix]
    run: prepare_user_input2.cwl
    label: Prepare user input
  fastaval:
    run: progs/fastaval.cwl
    in: fasta
        check_min_seqlen:
            default: 200 
        check_internal_ns:
            default: true
    out: []
  standard_pgap:
    in:
      16s_blastdb_dir:
        source: 16s_blastdb_dir
      23s_blastdb_dir:
        source: 23s_blastdb_dir
      5s_model_path:
        source: 5s_model_path
      AntiFamLib:
        source: AntiFamLib
      CDDdata:
        source: CDDdata
      CDDdata2:
        source: CDDdata2
      asn2pas_xsl:
        source: asn2pas_xsl
      blast_rules_db:
        source: blast_rules_db
      blast_rules_db_dir:
        source: blast_rules_db_dir
      defline_cleanup_rules:
        source: defline_cleanup_rules
      fasta:
        source: prepare_input_template/output_fasta
      gc_assm_name:
        source: gc_assm_name
      gene_master_ini:
        source: gene_master_ini
      genemark_path:
        source: genemark_path
      hmm_path:
        source: hmm_path
      hmms_tab:
        source: hmms_tab
      locus_tag_prefix:
        source: prepare_input_template/locus_tag_prefix
      naming_blast_db:
        source: naming_blast_db
      naming_hmms_combined:
        source: naming_hmms_combined
      naming_hmms_tab:
        source: naming_hmms_tab
      naming_sqlite:
        source: naming_sqlite
      rfam_amendments:
        source: rfam_amendments
      rfam_model_path:
        source: rfam_model_path
      rfam_stockholm:
        source: rfam_stockholm
      selenoproteins:
        source: selenoproteins
      submit_block_template:
        source: prepare_input_template/submit_block_template
      taxid:
        source: taxid
      taxon_db:
        source: taxon_db
      thresholds:
        source: thresholds
      uniColl_cache:
        source: uniColl_cache
      univ_prot_xml:
        source: univ_prot_xml
      val_res_den_xml:
        source: val_res_den_xml
      wp_hashes:
        source: wp_hashes
    out: [gbent, gbk, gff, nucleotide_fasta, protein_fasta]
    run: wf_pgap.cwl
    label: PGAP Pipeline
