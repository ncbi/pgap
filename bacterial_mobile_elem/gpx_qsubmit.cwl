cwlVersion: v1.0
label: "Execute CRISPR, scatter"
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest

# requirements:
#   - class: InitialWorkDirRequirement
#     listing:
#       - entry: $(inputs.asn_cache)
#         writable: False
    
#gpx_qsubmit -asn-cache sequence_cache -batch-size 1 -ids-manifest seqids.mft
baseCommand: gpx_qsubmit
arguments: [ -batch-size, "1" ]
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

  
  
