cwlVersion: v1.0
label: "kmer_ref_compare_wnode"
# File: task_types/tt_kmer_ref_compare_wnode.cwl
# this probably should be kmer_ref_compare_wnode12 where 2 is the number of files in input manifest 1 is the input file
class: Workflow # task type
inputs:
  kmer_file_list: File[]
  ref_kmer_file_list: File[]
  dist_method: string
  minhash_signature: string
  score_method: string
outputs:
  distances:
    type: File
    outputSource: gpx_make_outputs/output_file
steps:
  submit_kmer_compare:
    run: ../progs/submit_kmer_compare.cwl
    in:
        kmer_file_list: kmer_file_list
        ref_kmer_file_list: ref_kmer_file_list
    out: [output]
  kmer_compare_wnode:
    run: ../progs/kmer_compare_wnode.cwl
    in:
      jobs: submit_kmer_compare/output
      dist_method: dist_method
      minhash_signature: minhash_signature
      score_method: score_method
    out: [outdir]  
  gpx_make_outputs:
    run: ../progs/gpx_make_outputs.cwl
    in:
      input_path: kmer_compare_wnode/outdir
      num_partitions: 
        default: 1
      output: 
        default: "distances.##.gz"
      output_glob:
        default: "distances.*.gz"
    out: [output_file]
