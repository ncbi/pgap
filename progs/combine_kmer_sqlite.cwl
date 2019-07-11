#!/usr/bin/env cwl-runner4
label: combine_kmer_sqlite.cwl
doc: Combine together reference kmer store and newly created kmer store for a new assembly
cwlVersion: v1.0
class: CommandLineTool
baseCommand: combine_kmer_sqlite
inputs:
    kmer_cache_sqlite: 
        type: File[]
        inputBinding:
            prefix: -input-kmer-sqlite-uri
            itemSeparator: ','
    output_kmer_file: 
        type: string
        default: combined_kmer_cache.sqlite
        inputBinding:
            prefix: -output-kmer-sqlite-file
    fast:
        type: boolean
        inputBinding:
            prefix: -fast
outputs:
    combined_cache_sqlite:
        type: File
        outputBinding:
            glob: $(inputs.output_kmer_file)
            
