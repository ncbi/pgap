#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

label: Seed Search Compartments, execute"

hints:

requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.asn_cache)
        writable: False
      - entry: $(inputs.uniColl_asn_cache)
        writable: False
    
baseCommand: prosplign_wnode

arguments: [ -compartment_penalty, "0.10", -cut_flank_partial_codons, "true", -cut_flanks_with_posit_drop, "true", -cut_flanks_with_posit_dropoff, "40", -cut_flanks_with_posit_gap_ratio, "18", -cut_flanks_with_posit_max_len, "48", -cut_flanks_with_posit_window, "150", -fill_holes, "true", -flank_positives, "49", -frameshift_opening, "30", -gap_extension, "1", -gap_opening, "10", -intron_AT, "25", -intron_GC, "20", -intron_GT, "15", -intron_non_consensus, "34", -inverted_intron_extension, "1000", -max_bad_len, "45", -max_extent, "100", -max_intron, "100", -max_overlap, "60", -maximize, coverage, -min-jobs, "5", -min_compartment_idty, "0.05", -min_exon_ident, "30", -min_exon_positives, "55", -min_flanking_exon_len, "41", -min_good_len, "41", -min_intron_len, "30", -min_positives, "15", -min_singleton_idty, "0.05", -score_matrix, BLOSUM62, -start_bonus, "8", -stop_bonus, "8", -total_positives, "55", -allow_alt_starts, -no_introns, -nogenbank ]

inputs:
  asn_cache:
    type: Directory
    inputBinding:
      prefix: -asn-cache
      valueFrom: $(inputs.asn_cache.basename),$(inputs.uniColl_asn_cache.basename)
  uniColl_asn_cache:
    type: Directory
  input_jobs:
    type: File
    inputBinding:
      prefix: -input-jobs
  asn:
    type: File
    inputBinding:
      prefix: -input-file
  output_dir:
    type: string?
    default: output
    inputBinding:
      prefix: -O
      
outputs:
  outdir:
    type: Directory
    outputBinding:
      glob: $(inputs.output_dir)
