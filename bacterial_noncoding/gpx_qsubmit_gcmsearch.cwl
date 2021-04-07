cwlVersion: v1.2
label: "Run genomic CMsearch (5S rRNA), scatter"
class: CommandLineTool

requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.asn_cache)
        writable: False
    
#gpx_qsubmit -affinity subject -asn-cache sequence_cache -max-batch-length 50000 -o jobs.xml -db ../../input/16S_rRNA/blastdb -ids sequences.seq_id
#gpx_qsubmit -asn-cache sequence_cache -o jobs.xml -ids sequences.seq_ids
baseCommand: gpx_qsubmit
arguments: [ -nogenbank ]
inputs:
  asn_cache:
    type: Directory
    inputBinding:
      prefix: -asn-cache
  seqids:
    type: File
    inputBinding:
      prefix: -ids
  output:
    type: string?
    default: jobs.xml
    inputBinding:
      prefix: -output
outputs:
  jobs:
    type: File
    outputBinding:
      glob: $(inputs.output)

  
  
