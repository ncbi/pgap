cwlVersion: v1.0
label: "Map HMM Hits"
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest

#bacterial_hit_mapping -align-fmt seq-align -aligns-manifest hits.mft -asn-cache sequence_cache,cache_uniColl -expansion-ratio 0.0 -o mapped-hmm-hits.asn -sequences-manifest annotation.mft -no-compart -nogenbank
baseCommand: bacterial_hit_mapping
inputs:
  align_fmt:
    type: string
    inputBinding:
      prefix: -align-fmt
  expansion_ratio:
    type: float
    inputBinding:
      prefix: -expansion-ratio
  no_compart:
    type: boolean
    inputBinding:
      prefix: -no-compart
  nogenbank:
    type: boolean
    inputBinding:
      prefix: -nogenbank
  seq_cache:
    type: Directory?
  unicoll_cache:
    type: Directory?
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
  # bogus:
  proteins: File?
outputs:
  aligns:
    type: File
    outputBinding:
      glob: $(inputs.outfile)
