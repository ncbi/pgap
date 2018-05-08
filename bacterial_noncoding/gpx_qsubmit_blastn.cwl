cwlVersion: v1.0
label: "BLAST against rRNA db, scatter"
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
    
#gpx_qsubmit -affinity subject -asn-cache sequence_cache -max-batch-length 50000 -o jobs.xml -db ../../input/16S_rRNA/blastdb -ids sequences.seq_id
baseCommand: gpx_qsubmit
arguments: [ -affinity, subject, -max-batch-length, "50000" ]
inputs:
  asn_cache:
    type: Directory
    inputBinding:
      prefix: -asn-cache
  seqids:
    type: File
    inputBinding:
      prefix: -ids
  blastdb_dir:
    type: Directory?
  blastdb:
    type: string?
    inputBinding:
      prefix: -db
      valueFrom: $(inputs.blastdb_dir.path)/$(inputs.blastdb)
  output:
    type: string?
    default: jobs.xml
    inputBinding:
      prefix: -output
outputs:
  asncache:
    type: Directory
    outputBinding:
      glob: $(inputs.asn_cache.basename)
  jobs:
    type: File
    outputBinding:
      glob: $(inputs.output)

  
  
