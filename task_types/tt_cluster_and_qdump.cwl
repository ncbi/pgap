#!/usr/bin/env cwl-runner

cwlVersion: v1.2

class: Workflow

# make a workflow with jobs.xml as an input and a single file as an output to apply scatter/gather

label: "cluster_blastp_wnode and gpx_qdump combined"


requirements:
  - class: SubworkflowFeatureRequirement

inputs:
  input_jobs: File
  blastdb_dir: Directory
  lds2: File
  proteins: File
  asn_cache: Directory[]
  nogenbank: boolean
  align_filter: string
  allow_intersection: boolean
  comp_based_stats: string # F/T
  compart: boolean
  dbsize: string # can't int, because too large
  evalue: float?
  extra_coverage: int?
  max_jobs: int
  max_target_seqs: int
  no_merge: boolean
  ofmt: string
  seg: string
  soft_masking: string
  threshold: int
  top_by_score: int
  word_size: int
  short_protein_threshold: int?

outputs:
  blast_align:
    type: File
    outputSource: gpx_qdump/output

steps:
  cluster_blastp_wnode:
    run: ../progs/cluster_blastp_wnode.cwl
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
      short_protein_threshold: short_protein_threshold
      top_by_score: top_by_score
      word_size: word_size
      workers_per_cpu:
        default: 1.0
    out: [outdir]

  gpx_qdump:
    run: ../progs/gpx_qdump.cwl
    in:
      input_path: cluster_blastp_wnode/outdir # production mode
      unzip: 
        default: '*'
    out: [ output ]
   
