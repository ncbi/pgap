#!/usr/bin/env cwl-runner
label: "Bacterial Annotation, pass 1, genemark training, by HMMs (first pass)"
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
  Execute_CRISPRs_annots: File
  Generate_16S_rRNA_Annotation_annotation: File
  Generate_23S_rRNA_Annotation_annotation: File
  Post_process_CMsearch_annotations_annots_5S: File
  thresholds: File
  genemark_path: Directory
  # Cached computational steps
  #hmm_hits: File
outputs:
  outseqs:
    type: File
    outputSource: Get_ORFs/outseqs
  aligns: 
    type: File
    outputSource: Map_HMM_Hits/aligns
  hmm_hits: 
    type: File
    outputSource: Search_All_HMMs_I/hmm_hits
  proteins:
    type: File
    outputSource: Extract_ORF_Proteins/proteins
  lds2:
    type: File
    outputSource: Extract_ORF_Proteins/lds2
  seqids:
    type: File
    outputSource: Extract_ORF_Proteins/seqids
  prot_ids:
    type: File
    outputSource: Get_off_frame_ORFs/prot_ids
  protein_aligns: 
    type: File
    outputSource: Resolve_Annotation_Conflicts/protein_aligns
  annotation: 
    type: File
    outputSource: Resolve_Annotation_Conflicts/annotation
  out_hmm_params: 
    type: File
    outputSource: Run_GeneMark_Training/out_hmm_params
steps:
  Get_ORFs:
    run: ../progs/gp_getorf.cwl
    in:
      asn_cache: asn_cache
      input: inseq
    out: [outseqs]

  Extract_ORF_Proteins:
    run: ../progs/protein_extract.cwl
    in:
      input: Get_ORFs/outseqs
      nogenbank: nogenbank
    out: [proteins, lds2, seqids]

  # Skipped due to compute cost, for now
  Search_All_HMMs_I:
    label: "Search All HMMs I"
    run: ../task_types/tt_hmmsearch_wnode.cwl
    in:
      proteins: Extract_ORF_Proteins/proteins
      hmm_path: hmm_path
      seqids: Extract_ORF_Proteins/seqids
      lds2: Extract_ORF_Proteins/lds2
      hmms_tab: hmms_tab
      asn_cache: asn_cache
    out:
      [hmm_hits]
      #[hmm_hits, jobs, workdir]

  Map_HMM_Hits:
    run: bacterial_hit_mapping.cwl
    in:
      seq_cache: asn_cache
      unicoll_cache: uniColl_cache
      asn_cache: [asn_cache, uniColl_cache]
      # hmm_hits: hmm_hits # Should be from hmmsearch
      hmm_hits: Search_All_HMMs_I/hmm_hits
      sequences: Get_ORFs/outseqs
      ### this guys below not tested yet
      align_fmt: 
         default: seq-align
      expansion_ratio:
         default: 0.0
      no_compart:
         default: true
      nogenbank:
         default: true
    out: [aligns]

  Get_off_frame_ORFs:
    run: get_off_frame_orfs.cwl
    label: "Get_off_frame_ORFs task node"
    in:
      aligns: Map_HMM_Hits/aligns
      seq_entries: Get_ORFs/outseqs
    out: [prot_ids]
  Resolve_Annotation_Conflicts:
    label: "Resolve Annotation Conflicts"
    run: ../progs/bacterial_resolve_conflicts.cwl
    in:
        features: # all external to this node
            - Execute_CRISPRs_annots # Execute CRISPR/annots
            - ncrna_annots # Post-process CMsearch Rfam annotations/annots
            - Generate_16S_rRNA_Annotation_annotation # Generate 16S rRNA Annotation/annotation
            - Generate_23S_rRNA_Annotation_annotation # Generate 23S rRNA Annotation/annotation
            - Post_process_CMsearch_annotations_annots_5S # Post-process CMsearch annotations/annots
            - trna_annots # Run tRNAScan/annot
        # input_annotation: mft not used
        # prot: mft not used
        # mapped-regions: mft not used
        thr: thresholds
        asn_cache: 
            source: [asn_cache]
            linkMerge: merge_flattened
    out: 
        - protein_aligns
        - annotation
 
  Run_GeneMark_Training:
    label: "Run GeneMark Training, genemark"
    run: ../progs/genemark_training.cwl
    in:
        asn_cache: 
            source: [asn_cache, uniColl_cache]
            linkMerge: merge_flattened
        sequences: inseq
        genemark_path: genemark_path # ${GP_HOME}/third-party/GeneMark 
        marked_annotation_name:
                default: marked-annotation.asn
        min_seq_len:
            default: 200
        preliminary_models_name: # -out
            default: preliminary-models.asn
        thr:  thresholds
        tmp_dir_name: 
            default: workdir  
            # type: Directory
        nogenbank: 
            default: true
    out: [out_hmm_params] # export
