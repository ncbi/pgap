cwlVersion: v1.0 
label: "submit_kmer_extract"

class: CommandLineTool
baseCommand: submit_kmer_extract
# this is only one example
# 
# 
# 
# /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/bin/submit_kmer_extract \
#     -expected-output \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/kmer_seq_entry_extract_wnode.455674802/var/expected_kmer_files \
#     -S \
#     GPIPE_SCHED1 \
#     -D \
#     GPipeSched_Prod1 \
#     -U \
#     gpipe_prod \
#     -P \
#     gpipe2007 \
#     -queue \
#     GPIPE_BCT.kmer_seq_entry_extract_wnode.455674802.1521225959 \
#     -kmer-output-dir \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/kmer_seq_entry_extract_wnode.455674802/out \
#     -seq-entry-manifest \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/kmer_seq_entry_extract_wnode.455674802/inp/seq_entry.mft
inputs:
  gc_id_list:
    type: File?
    inputBinding:
        prefix: -gc-id-list
  seq_entry:
    type: File?
    inputBinding:
        prefix: -seq_entry
  kmer_output_dir:
    type: string?
    default: output_dir
    inputBinding:
        prefix: -kmer-output-dir
  expected_output:
    type: string?
    default: expected_kmer_files
    inputBinding:
      prefix: -expected-output
  output:
    type: string
    default: output.xml
    inputBinding:
      prefix: -output
outputs:
    jobs:
        type: File
        outputBinding:
            glob: $(inputs.output)
