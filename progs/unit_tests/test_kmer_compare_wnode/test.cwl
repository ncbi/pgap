cwlVersion: v1.0 
label: "kmer_compare_wnode"

inputs:
    kmer_cache_sqlite: File
    input_jobs: File
    
class: Workflow
steps:
    ref_target:
        run: ../../kmer_compare_wnode.cwl
        in:
            kmer_cache_sqlite: kmer_cache_sqlite
            kmer_files_manifest: 
                default: '/dev/null'
            input_jobs: input_jobs
            dist_method:
                default: 'minhash'
            minhash_signature:
                default: 'minhash'
            score_method:
                default: 'boolean'
        out: []
outputs: []    