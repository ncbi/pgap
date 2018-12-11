class: Workflow
cwlVersion: v1.0
id: vecscreen
label: vecscreen
requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
inputs:
  - id: adaptor_fasta
    type: File
  - id: contam_in_prok_blastdb_dir
    type: Directory
  - id: contig_fasta
    type: File
steps:
  default_plane:
    run: ../vecscreen/foreign_screening.cwl
    label: foreign_screening
    doc: >-
      corresponds to part of default plane in foreign contamination screening
      graph of classic Gpipe
      it does bunch of generic things so it has to be first
    in:
      adaptor_fasta: adaptor_fasta
      contig_fasta: contig_fasta
    out: [adaptor_blastdb_dir, contig_ids_out, feats, hits, out_cache_dir]
  bacterial_screening:
    run: ../vecscreen/bacterial_screening.cwl
    label: bacterial_screening
    doc: >-
      corresponds to bacterial_screening plane in in foreign contamination
      screening graph of classic Gpipe
    in:
      asn_cache: default_plane/out_cache_dir
      contam_in_prok_blastdb_dir: contam_in_prok_blastdb_dir
      contig_gilist: default_plane/contig_ids_out
    out: [blast_align,  feats, filtered_align]
  FSCR_Calls_first_pass:
    run: ../task_types/tt_fscr_calls_pass1.cwl
    in:
        contigs: default_plane/contig_ids_out
        input: [bacterial_screening/feats, default_plane/feats]
        asn_cache: default_plane/out_cache_dir 
    out: [calls]
    doc: >-
      corresponds to part of default plane in foreign contamination screening
      graph of classic Gpipe
      it should go _after_ all screenings, so it goes to a separate degenerate 
      "plane" = "task" here
      
outputs:
  out_cache_dir:
    type: Directory
    outputSource: default_plane/out_cache_dir
  contamination_feats:
    type: File
    outputSource: bacterial_screening/feats
  foreign_feats:
    type: File
    outputSource: default_plane/feats
  blast_align:
    type: File
    outputSource: bacterial_screening/blast_align
  filtered_align:
    type: File
    outputSource: bacterial_screening/filtered_align
  hits: 
    type: File
    outputSource: default_plane/hits
  adaptor_blastdb_dir:
    type: Directory
    outputSource: default_plane/adaptor_blastdb_dir
  calls:
    type: File
    outputSource: FSCR_Calls_first_pass/calls

