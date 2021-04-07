cwlVersion: v1.2
label: "combine_kmer_sqlite"

inputs:
    sqlite1: File
    sqlite2: File
class: Workflow
requirements: 
    - class: MultipleInputFeatureRequirement
steps:
    Combine_kmer_sqlite: # this step does not exist in classic PGAP bacterial kmer graph
        run: ../../combine_kmer_sqlite.cwl
        in:
            kmer_cache_sqlite: 
                source: [sqlite1, sqlite2]
                linkMerge: merge_flattened
        out: [combined_cache_sqlite]

outputs:
    keys:
        type: File
        outputSource: Combine_kmer_sqlite/combined_cache_sqlite