#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow
label: "test cluster_blastp_wnode"
requirements:
  - class: SubworkflowFeatureRequirement
inputs:
  input_jobs: File
  blastdb_dir: Directory[]
  lds2: File
  proteins: File
  asn_cache: Directory[]
  nogenbank: 
    type: boolean
    default: true
  align_filter: 
    type: string
    default: 'score>0 && pct_identity_gapopen_only > 35' 
  allow_intersection: boolean
  comp_based_stats: 
    type: string # F/T
    default: 'F'
  compart: boolean
  dbsize: 
    type: string # can't int, because too large
    default: '6000000000'
  evalue: 
    type: float?
    default: 0.1 
  extra_coverage: 
    type: int?
    default: 20 
  max_jobs: 
    type: int
    default: 1
  max_target_seqs: 
    type: int
    default: 50
  no_merge: 
    type: boolean
    default: true
  ofmt: 
    type: string
    default: 'asn-binary'
  seg: 
    type: string
    default: '30 2.2 2.5'
  soft_masking: 
    type: string
    default: 'yes'
  threshold: 
    type: int
    default: 21
  top_by_score: 
    type: int
    default: 10
  word_size: 
    type: int
    default: 6

outputs:
  outdir:
    type: Directory
    outputSource: cluster_blastp_wnode/outdir
steps:
  cluster_blastp_wnode:
    run: ../../cluster_blastp_wnode.cwl 
    in:
      input_jobs: input_jobs
      align_filter: align_filter
      allow_intersection: allow_intersection
      asn_cache: asn_cache
      blastdb_dir: blastdb_dir
      comp_based_stats: comp_based_stats
      compart: compart
      dbsize: dbsize
      evalue: evalue
      extra_coverage: extra_coverage
      lds2: lds2
      proteins: proteins # companion to lds2
      max_jobs: max_jobs
      max_target_seqs: max_target_seqs
      no_merge: no_merge
      nogenbank: nogenbank
      ofmt: ofmt
      seg: seg
      soft_masking: soft_masking
      threshold: threshold
      top_by_score: top_by_score
      word_size: word_size
      # note: this is defined here, not in inputs: section to exactly copy the structure of defaults in the
      # production task node cwl that calls the prog being tested here. If we change it there, change it here
      # same goes of course for all the parameters.
      workers_per_cpu:
        default: 1.0
    out: [outdir]

