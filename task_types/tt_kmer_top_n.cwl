#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: Workflow # task type
# kmer_top_identification -N 20 -distances-manifest kmer_top_n.455674842/inp/distances.mft \
#    -omatches kmer_top_n.455674842/tmp/matches \
#    -oxml kmer_top_n.455674842/out/top_distances.xml \
#    -threshold 0.8
#
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
        run: ../progs/kmer_top_identification.cwl
        in:
            kmer_cache_sqlite: kmer_cache_sqlite
            N:    
                default: 40
            distances: distances
            threshold: 
                default: 0.995
            minN:
                default: 5
            strict:
                default: true
        out: [top_distances, matches]
