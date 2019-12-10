class: Workflow
cwlVersion: v1.0
id: bacterial_screening
label: bacterial_screening
requirements:
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement
inputs:
  asn_cache:
    type: Directory
  contam_in_prok_blastdb_dir:
    type: Directory
  contig_gilist:
    type: File
steps:
  BLAST_Against_contam_in_prok:
    run: ../task_types/tt_blastn_wnode.cwl
    in:
      asn_cache:
        source: asn_cache
      best_hit_overhang:
        default: 0.1
      best_hit_score_edge:
        default: 0.1
      blastdb:
        default: contam_in_prok
      blastdb_dir:
        source: contam_in_prok_blastdb_dir
      dust:
        default: 'yes'
      evalue:
        default: 0.0001
      ids_out:
        source: contig_gilist
      perc_identity:
        default: 90
      task:
        default: megablast
      word_size:
        default: 28
    out: [blast_align]
  Find_Frequent_contam_in_prok_Hits:
    in:
      align:
        source: BLAST_Against_contam_in_prok/blast_align
    out: [frequent]
    run: ../progs/align_find_frequent_sas.cwl
    label: align_find_frequent_sas
  Filter_contam_in_prok_BLAST_Results:
    run: ../progs/align_filter.cwl
    label: align_filter
    in:
      asn_cache:
        source: [asn_cache]
        linkMerge: merge_flattened
      filter:
        default: ' (align_length >= 50 && pct_identity_gap >= 98) || (align_length >= 100 && pct_identity_gap >= 94) || (align_length >= 200 && pct_identity_gap >= 90)'
      ifmt:
        default: seq-align-set
      input:
        source: [BLAST_Against_contam_in_prok/blast_align]
        linkMerge: merge_flattened
      subject_whitelist:
        source: Find_Frequent_contam_in_prok_Hits/frequent
    out: [o, onon_match]
  Generate_contam_in_prok_hit_features:
    in:
      input:
        source: Filter_contam_in_prok_BLAST_Results/o
      label_suffix:
        default: contam_in_prok
      source:
        default: vector
      o:
        default: feats.asn
    out: [feats]
    run: ../progs/generate_fscr_feats.cwl
    label: generate_fscr_feats
outputs:
  blast_align:
    outputSource: BLAST_Against_contam_in_prok/blast_align
    type: File
  feats:
    outputSource: Generate_contam_in_prok_hit_features/feats
    type: File
  filtered_align:
    outputSource: Filter_contam_in_prok_BLAST_Results/o
    type: File
