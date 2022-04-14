cwlVersion: v1.2
label: "cluster_blastp_wnode"

class: CommandLineTool
requirements:
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    ramMax: 5000
  - class: InitialWorkDirRequirement
    listing:
      - entry:  $(inputs.blastdb_dir) 
        writable: False
      - entry:  ${ var cs=0; var s=inputs.asn_cache.length-1; var as = cs; if(as >= s) {as = s }; return inputs.asn_cache[as]; }
        writable: False
      - entry:  ${ var cs=1; var s=inputs.asn_cache.length-1; var as = cs; if(as >= s) {as = s }; return inputs.asn_cache[as]; }
        writable: False
      - entry:  $(inputs.lds2)
        writable: True
      - entry:  $(inputs.proteins)
        writable: False

baseCommand: cluster_blastp_wnode
inputs:
  asn_cache:
    type: Directory[]
    inputBinding:
      prefix: -asn-cache
      itemSeparator: ","
  align_filter: 
    type: string?
    inputBinding:
      prefix: -align_filter
  allow_intersection:
    type: boolean?
    inputBinding:
      prefix: -allow-intersection
  backlog:
    type: int?
    inputBinding:
      prefix: -backlog
  blastdb_dir:
    type: Directory
  comp_based_stats:  # F/T
    type: string
    inputBinding:
      prefix: -comp_based_stats
  compart:
    type: boolean?
    inputBinding:
      prefix: -compart
  dbsize:
    type: string?
    inputBinding:
      prefix: -dbsize
  delay:
    type: int?
    inputBinding:
      prefix: -delay
  evalue:
    type: float?
    inputBinding:
      prefix: -evalue
  extra_coverage:
    type: int?
    inputBinding:
      prefix: -extra-coverage
  input_jobs:
    type: File
    inputBinding:
      prefix: -input-jobs
  lds2: 
    type: File?
    inputBinding:
      prefix: -lds2
  proteins: # companion to lds2
    type: File?
  max_jobs:
    type: int?
    inputBinding:
      prefix: -max-jobs
  max_target_seqs:
    type: int?
    inputBinding:
      prefix: -max_target_seqs
  ofmt:
    type: string?
    inputBinding:
      prefix: -ofmt
  no_merge:    
    type: boolean?
    inputBinding:
      prefix: -no-merge
  nogenbank:    
    type: boolean?
    inputBinding:
      prefix: -nogenbank
  seg:
    type: string?
    inputBinding:
      prefix: -seg
  soft_masking:
    type: string?
    inputBinding:
      prefix: -soft_masking
  threshold:
    type: int?
    inputBinding:
      prefix: -threshold
  short_protein_threshold:
    type: int?
    inputBinding:
      prefix:  -short-protein-threshold
  top_by_score:
    type: int?
    inputBinding:
      prefix: -top-by-score
  workers:
    type: int?
    inputBinding:
      prefix: -workers
  workers_per_cpu:
    type: float?
    inputBinding:
      prefix: -workers-per-cpu
  word_size:
    type: int
    inputBinding:
      prefix: -word_size
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
