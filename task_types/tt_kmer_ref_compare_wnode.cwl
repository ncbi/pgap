#!/usr/bin/env cwl-runner
cwlVersion: v1.2
label: "kmer_ref_compare_wnode"
class: Workflow # task type
inputs:
  kmer_cache_sqlite: File
  kmer_list: File
  ref_kmer_list: File
  dist_method: string
  minhash_signature: string
  score_method: string
outputs:
    distances:
        type: File
        outputSource: gpx_make_outputs/output_file
    outdir:
        doc: we hope to use this to pass instead of file list
        type: Directory
        outputSource: kmer_compare_wnode/outdir
  
steps:
    submit_kmer_compare:
        run: ../progs/submit_kmer_compare.cwl
        in:
            kmer_list: kmer_list
            ref_kmer_list: ref_kmer_list
        out: [output]
    kmer_compare_wnode:
        run: ../progs/kmer_compare_wnode.cwl
        in:
            kmer_cache_sqlite: kmer_cache_sqlite
            kmer_list: kmer_list
            ref_kmer_list: ref_kmer_list
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
            unzip:
                default: "dont-unzip"
        out: [output_file]
