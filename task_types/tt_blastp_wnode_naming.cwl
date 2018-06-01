cwlVersion: v1.0
label: "blastp_wnode_naming"
class: Workflow # task type
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest
requirements:
  - class: SubworkflowFeatureRequirement
#  - class: InlineJavascriptRequirement
#  - class: InitialWorkDirRequirement
#    listing:
#          # since we are using LDS2 we also need the actual source of ASN.1 objects in _current_ directory
#          # this makes it happen
#          # - entry: $(inputs.proteins )
#          #   writable: False
    
inputs:
  blastdb_dir: Directory[]
  blastdb: string
  cluster_blastp_wnode_output: Directory? # shortcut to bypass cluster_blastp
  lds2: File
  proteins: File
  affinity: string
  asn_cache: Directory[]
  max_batch_length: int
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
  nogenbank: boolean
  ofmt: string
  seg: string
  threshold: int
  top_by_score: int
  word_size: int
  ids: File[]
  batch-size: int?
outputs:
  blast_align:
    type: File
    outputSource: gpx_qdump/output
steps:
  # this has been tested, commenting out to run faster
  gpx_qsubmit:
    run: ../progs/gpx_qsubmit.cwl
    in:
      lds2: lds2
      proteins: proteins
      ids: ids
      affinity: affinity
      asn_cache: asn_cache
      max_batch_length: max_batch_length
      blastdb_dir: blastdb_dir
      blastdb: blastdb
      nogenbank: nogenbank
      batch_size: batch-size
    out: [jobs]
  cluster_blastp_wnode: # 30 minutes
    run: ../progs/cluster_blastp_wnode.cwl
    in:
      input_jobs: gpx_qsubmit/jobs
      align_filter: align_filter
      allow_intersection: allow_intersection
      asn_cache: asn_cache
      blastdb_dir: blastdb_dir
      blastdb: blastdb
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
      threshold: threshold
      top_by_score: top_by_score
      word_size: word_size
    out: [outdir]
  gpx_qdump:
    run: ../progs/gpx_qdump.cwl
    in:
      input_path: cluster_blastp_wnode/outdir # production mode
      # input_path: cluster_blastp_wnode_output # shortcut, because actually running cluster_blastp_wnode takes 30 min even for MG
      unzip: 
        default: '*'
      # bogus input because for some reason we are importing requirements from caller node
      # do not know how to resolve it yet, but at least we can keep on going
      # lds2: lds2
      # proteins: proteins
    out: [ output ]
    
