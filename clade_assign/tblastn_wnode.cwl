#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

label: Find Marker Alignments, execute"

hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest

requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.asn_cache)
        writable: False
      - entry: $(inputs.CladeMarkers_asn_cache)
        writable: False
      - entry: $(inputs.blastdb_dir)
        writable: False
    
baseCommand: tblastn_wnode

arguments: [  -backlog, "1", -comp_based_stats, "F", -db_gencode, "4", -delay, "0", -evalue, "0.001", -matrix, BLOSUM80, -max-jobs, "1", -seg, "22 2.2 2.5", -soft_masking, "true", -threshold, "18", -word_size, "6", -nogenbank ]

inputs:
  asn_cache:
    type: Directory
    inputBinding:
      prefix: -asn-cache
      valueFrom: $(inputs.asn_cache.basename),$(inputs.CladeMarkers_asn_cache.basename)
  CladeMarkers_asn_cache:
    type: Directory
  input_jobs:
    type: File?
    default: 
      class: File 
      location: jobs.xml
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

