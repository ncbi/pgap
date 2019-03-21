#!/usr/bin/env cwl-runner4
label: kmer_files2sqlite.cwl
cwlVersion: v1.0
doc: |
        Convert input .kmer.gz (kmer_file) and .xml (kmer_metadata_file)
        into new sqlite database
        Takes a directory input
class: CommandLineTool
baseCommand:    kmer_files2sqlite 
inputs:
    kmer_dir: 
        type: Directory
        inputBinding:
            prefix: -file-uri
    output_file:
        type: string
        default: "dburi:local_kmer_cache.sqlite"
        inputBinding:
            prefix: -db-uri
outputs: 
    out_kmer_cache_sqlite:
        type: File
        outputBinding:
            glob: $(inputs.output_file)
    