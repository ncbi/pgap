#!/usr/bin/env cwl-runner
label: "Bacterial Annotation (two-pass)"
cwlVersion: v1.0
class: Workflow

requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement

inputs:
  asn_cache: Directory
  inseq: File
  hmm_path: Directory
  hmms_tab: File
  uniColl_cache: Directory
  trna_annots: File
  ncrna_annots: File
  nogenbank: boolean
  
  # Cached computational steps
  hmm_hits: File
  
outputs:
  # aligns: 
  #   type: File
  #   outputSource: bacterial_hit_mapping/aligns
  # hmm_hits: 
  #   type: File
  #   outputSource: hmmsearch/hmm_hits
  # strace:
  #   type: File
  #   outputSource: hmmsearch/strace
    
  proteins:
    type: File
    outputSource: protein_extract/proteins
  lds2:
    type: File
    outputSource: protein_extract/lds2
  seqids:
    type: File
    outputSource: protein_extract/seqids

steps:
  gp_getorf:
    run: ../progs/gp_getorf.cwl
    in:
      asn_cache: asn_cache
      input: inseq
    #out: [asncache, outseqs]
    out: [outseqs]

  protein_extract:
    run: ../progs/protein_extract.cwl
    in:
      input: gp_getorf/outseqs
      nogenbank: nogenbank
    out: [proteins, lds2, seqids]

  # Skipped due to compute cost, for now
  # hmmsearch:
  #   run: wf_hmmsearch.cwl
  #   in:
  #     proteins: protein_extract/proteins
  #     hmm_path: hmm_path
  #     seqids: protein_extract/seqids
  #     lds2: protein_extract/lds2
  #     hmms_tab: hmms_tab
  #     asn_cache: gp_getorf/asncache
  #   out:
  #     [hmm_hits]
      #[strace]

  # bacterial_hit_mapping:
  #   run: bacterial_hit_mapping.cwl
  #   in:
  #     #seq_cache: gp_getorf/asncache
  #     seq_cache: asn_cache
  #     unicoll_cache: uniColl_cache
  #     #asn_cache: [gp_getorf/asncache, uniColl_cache]
  #     asn_cache: [asn_cache, uniColl_cache]
  #     hmm_hits: hmm_hits # Should be from hmmsearch
  #     #hmm_hits: hmmsearch/hmm_hits
  #     sequences: gp_getorf/outseqs
  #   out: [asncache, aligns]

  # get_off_frame_orfs:
  #   run: get_off_frame_orfs.cwl
  #   in:
  #     aligns: bacterial_hit_mapping/aligns
  #     seq_entries: gp_getorf/outseqs
  #   out: [prot_ids]
    
