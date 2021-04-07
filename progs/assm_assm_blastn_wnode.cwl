cwlVersion: v1.2
label: "assm_assm_blastn_wnode"

class: CommandLineTool
requirements:
   - class: InlineJavascriptRequirement
   - class: InitialWorkDirRequirement
     listing:

       - entryname: queries-and-targets.mft
         entry: |- 
          ${
            var blob = '# queries-and-targets.mft created for assm_assm_blastn_wnode from input "target_set" File\n'; 
            if(inputs.target_set != null) { 
              for(var i=0; i<inputs.target_set.length; i++) {
                blob += inputs.target_set[i].path + '\n'; 
              }
            } 
            return blob; 
          }

baseCommand: assm_assm_blastn_wnode
arguments: [ -nogenbank ]
inputs:
  input_jobs:
    type: File?
    inputBinding:
        prefix: -input-jobs
  target_set:
    type: File[]
  target_set_manifest:
    type: string?
    default: queries-and-targets.mft
    inputBinding:
      prefix: -target-set-manifest
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
