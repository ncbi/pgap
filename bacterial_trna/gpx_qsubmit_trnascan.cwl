cwlVersion: v1.0
label: "Run tRNAScan, scatter"
class: CommandLineTool

requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.asn_cache)
        writable: False
    
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
  # asncache:
  #   type: Directory
  #   outputBinding:
  #     glob: $(inputs.asn_cache.basename)
  jobs:
    type: File
    outputBinding:
      glob: $(inputs.output)

  
  
