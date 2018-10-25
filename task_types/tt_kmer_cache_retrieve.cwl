cwlVersion: v1.0
label: "kmer_cache_retrieve"
# file: task_types/tt_kmer_cache_retrieve.cwl
class: Workflow # task type
inputs:
  gc_id_list: File
  kmer_cache_path: Directory
outputs:
  new_gc_id_list:
    type: File
    outputSource: cache_kmer/new_gc_id_list
  out_kmer_file_list:
    type: File[]
    outputSource: cache_kmer/out_kmer_file_list
  out_kmer_cache_path:
    type: Directory
    outputSource: cache_kmer/out_kmer_cache_path
steps:
  cache_kmer:
    run: ../progs/cache_kmer.cwl
    in:
      gc_id_list: gc_id_list
      kmer_cache_path: kmer_cache_path
      retrieve: 
        default: true
      onew:
        default: onew.list
    out: [new_gc_id_list, out_kmer_file_list,out_kmer_cache_path]
