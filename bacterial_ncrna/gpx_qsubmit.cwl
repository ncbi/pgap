cwlVersion: v1.0
label: "Run genomic CMsearch (Rfam rRNA), scatter"
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/pgap:latest

requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.asn_cache)
        writable: True
    
#gpx_qsubmit -asn-cache sequence_cache -ids-manifest seqids.mft
baseCommand: gpx_qsubmit
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
  asncache:
    type: Directory
    outputBinding:
      glob: $(inputs.asn_cache.basename)
  jobs:
    type: File
    outputBinding:
      glob: $(inputs.output)

  
  
