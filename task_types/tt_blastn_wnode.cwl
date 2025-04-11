cwlVersion: v1.2
label: "tt_blastn_wnode"
class: Workflow # task type
requirements:
    - class: MultipleInputFeatureRequirement
inputs:
  asn_cache: Directory
  ids_out: File
  blastdb_dir: Directory
  blastdb: string
  evalue: float
  word_size: int
  max_target_seqs: int?
  soft_masking: string?
  affinity: string?
  max_batch_length: int?
  best_hit_overhang: float?
  best_hit_score_edge: float?
  dust: string?
  perc_identity: float?
  task: string?
  
outputs:
  blast_align:
    type: File
    outputSource: gpx_make_outputs/output_file
steps:
  gpx_qsubmit:
    run: ../progs/gpx_qsubmit.cwl
    in:
      proteins:
        default:
            class: File
            path: '/dev/null'
            basename: 'null'
            contents: ''
      affinity: affinity
      asn_cache: 
        source: [asn_cache]
        linkMerge: merge_flattened
      max_batch_length: max_batch_length
      ids: 
        source: [ids_out]
        linkMerge: merge_flattened
      blastdb_dir: blastdb_dir
      blastdb: 
        source: [blastdb]
        linkMerge: merge_flattened
      nogenbank: 
        default: true
    out: [jobs]
  blastn_wnode:
    run: ../progs/blastn_wnode.cwl
    in:
      asn_cache: asn_cache
      evalue: evalue
      max_target_seqs: max_target_seqs
      soft_masking: 
        default: 'true'
      swap_rows: 
        default: false
      task: 
        default: blastn
      word_size: word_size
      input_jobs: gpx_qsubmit/jobs
      blastdb_dir: blastdb_dir
      blastdb: blastdb
      best_hit_overhang: best_hit_overhang
      best_hit_score_edge: best_hit_score_edge
      dust: dust
      perc_identity: perc_identity
      
    out: [outdir]
  gpx_make_outputs:
    run: ../progs/gpx_make_outputs.cwl
    in:
      input_path: blastn_wnode/outdir
      num_partitions: 
        default: 1
      output:
        default: "blast.#.asn"
      output_glob:
        default: "blast.*.asn"
    out: [output_file]
