cwlVersion: v1.0 
label: "kmer_top_identification.cwl"
class: Workflow
inputs:
    kmer_cache_sqlite: File
    distances: File
outputs:
    matches:
        type: File
        outputSource: kmer_top_identification/matches
    top_distances:
        type: File
        outputSource: kmer_top_identification/top_distances
steps:
    kmer_top_identification:
        run: ../../kmer_top_identification.cwl
        in:
            kmer_cache_sqlite: kmer_cache_sqlite
            N:    
                default: 20
            distances: distances
            threshold: 
                default: 0.8
        out: [top_distances, matches]

