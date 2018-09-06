#!/usr/bin/env cwl-runner
label: "spurious_annot pass2"
cwlVersion: v1.0
class: Workflow    
requirements:
    - class: SubworkflowFeatureRequirement
    
inputs:
  Extract_Model_Proteins_proteins: File
  Extract_Model_Proteins_seqids: File
  Extract_Model_Proteins_lds2: File
  AntiFamLib: Directory
  sequence_cache: Directory
  Run_GeneMark_models: File
  scatter_gather_nchunks: string
outputs:
  AntiFam_tainted_proteins___oseqids:
    type: File
    outputSource: AntiFam_tainted_proteins/oseqids
  Good_AntiFam_filtered_annotations_out:
    type: File
    outputSource: Good_AntiFam_filtered_annotations/out_annotation
  Good_AntiFam_filtered_proteins_output:
    type: File
    outputSource: Good_AntiFam_filtered_proteins/output
  
steps:
    Search_AntiFam:
        label: "Search AntiFam"
        run: ../task_types/tt_hmmsearch_wnode.cwl  
        in:
            proteins: Extract_Model_Proteins_proteins
            hmm_path: AntiFamLib
            seqids: Extract_Model_Proteins_seqids
            lds2: Extract_Model_Proteins_lds2
            # hmms_tab: hmms_tab # goes eventually to -fam parameter -fam is empty here
            asn_cache: sequence_cache
            scatter_gather_nchunks: scatter_gather_nchunks
        out: [hmm_hits]
    AntiFam_tainted_proteins:
        label: "AntiFam tainted proteins"
        run: ../progs/reduce.cwl
        in:
            aligns: Search_AntiFam/hmm_hits
        out: [oseqids] # this goes out as well
    Good_AntiFam_filtered_proteins:
        label: "Good, AntiFam filtered proteins"
        run: ../progs/set_operation.cwl
        in:
            A: 
                source: [Extract_Model_Proteins_seqids]
                linkMerge: merge_flattened
            B: 
                source: [AntiFam_tainted_proteins/oseqids]
                linkMerge: merge_flattened
            operation:
                default: '-' # subracts B from A
        out: [output] 
    Good_AntiFam_filtered_annotations:
        label: "Good, AntiFam filtered annotations"
        run: ../progs/bact_filter_preserved.cwl
        in:
            # Run GeneMark 	bacterial_annot 	models 	ASNB_SEQ_ENTRY 	annotation
            annotation: Run_GeneMark_models # -input
            ifmt:  # -ifmt
                default: seq-entry
            # Good, AntiFam filtered proteins 	spurious_annot 	gilist 	SEQID_LIST 	only_those_ids
            only_those_ids: Good_AntiFam_filtered_proteins/output # -only-those-ids
            nogenbank:
                default: true
        out: [out_annotation] # goes out -o
        
            
