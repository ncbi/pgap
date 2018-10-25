cwlVersion: v1.0
label: "bact_get_kmer_reference"
# File: task_types/tt_bact_get_kmer_reference.cwl
class: Workflow # task type
inputs: []    
outputs:
  gc_id_list:
    type: File
    outputSource:
        bact_get_kmer_reference/gc_id_list
steps:
  bact_get_kmer_reference:
    run: ../progs/bact_get_kmer_reference.cwl
    in: 
        o:
            default: reference-assms
    out: [gc_id_list]
