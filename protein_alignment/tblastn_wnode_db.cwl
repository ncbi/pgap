#!/usr/bin/env cwl-runner

cwlVersion: v1.2
class: CommandLineTool

label: "Seed Protein Alignments, execute"


requirements:
  - class: ResourceRequirement
    ramMax: 4000
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.asn_cache)
        writable: False
      - entry: $(inputs.uniColl_asn_cache)
        writable: False
      - entry: $(inputs.blastdb_dir)
        writable: False
    
baseCommand: tblastn_wnode

arguments: [ -align_filter, "pct_identity_gapopen_only >= 75", -backlog, "1", -comp_based_stats, "F", -dbsize, "6000000000", -delay, "0", -evalue, "0.1", -gapextend, "2", -gapopen, "9", -matrix, BLOSUM62, -max-jobs, "1", -seg, "no", -soft_masking, "true", -threshold, "21", -word_size, "6", -nogenbank, -short-protein-threshold, "30" ]

inputs:
  db_gencode:
    type: int
    inputBinding:
      prefix: -db_gencode
    
  blastdb_dir:
    type: Directory
  asn_cache:
    type: Directory
    inputBinding:
      prefix: -asn-cache
      valueFrom: $(inputs.asn_cache.basename),$(inputs.uniColl_asn_cache.basename)
  uniColl_asn_cache:
    type: Directory
  input_jobs:
    type: File
    inputBinding:
      prefix: -input-jobs
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

