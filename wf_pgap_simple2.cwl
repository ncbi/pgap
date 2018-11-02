class: Workflow
cwlVersion: v1.0
doc: |
  PGAP pipeline for external usage, powered via containers, 
  simple user input:  (FASTA + yaml only, no template)
label: 'PGAP Pipeline, simple user input, PGAPX-134'
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: 16s_blastdb_dir
    type: Directory
    'sbg:x': 184.984375
    'sbg:y': 2617.453125
  - id: 23s_blastdb_dir
    type: Directory
    'sbg:x': 184.984375
    'sbg:y': 2510.78125
  - id: 5s_model_path
    type: File
    'sbg:x': 184.984375
    'sbg:y': 2396.609375
  - id: AntiFamLib
    type: Directory
    'sbg:x': 184.984375
    'sbg:y': 2282.4375
  - id: CDDdata
    type: Directory
    'sbg:x': 184.984375
    'sbg:y': 1840.75
  - id: CDDdata2
    type: Directory
    'sbg:x': 184.984375
    'sbg:y': 1734.078125
  - id: asn2pas_xsl
    type: File
    'sbg:x': 184.984375
    'sbg:y': 2168.265625
  - id: blast_rules_db
    type: string
    default: blast_rules_db
    'sbg:x': 184.984375
    'sbg:y': 2054.09375
  - id: blast_rules_db_dir
    type: Directory
    'sbg:x': 184.984375
    'sbg:y': 1947.421875
  - id: defline_cleanup_rules
    type: File
    'sbg:x': 184.984375
    'sbg:y': 1619.90625
  - id: fasta
    type: File
    'sbg:x': 0
    'sbg:y': 1772.9140625
  - id: gc_assm_name
    type: string
    'sbg:x': 184.984375
    'sbg:y': 1505.734375
  - id: gene_master_ini
    type: File
    'sbg:x': 184.984375
    'sbg:y': 1391.5625
  - id: genemark_path
    type: Directory
    'sbg:x': 184.984375
    'sbg:y': 1277.390625
  - id: hmm_path
    type: Directory
    'sbg:x': 184.984375
    'sbg:y': 1170.71875
  - id: hmms_tab
    type: File
    'sbg:x': 184.984375
    'sbg:y': 1056.546875
  - id: naming_blast_db
    type: Directory
    'sbg:x': 184.984375
    'sbg:y': 942.375
  - id: naming_hmms_combined
    type: Directory
    'sbg:x': 184.984375
    'sbg:y': 835.703125
  - id: naming_hmms_tab
    type: File
    'sbg:x': 184.984375
    'sbg:y': 721.53125
  - id: naming_sqlite
    type: File
    'sbg:x': 184.984375
    'sbg:y': 599.859375
  - id: rfam_amendments
    type: File
    'sbg:x': 184.984375
    'sbg:y': 357.515625
  - id: rfam_model_path
    type: File
    'sbg:x': 184.984375
    'sbg:y': 235.84375
  - id: rfam_stockholm
    type: File
    'sbg:x': 184.984375
    'sbg:y': 114.171875
  - id: selenoproteins
    type: Directory
    'sbg:x': 184.984375
    'sbg:y': 0
  - id: submol
    type: File
    'sbg:x': 0
    'sbg:y': 1651.2421875
  - id: taxid
    type: int
    'sbg:x': 0
    'sbg:y': 1537.0703125
  - id: taxon_db
    type: File
    'sbg:x': 0
    'sbg:y': 1422.8984375
  - id: thresholds
    type: File
    'sbg:x': 0
    'sbg:y': 1301.2265625
  - id: uniColl_cache
    type: Directory
    'sbg:x': 0
    'sbg:y': 1187.0546875
  - id: univ_prot_xml
    type: File
    'sbg:x': 0
    'sbg:y': 1072.8828125
  - id: val_res_den_xml
    type: File
    'sbg:x': 0
    'sbg:y': 951.2109375
  - id: wp_hashes
    type: File
    'sbg:x': 0
    'sbg:y': 829.5390625
outputs:
  - id: gbent
    outputSource:
      - standard_pgap/gbent
    type: File
    'sbg:x': 1787
    'sbg:y': 1737
  - id: gbk
    outputSource:
      - standard_pgap/gbk
    type: File
    'sbg:x': 1587
    'sbg:y': 1420
  - id: gff
    outputSource:
      - standard_pgap/gff
    type: File
    'sbg:x': 1622
    'sbg:y': 1263
  - id: nucleotide_fasta
    outputSource:
      - standard_pgap/nucleotide_fasta
    type: File?
    'sbg:x': 1612
    'sbg:y': 1042
  - id: protein_fasta
    outputSource:
      - standard_pgap/protein_fasta
    type: File?
    'sbg:x': 1542
    'sbg:y': 795
steps:
  - id: prepare_input_template
    in:
      - id: fasta
        source: fasta
      - id: submol
        source: submol
    out:
      - id: output_fasta
      - id: submit_block_template
    run: prepare_user_input2.cwl
    label: Prepare user input
    'sbg:x': 664
    'sbg:y': 228
  - id: standard_pgap
    in:
      - id: 16s_blastdb_dir
        source: 16s_blastdb_dir
      - id: 23s_blastdb_dir
        source: 23s_blastdb_dir
      - id: 5s_model_path
        source: 5s_model_path
      - id: AntiFamLib
        source: AntiFamLib
      - id: CDDdata
        source: CDDdata
      - id: CDDdata2
        source: CDDdata2
      - id: asn2pas_xsl
        source: asn2pas_xsl
      - id: blast_rules_db
        source: blast_rules_db
      - id: blast_rules_db_dir
        source: blast_rules_db_dir
      - id: defline_cleanup_rules
        source: defline_cleanup_rules
      - id: fasta
        source: prepare_input_template/output_fasta
      - id: gc_assm_name
        source: gc_assm_name
      - id: gene_master_ini
        source: gene_master_ini
      - id: genemark_path
        source: genemark_path
      - id: hmm_path
        source: hmm_path
      - id: hmms_tab
        source: hmms_tab
      - id: naming_blast_db
        source: naming_blast_db
      - id: naming_hmms_combined
        source: naming_hmms_combined
      - id: naming_hmms_tab
        source: naming_hmms_tab
      - id: naming_sqlite
        source: naming_sqlite
      - id: rfam_amendments
        source: rfam_amendments
      - id: rfam_model_path
        source: rfam_model_path
      - id: rfam_stockholm
        source: rfam_stockholm
      - id: selenoproteins
        source: selenoproteins
      - id: submit_block_template
        source: prepare_input_template/submit_block_template
      - id: taxid
        source: taxid
      - id: taxon_db
        source: taxon_db
      - id: thresholds
        source: thresholds
      - id: uniColl_cache
        source: uniColl_cache
      - id: univ_prot_xml
        source: univ_prot_xml
      - id: val_res_den_xml
        source: val_res_den_xml
      - id: wp_hashes
        source: wp_hashes
    out:
      - id: gbent
      - id: gbk
      - id: gff
      - id: nucleotide_fasta
      - id: protein_fasta
    run: wf_pgap.cwl
    label: PGAP Pipeline
    'sbg:x': 1230
    'sbg:y': 1831
requirements:
  - class: SubworkflowFeatureRequirement
