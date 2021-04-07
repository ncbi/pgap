cwlVersion: v1.2
label: "bacterial_hit_mapping"

class: CommandLineTool
requirements:
  - class: ResourceRequirement
    ramMax: 4000
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
     - entryname: aligns.mft
       entry: ${var blob = '# aligns.mft created for bacterial_hit_mapping from input hmm_hits Array of Files\n'; for (var i = 0; i < inputs.hmm_hits.length; i++) { blob += inputs.hmm_hits[i].path + '\n'; } return blob; }

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
    type: File[]
  hmm_hits_mft:
    type: string?
    default: aligns.mft
    inputBinding:
      prefix: -aligns-manifest
  sequences:
    type: File
    inputBinding:
      prefix: -sequences
  outfile:
    type: string
    inputBinding:
      prefix: -o
  # bogus:
  proteins: File?
outputs:
  aligns:
    type: File
    outputBinding:
      glob: $(inputs.outfile)
