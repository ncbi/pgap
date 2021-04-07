cwlVersion: v1.2
label: "kmer_compare_wnode"

inputs:
    kmer_cache_sqlite: File
    input_jobs: File
    input_jobs_pairwise: File
    kmer_tar_file: File
    kmer_ref_file: File
    kmer_file: File
    
class: Workflow
steps:
    ref_target:
        run: ../../kmer_compare_wnode.cwl
        in:
            kmer_cache_sqlite: kmer_cache_sqlite
            kmer_list: kmer_tar_file
            ref_kmer_list: kmer_ref_file
            jobs: input_jobs
            dist_method:
                default: 'minhash'
            minhash_signature:
                default: 'minhash'
            score_method:
                default: 'boolean'
        out: []
    pairwise:
        run: ../../kmer_compare_wnode.cwl
        in:
            kmer_cache_sqlite: kmer_cache_sqlite
            kmer_list: kmer_file
            jobs: input_jobs_pairwise
            dist_method:
                default: 'minhash'
            minhash_signature:
                default: 'minhash'
            score_method:
                default: 'boolean'
        out: []
outputs: []    