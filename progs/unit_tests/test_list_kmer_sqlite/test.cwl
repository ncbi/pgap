cwlVersion: v1.0 
label: "list_kmer_sqlite"

inputs:
    kmer_cache_sqlite: File
class: Workflow
steps:
    step1: # this step does not exist in classic PGAP bacterial kmer graph
        run: ../../list_kmer_sqlite.cwl
        in:
            kmer_cache_sqlite: kmer_cache_sqlite
        out: [keys]
outputs:
    keys:
        type: File
        outputSource: step1/keys