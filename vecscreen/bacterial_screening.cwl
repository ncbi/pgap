class: Workflow
cwlVersion: v1.0
id: bacterial_screening
label: bacterial_screening
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: asn_cache
    type: Directory
    'sbg:x': 0
    'sbg:y': 336
  - id: contam_in_prok_blastdb_dir
    type: Directory
    'sbg:x': 0
    'sbg:y': 229
  - id: contig_gilist
    type: File
    'sbg:x': 0
    'sbg:y': 114.5
outputs:
  - id: blast_align
    outputSource:
      - BLAST_Against_contam_in_prok/blast_align
    type: File
    'sbg:x': 528
    'sbg:y': 289
  - id: feats
    outputSource:
      - Generate_contam_in_prok_hit_features/feats
    type: File
    'sbg:x': 958
    'sbg:y': 241
  - id: filtered_align
    outputSource:
      - Filter_contam_in_prok_BLAST_Results/o
    type: File
    'sbg:x': 933
    'sbg:y': 397
steps:
  - id: BLAST_Against_contam_in_prok
    in:
      - id: asn_cache
        source: asn_cache
      - id: best_hit_overhang
        default: 0.1
      - id: best_hit_score_edge
        default: 0.1
      - id: blastdb
        default: contam_in_prok
      - id: blastdb_dir
        source: contam_in_prok_blastdb_dir
      - id: dust
        default: 'yes'
      - id: evalue
        default: 0.0001
      - id: ids_out
        source: contig_gilist
      - id: perc_identity
        default: 90
      - id: task
        default: megablast
      - id: word_size
        default: 28
    out:
      - id: blast_align
    run: ../task_types/tt_blastn_wnode.cwl
    label: blastn_wnode
    'sbg:x': 194
    'sbg:y': 147
  - id: Find_Frequent_contam_in_prok_Hits
    in:
      - id: align
        source: BLAST_Against_contam_in_prok/blast_align
    out:
      - id: frequent
    run: ../progs/align_find_frequent_sas.cwl
    label: align_find_frequent_sas
    'sbg:x': 436
    'sbg:y': -15
  - id: Filter_contam_in_prok_BLAST_Results
    in:
      - id: asn_cache
        source:
          - asn_cache
      - id: filter
        default: ' (align_length >= 50 && pct_identity_gap >= 98) || (align_length >= 100 && pct_identity_gap >= 94) || (align_length >= 200 && pct_identity_gap >= 90)'
      - id: ifmt
        default: seq-align-set
      - id: input
        source: BLAST_Against_contam_in_prok/blast_align
      - id: subject_whitelist
        source: Find_Frequent_contam_in_prok_Hits/frequent
    out:
      - id: o
      - id: onon_match
    run: ../progs/align_filter.cwl
    label: align_filter
    'sbg:x': 626
    'sbg:y': 116
  - id: Generate_contam_in_prok_hit_features
    in:
      - id: input
        source: Filter_contam_in_prok_BLAST_Results/o
      - id: label_suffix
        default: contam_in_prok
      - id: source
        default: vector
    out:
      - id: feats
    run: ../progs/generate_fscr_feats.cwl
    label: generate_fscr_feats
    'sbg:x': 807
    'sbg:y': 32
requirements:
  - class: SubworkflowFeatureRequirement
