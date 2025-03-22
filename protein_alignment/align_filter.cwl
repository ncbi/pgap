#!/usr/bin/env cwl-runner

cwlVersion: v1.2
class: CommandLineTool

label: "Filter Protein Alignments"


requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.asn_cache)
        writable: False
      - entry: $(inputs.uniColl_asn_cache)
        writable: False
    
baseCommand: align_filter

arguments: [ -filter, "query_subject_overlap < 10 AND pct_identity_gapopen_only >= 50 AND NOT (pct_coverage < 20 and (query_entropy < 0.3 OR query_seg_pct > 60)) AND ( (query_start<=20 AND SUB(query_length, query_end)<=20) OR pct_identity_gapopen_only >= 60 ) AND (SUB(subject_end, subject_start) > 90 OR SUB(subject_end, subject_start) > MUL(query_length,1.5) OR num_ident >=60) AND (query_length > 30 OR (pct_identity_gap >= 80 AND SUB(subject_end, subject_start) >= MUL(query_length,2.4)))", -ifmt, seq-align, -nogenbank]
inputs:
  asn_cache:
    type: Directory
    inputBinding:
      prefix: -asn-cache
      valueFrom: $(inputs.asn_cache.basename),$(inputs.uniColl_asn_cache.basename)
  uniColl_asn_cache:
    type: Directory
  file_in:
    type: File
    inputBinding:
      prefix: -input
  output:
    type: string?
    default: align.asn   
    inputBinding:
      prefix: -o
  output_non_match:
    type: string?
    default: align-nomatch.asn   
    inputBinding:
      prefix: -non-match-output

outputs:
  align:
    type: File
    outputBinding:
      glob: $(inputs.output)
  align_non_match:
    type: File
    outputBinding:
      glob: $(inputs.output_non_match)
