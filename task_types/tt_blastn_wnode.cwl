cwlVersion: v1.0
label: "blastn_wnode"
class: Workflow # task type
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest
inputs:
  asn_cache: Directory
  ids_out: File
  blastdb_dir: Directory
  blastdb: string
  gilist: File
  evalue: float
  word_size: int
  max_target_seqs: int
  soft_masking: string
  affinity: string
  max_batch_length: int
  
outputs:
  blast_align:
    type: File
    outputSource: gpx_make_outputs/blast_align
steps:
  gpx_qsubmit:
    run: ../progs/gpx_qsubmit.cwl
    in:
      affinity: affinity
      asn_cache: asn_cache
      max_batch_length: max_batch_length
      ids: ids_out
      blastdb_dir: blastdb_dir
      blastdb: blastdb
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
