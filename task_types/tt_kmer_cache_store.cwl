cwlVersion: v1.0
label: "kmer_cache_store"
# file: task_types/tt_kmer_cache_store.cwl
class: Workflow # task type
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest
inputs:
  kmer_file_list: File[]
  kmer_cache_path: Directory
outputs:
  out_kmer_file_list:
    type: File[]
    outputSource: cache_kmer/out_kmer_file_list
steps:
  cache_kmer:
    run: ../progs/cache_kmer.cwl
    in:
      kmer_cache_path: kmer_cache_path
      store: 
        default: true
      onew:
        default: onew.list
    out: [out_kmer_file_list]
