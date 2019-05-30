cwlVersion: v1.0 
label: "kmer_extract_wnode"

class: Workflow
inputs: 
    entry: File
    entry_jobs: File
steps:
    seq_entry: # Extract_Kmers_From_Input
        run: ../../kmer_extract_wnode.cwl
        in:
            input: entry
            input_jobs: entry_jobs
            kmer_output_dir:  
                default: .
            input_type: 
                default: seq-entry
        out: [outdir]
outputs: 
    entry_out_kmer_dir:
        type: Directory
        outputSource: seq_entry/outdir
