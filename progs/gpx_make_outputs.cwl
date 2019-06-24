cwlVersion: v1.0 
label: "gpx_make_outputs"

class: CommandLineTool
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

baseCommand: gpx_make_outputs
# this is only one example
# 
# submit_kmer_compare \
#     -kmer-files-manifest kmer_ref_compare_wnode.455674762/inp/kmer_file_list.mft \
#     -ref-kmer-files-manifest kmer_ref_compare_wnode.455674762/inp/ref_kmer_file_list.mft
# 
# kmer_compare_wnode \
#     -dist-method minhash \
#     -minhash-signature minhash \
#     -score-method boolean \
# 
# gpx_make_outputs -num-partitions 32 \
#     -output kmer_ref_compare_wnode.455674762/out/distances.##.gz' \
#     -output-manifest kmer_ref_compare_wnode.455674762/out/distances.mft \
# 
# 
inputs:
  input_path:
    type: Directory
    inputBinding:
      prefix: -input-path
  num_partitions:
    doc: >
        this parameter is fixed for this command line workflow, because the output is defined as single file
    type: int
    default: 1  
    inputBinding:
      prefix: -num-partitions
  output:
    type: string?
    inputBinding:
      prefix: -output
  output_glob:
    type: string?
#  output_manifest:
#    type: string
#    default: blastn.mft
#    inputBinding:
#      prefix: -output-manifest
  unzip:
    type: string?
    default: "*"
    inputBinding:
      prefix: -unzip
outputs:
  output_file:
    type: File
    outputBinding:
      glob: $(inputs.output_glob)
