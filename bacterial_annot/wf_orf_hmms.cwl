#!/usr/bin/env cwl-runner
label: "Bacterial Annotation, pass 1, genemark training, by HMMs (first pass)"
cwlVersion: v1.2
class: Workflow

requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement

inputs:
  # control flow:
  go: 
        type: boolean[]
        
  # inputs from refdata:
  hmm_path: Directory
  hmms_tab: File
  uniColl_cache: Directory
  
  # inputs from other flows:
  asn_cache: Directory
  inseq: File
  # 'Good ab initio annotations':
  annotation: File
  
  # algorithmic paramters:
  nogenbank: boolean
  scatter_gather_nchunks: string
  
outputs:
  outseqs:
    type: File
    outputSource: Get_ORFs/outseqs
  aligns: 
    type: File
    outputSource: Map_HMM_Hits/aligns
  hmm_hits: 
    type: File
    outputSource: Search_All_HMMs/hmm_hits
  proteins:
    type: File
    outputSource: Extract_All_ORF_Proteins/proteins
  lds2:
    type: File
    outputSource: Extract_All_ORF_Proteins/lds2
  seqids:
    type: File
    outputSource: Extract_All_ORF_Proteins/seqids
  prot_ids:
    type: File
    outputSource: Get_off_frame_ORFs/prot_ids
    
steps:
  Get_ORFs:
    run: ../progs/gp_getorf.cwl
    in:
      asn_cache: asn_cache
      input: inseq
    out: [outseqs]
    
  Extract_All_ORF_Proteins:
    run: ../progs/protein_extract.cwl
    in:
      input: Get_ORFs/outseqs
      nogenbank: nogenbank
    out: [proteins, lds2, seqids]
    
  
  Filter_ORFs:
    run: ../progs/bact_filter_orfs.cwl
    in:
      models: annotation
      orfs: Get_ORFs/outseqs
      asn_cache: asn_cache
    out: [accept]

  Extract_Accepted_ORF_Proteins:
    run: ../progs/protein_extract.cwl
    in:
      input: Filter_ORFs/accept
      nogenbank: nogenbank
    out: [proteins, lds2, seqids]

  # Skipped due to compute cost, for now
  Search_All_HMMs:
    label: "Search All HMMs"
    run: ../task_types/tt_hmmsearch_wnode.cwl
    in:
      proteins: Extract_Accepted_ORF_Proteins/proteins
      hmm_path: hmm_path
      seqids: Extract_Accepted_ORF_Proteins/seqids
      lds2: Extract_Accepted_ORF_Proteins/lds2
      hmms_tab: hmms_tab
      asn_cache: asn_cache
      scatter_gather_nchunks: scatter_gather_nchunks
    out: [hmm_hits]

  Map_HMM_Hits:
    run: ../bacterial_annot/bacterial_hit_mapping.cwl
    in:
      seq_cache: asn_cache
      unicoll_cache: uniColl_cache
      asn_cache: [asn_cache, uniColl_cache]
      # hmm_hits: hmm_hits # Should be from hmmsearch
      hmm_hits: 
        source: [Search_All_HMMs/hmm_hits]
        linkMerge: merge_flattened
      sequences: Filter_ORFs/accept
      ### this guys below not tested yet
      align_fmt: 
        default: seq-align
      expansion_ratio:
        default: 0.0
      no_compart:
        default: true
      nogenbank:
        default: true
      outfile:
        default: "mapped-hmm-hits.asn"
         
    out: [aligns]

  Get_off_frame_ORFs:
    run: get_off_frame_orfs.cwl
    label: "Get_off_frame_ORFs task node"
    in:
      aligns: Map_HMM_Hits/aligns
      seq_entries: Get_ORFs/outseqs
    out: [prot_ids]
    

    
  
