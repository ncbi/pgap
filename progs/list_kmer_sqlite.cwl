#!/usr/bin/env cwl-runner
doc: Produces the list of all keys in sqlite database
cwlVersion: v1.2
label: list_kmer_sqlite.cwl
baseCommand: list_kmer_sqlite
class: CommandLineTool
inputs:
    kmer_cache_sqlite: 
        type: File
        inputBinding:
            prefix: -kmer-cache-uri
    out_name:
        type: string
        default: sqlite-listing.ids
        inputBinding:
            prefix: -listing
outputs: 
    keys:
        type: File
        outputBinding:
            glob: $(inputs.out_name)
