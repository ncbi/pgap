cwlVersion: v1.2
label: "kmer_gc_extract_wnode"
# File "task_types/tt_kmer_gc_extract_wnode.cwl"
# caller steps:
#    Extract_Kmer_List
class: Workflow # task type
inputs:
  new_gc_id_list: File
  asn_cache: Directory
outputs:
  out_kmer_file_list:
    type: File[]
    outputSource: kmer_extract_wnode/output_files 
steps:
  submit_kmer_extract:
    run: ../progs/submit_kmer_extract.cwl
    in:
      gc_id_list: new_gc_id_list
    out: [jobs]
  kmer_extract_wnode:
    run: ../progs/kmer_extract_wnode.cwl
    in:
      input_jobs: submit_kmer_extract/jobs
      asn_cache: asn_cache
      input_type: 
        default: gencoll
      max_jobs: 
        default: 1
      k: 
        default: 18
      backlog: 
        default: 1
      O:
        default: output_dir
    out: [output_files]
        


