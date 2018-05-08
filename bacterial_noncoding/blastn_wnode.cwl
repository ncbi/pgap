cwlVersion: v1.0
label: "BLAST against rRNA db, execution"
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest

requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.asn_cache)
        writable: True
      - entry: $(inputs.blastdb_dir)
        writable: False

#blastn_wnode -asn-cache sequence_cache -evalue 0.01 -max_target_seqs 250 -service GPipeExec_Prod -soft_masking true -task blastn -word_size 12 -swap-rows -queue GPIPE_BCT.blastn_wnode.455674932.1521225902
baseCommand: blastn_wnode
arguments: [ -evalue, "0.01", -max_target_seqs, "250", -soft_masking, "true", -task, blastn, -word_size, "12", -swap-rows ]
inputs:
  asn_cache:
    type: Directory
    inputBinding:
      prefix: -asn-cache
  input_jobs:
    type: File
    inputBinding:
      prefix: -input-jobs
  blastdb_dir:
    type: Directory
  output_dir:
    type: string?
    default: output
    inputBinding:
      prefix: -O
outputs:
  asncache:
    type: Directory
    outputBinding:
      glob: $(inputs.asn_cache.basename)
  outdir:
    type: Directory
    outputBinding:
      glob: $(inputs.output_dir)
  
  
