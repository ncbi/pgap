#!/usr/bin/env cwl-runner
cwlVersion: v1.0
label: "assm_assm_blastn_wnode"
class: Workflow # task type
inputs:
  asn_cache: Directory
  gencoll_asn: File
  ref_gencoll_asn: File
  queries_gc_id_list: File
  subjects_gc_id_list: File
  # assm_assm_blastn_wnode inputs:
  compart: boolean?
  evalue: float?
  gapextend: int?
  gapopen: int?
  gc_cache: File
  gc_seq_cache: Directory
  max_bases_per_call: int?
  max_target_seqs: int?
  merge_align_filter: string?
  merge_engine: string?
  soft_masking: string?
  task: string
  use_common_components: boolean
  window_size: int?
  word_size: int?
  workers_per_cpu: float?
  nogenbank: boolean?
#   gpx_qsubmit settings
  affinity: string
  
outputs:
  blast_align:
    type: File
    outputSource: gpx_qdump/output
steps:
  assm_assm_blastn_create_jobs:
    run: ../progs/assm_assm_blastn_create_jobs.cwl
    in: 
        affinity_bin: 
            default: 10
        queries_gc_id_list: queries_gc_id_list
        subjects_gc_id_list: subjects_gc_id_list
    out: [output]
  gpx_qsubmit:
    run: ../progs/gpx_qsubmit.cwl
    in:
      affinity: affinity
      asn_cache: 
        source: [asn_cache]
        linkMerge: merge_flattened
      nogenbank: nogenbank
      xml_jobs: assm_assm_blastn_create_jobs/output
    out: [jobs]
  assm_assm_blastn_wnode:
    run: ../progs/assm_assm_blastn_wnode.cwl
    in:
      asn_cache: 
        source: [asn_cache, gc_seq_cache]
        linkMerge: merge_flattened
      compart: compart
      evalue: evalue
      gapextend: gapextend
      gapopen: gapopen
      gc_cache: gc_cache
      max_bases_per_call: max_bases_per_call
      max_target_seqs: max_target_seqs
      merge_align_filter: merge_align_filter
      merge_engine: merge_engine
      soft_masking: soft_masking
      task: task
      use_common_components: use_common_components
      window_size: window_size
      word_size: word_size
      workers_per_cpu: workers_per_cpu
      input_jobs: gpx_qsubmit/jobs
    out: [ outdir ]
  gpx_qdump:
    run: ../progs/gpx_qdump.cwl
    in:
      input_path: assm_assm_blastn_wnode/outdir
      unzip: 
        default: '*'
    out: [ output ]