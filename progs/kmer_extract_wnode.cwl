cwlVersion: v1.2
label: "kmer_extract_wnode"

class: CommandLineTool
#
# You might need something like this:
#
requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.input)
        writable: False

baseCommand: kmer_extract_wnode
arguments: [ -nogenbank ]
inputs:
  input:
    doc: Used only to be preserved
    type: File
  asn_cache:
    type: Directory?
    inputBinding:
      prefix: -asn-cache
  input_type:
    type: string?
    inputBinding:
      prefix: -type
  backlog:
    type: int?
    default: 1
    inputBinding:
      prefix: -backlog
  k:
    type: int?
    default: 18
    inputBinding:
      prefix: -k
  max_jobs:
    type: int?
    default: 1
    inputBinding:
      prefix: -max-jobs
  input_jobs:
    type: File
    inputBinding:
        prefix: -input-jobs
  kmer_output_dir:
    type: string
    inputBinding:
        prefix: -O
outputs:
    outdir:
        type: Directory
        outputBinding:
            glob: $(inputs.kmer_output_dir)
