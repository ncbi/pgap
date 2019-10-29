cwlVersion: v1.0 
label: "assm_assm_blastn_wnode"

class: CommandLineTool
#
# You might need something like this:
#
# requirements:
#  - class: InitialWorkDirRequirement
#    listing:
#      - entry: $(inputs.asn_cache)
#        writable: True
#      - entry: $(inputs.blastdb_dir)
#        writable: False

baseCommand: assm_assm_blastn_wnode
inputs:
  input_jobs:
    type: File?
    inputBinding:
        prefix: -input-jobs 
  asn_cache:
    type: Directory[]
    inputBinding:
      prefix: -asn-cache
      itemSeparator: ","
  compart:
    type: boolean?
    inputBinding:
      prefix: -compart
  evalue:
    type: float?
    inputBinding:
      prefix: -evalue
  gapextend:
    type: int?
    inputBinding:
      prefix: -gapextend
  gapopen:
    type: int?
    inputBinding:
      prefix: -gapopen
  gc_cache:
    type: File
    inputBinding:
      prefix: -gc-cache
  max_bases_per_call:
    type: int?
    inputBinding:
      prefix: -max-bases-per-call
  max_target_seqs:
    type: int?
    inputBinding:
      prefix: -max_target_seqs
  merge_align_filter:
    type: string?
    inputBinding:
      prefix: -merge-align-filter
  merge_engine:
    type: string?
    inputBinding:
      prefix: -merge-engine
  soft_masking:
    type: string?
    inputBinding:
      prefix: -soft_masking
  task:
    type: string?
    inputBinding:
      prefix: -task
  use_common_components:
    type: boolean
    inputBinding:
      prefix: -use-common-components
  window_size:
    type: int?
    inputBinding:
      prefix: -window_size
  word_size:
    type: int?
    inputBinding:
      prefix: -word_size
  workers_per_cpu:
    type: float?
    inputBinding:
      prefix: -workers-per-cpu
  output_dir:
    type: string?
    default: output
    inputBinding:
      prefix: -O
    
    
outputs:
  outdir:
    type: Directory
    outputBinding:
      glob: $(inputs.output_dir)    