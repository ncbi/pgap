#!/usr/bin/env cwl-runner
label: spurious_annot
cwlVersion: v1.0
class: Workflow    
requirements:
    - class: SubworkflowFeatureRequirement
    
inputs:
  Extract_ORF_Proteins_proteins: File
  Extract_ORF_Proteins_seqids: File
  Extract_ORF_Proteins_lds2: File
  AntiFamLib: Directory
  sequence_cache: Directory
  scatter_gather_nchunks: string
outputs:
  AntiFam_tainted_proteins_I___oseqids:
    type: File
    outputSource: AntiFam_tainted_proteins_I/oseqids
  
steps:
    Search_AntiFam_I:
        label: "Search AntiFam I"
        run: ../task_types/tt_hmmsearch_wnode.cwl  
        in:
            proteins: Extract_ORF_Proteins_proteins
            hmm_path: AntiFamLib
            seqids: Extract_ORF_Proteins_seqids
            lds2: Extract_ORF_Proteins_lds2
            # hmms_tab: hmms_tab # goes eventually to -fam parameter -fam is empty here
            asn_cache: sequence_cache
            scatter_gather_nchunks: scatter_gather_nchunks
        out: [hmm_hits]
    AntiFam_tainted_proteins_I:
        label: "AntiFam tainted proteins I"
        run: ../progs/reduce.cwl
        in:
            aligns: Search_AntiFam_I/hmm_hits
        out: [oseqids] # this goes out as well
    #### this node does nothing
    # Good,_AntiFam_filtered_proteins_I:
        # label: "Good, AntiFam filtered proteins I"
        # run: ../progs/set_operation.cwl
        # in:
            # A: 
                # source: [Extract_ORF_Proteins_seqids]
                # linkMerge: merge_flattened
            # B: 
                # source: [AntiFam_tainted_proteins_I/seqids]
                # linkMerge: merge_flattened
            # operation:
                # default: '-' # subracts B from A
        # out: [output] # does not go out
