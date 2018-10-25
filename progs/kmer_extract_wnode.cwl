cwlVersion: v1.0 
label: "kmer_extract_wnode"

class: CommandLineTool
hints:
#
# You might need something like this:
#
# requirements:
#  - class: InitialWorkDirRequirement
#    listing:
#      - entry: $(inputs.asn_cache)
#        writable: True
#      - entry: $(inputs.blastdb_dir)
#        writable: False

baseCommand: kmer_extract_wnode
# this is only one example
# 
#/panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-04-27.build2756/bin/kmer_extract_wnode \
#    -type \
#    gencoll \
#    -asn-cache \
#    /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe_id_cache/full_id_cache \
#    -backlog \
#    1 \
#    -k \
#    18 \
#    -max-jobs \
#    1 \
#    -service \
#    GPipeExec_Prod \
#    -queue \
#    GPIPE_BCT.kmer_gc_extract_wnode.464769392.1525148023
# 
inputs:
  asn_cache:
    type: Directory
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
  O:
    type: string
    default: output_dir
    inputBinding:
        prefix: -O
outputs:
    output_files:
        type: File[]
        outputBinding:
            glob: $(input.O/*.kmer.gz)
