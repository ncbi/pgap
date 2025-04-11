cwlVersion: v1.2
label: "blastp_wnode_naming"
class: Workflow # task type
requirements:
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement
inputs:
  scatter_gather_nchunks: string
#  scatter_gather_chunk_size: string
  blastdb_dir: Directory
  blastdb: string[]
  # cluster_blastp_wnode_output: Directory? # shortcut to bypass cluster_blastp
  lds2: File
  proteins: File
  affinity: string
  asn_cache: Directory[]
  max_batch_length: int
  nogenbank: boolean
  align_filter: string?
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
  soft_masking: string?
  threshold: int
  top_by_score: int?
  word_size: int
  ids: File[]
  batch-size: int?
  taxid: int
  blast_hits_cache: File?
  blast_type: string?
  taxon_db: File
  genus_list: int[]
outputs:
  blast_align:
    type: File[]
    outputSource: [collect_aligns/file_out, retrieve_cached_hits/hits_output]

steps:
  retrieve_cached_hits: 
    run: ../progs/orf_hits_cache_retrieve.cwl
    in:
      lds2: lds2
      proteins: proteins
      # we do not need blastdb here, like in classic PGAP, the only reason we supply it there is to derive
      # -naming-db-version parameter:
      taxid: taxid
      blast_type: blast_type
      genus_list: genus_list
      orfs: ids
      sqlite_cache: blast_hits_cache
      taxon_db: taxon_db
    out: [hits_output, not_found_output]
    
  gpx_qsubmit:
    run: ../progs/gpx_qsubmit.cwl
    in:
      lds2: lds2
      proteins: proteins
      ids: 
        source: retrieve_cached_hits/not_found_output
        valueFrom: "$( [self] )"  
      affinity: affinity
      asn_cache: asn_cache
      max_batch_length: max_batch_length
      blastdb_dir: blastdb_dir
      blastdb: blastdb
      nogenbank: nogenbank
      batch_size: batch-size
    out: [jobs]

  split_jobs:
    run: ../split_jobs/split.cwl
    in:
      input: gpx_qsubmit/jobs
      nchunks: scatter_gather_nchunks
#      chunk_size: scatter_gather_chunk_size
    out:  [ jobs ]

  cluster_and_qdump: 
    run: tt_cluster_and_qdump.cwl
    scatter: input_jobs
    in:
      input_jobs: split_jobs/jobs
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
    out: [blast_align]
    

  collect_aligns:
    run: ../split_jobs/cat_array_of_files.cwl
    in: 
      files_in: cluster_and_qdump/blast_align
    out: [ file_out ]
