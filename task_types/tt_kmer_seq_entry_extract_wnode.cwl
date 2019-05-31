#!/usr/bin/env cwl-runner
cwlVersion: v1.0
label: "kmer_seq_entry_extract_wnode"
class: Workflow # task type
inputs:
    entry: File
    kmer_file_list: File[]
    asn_cache: Directory
    kmer_output_dir: 
        type: string
        default: kmer_dir
outputs:
    out_kmer_dir:
        type: Directory
        outputSource: kmer_extract_wnode/outdir
steps:
    submit_kmer_extract:
        run: ../progs/submit_kmer_extract.cwl
        in:
            seq_entry: entry
            expected_output: 
                default: expected_kmer_files
            kmer_output_dir:  kmer_output_dir
        out: [jobs]
    kmer_extract_wnode:
        run: ../progs/kmer_extract_wnode.cwl
        in:
            input: entry
            input_jobs: submit_kmer_extract/jobs
            asn_cache: asn_cache
            kmer_output_dir:  kmer_output_dir
            input_type: 
                default: seq-entry
            
        out: [outdir]

