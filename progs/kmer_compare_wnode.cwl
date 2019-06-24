cwlVersion: v1.0 
label: "kmer_compare_wnode"

class: CommandLineTool
#
# You might need something like this:
#

baseCommand: kmer_compare_wnode
# this is only one example
# 
# 
# 
# /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/bin/submit_kmer_compare \
#     GPIPE_BCT.kmer_ref_compare_wnode.455674762.1521225984 \
#     -kmer-files-manifest kmer_ref_compare_wnode.455674762/inp/kmer_file_list.mft \
#     -ref-kmer-files-manifest kmer_ref_compare_wnode.455674762/inp/ref_kmer_file_list.mft
# 
# /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/bin/kmer_compare_wnode \
#     -dist-method \
#     minhash \
#     -minhash-signature \
#     minhash \
#     -score-method \
#     boolean \
# 
# /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/bin/gpx_make_outputs \
#     -num-partitions \
#     32 \
#     -output \
#     'kmer_ref_compare_wnode.455674762/out/distances.##.gz' \
#     -output-manifest \
#     kmer_ref_compare_wnode.455674762/out/distances.mft \
#
requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entryname: kmer-files-manifest.mft
        entry: $(inputs.kmer_list.path)
      - entryname: kmer-ref-files-manifest.mft
        entry: ${var blob = '# kmer-ref-files-manifest.mft created for kmer_compare_wnode from input kmer_ref_list File\n';  if(inputs.kmer_ref_list == null ) { return blob; } else { return blob +  inputs.kmer_ref_list.path + '\n'; } }
        
inputs:
    kmer_cache_sqlite:
        type: File
        inputBinding:
            prefix: -kmer-cache-uri
    kmer_list: 
        type: File
    kmer_manifest:
        type: string?
        default: kmer-files-manifest.mft
        inputBinding:
            prefix: -kmer-files-manifest
    kmer_ref_list: 
        type: File?
    kmer_ref_manifest:
        type: string?
        default: kmer-ref-files-manifest.mft
        inputBinding:
            prefix: -ref-kmer-files-manifest
    dist_method:
        type: string?
        inputBinding:
            prefix: -dist-method
    minhash_signature:
        type: string?
        inputBinding:
            prefix: -minhash-signature
    score_method:
        type: string?
        inputBinding:
            prefix: -score-method
    jobs:
        type: File
        inputBinding:
            prefix: -input-jobs 
    O:
        type: string
        default: outdir
        inputBinding:
            prefix: -O
        
outputs: 
    outdir:
        type: Directory
        outputBinding:
            glob: $(inputs.O)