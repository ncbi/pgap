cwlVersion: v1.0
label: "Map HMM Hits"
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/pgap:latest

requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.seq_cache)
        writable: False
      - entry: $(inputs.unicoll_cache)
        writable: False
    

#bacterial_hit_mapping -align-fmt seq-align -aligns-manifest hits.mft -asn-cache sequence_cache,cache_uniColl -expansion-ratio 0.0 -o mapped-hmm-hits.asn -sequences-manifest annotation.mft -no-compart -nogenbank
baseCommand: bacterial_hit_mapping
arguments: [ -align-fmt, seq-align, -expansion-ratio, "0.0", -no-compart, -nogenbank ]
inputs:
  seq_cache:
    type: Directory
  unicoll_cache:
    type: Directory
  asn_cache:
    type: Directory[]
    inputBinding:
      prefix: -asn-cache
      itemSeparator: ","
  hmm_hits:
    type: File
    inputBinding:
      prefix: -aligns
  sequences:
    type: File
    inputBinding:
      prefix: -sequences
  outfile:
    type: string?
    default: "mapped-hmm-hits.asn"
    inputBinding:
      prefix: -o
outputs:
  asncache:
    type: Directory
    outputBinding:
      glob: $(inputs.seq_cache.basename)
  aligns:
    type: File
    outputBinding:
      glob: $(inputs.outfile)
