#!/usr/bin/env cwl-runner
label: "Bacterial Annotation, ab initio (first pass) searched against AntiFam"
cwlVersion: v1.2
class: Workflow
requirements:
    - class: SubworkflowFeatureRequirement
    - class: MultipleInputFeatureRequirement

inputs:
    # refdata inputs:
    
    AntiFamLib:
        type: Directory
        
    # inputs from other workflows:
    sequence_cache:
        type: Directory
    models1:
        type: File
        
    # algorhithmic parameters:
    scatter_gather_nchunks: string

outputs:
    out_annotation:
        type: File
        outputSource: Good_ab_initio_annotations/out_annotation
    
steps:
    Extract_ab_initio_Proteins:
        label: "Extract ab initio Proteins"
        run: ../progs/protein_extract.cwl  
        in: 
              input: models1
              nogenbank: 
                default: true
        out: [proteins, lds2, seqids]
    Search_ab_initio_for_AntiFam:
        label: "Search ab initio for AntiFam"
        run: ../task_types/tt_hmmsearch_wnode.cwl  
        in:
            # this comes always with lds2. LDS2 refers to proteins
            proteins: Extract_ab_initio_Proteins/proteins
            hmm_path: AntiFamLib
            seqids: Extract_ab_initio_Proteins/seqids
            lds2: Extract_ab_initio_Proteins/lds2
            # hmms_tab: hmms_tab # goes eventually to -fam parameter -fam is empty here
            asn_cache: sequence_cache
            scatter_gather_nchunks: scatter_gather_nchunks
        out: [hmm_hits]
    ab_initio_AntiFam_tainted_proteins:
        label: "ab initio AntiFam tainted proteins"
        run: ../progs/reduce.cwl
        in:
            aligns: Search_ab_initio_for_AntiFam/hmm_hits
        out: [oseqids] 
    Good_ab_initio_proteins:
        label: "Good ab initio proteins"
        run: ../progs/set_operation.cwl
        in:
            A: 
                source: [Extract_ab_initio_Proteins/seqids]
                linkMerge: merge_flattened
            B: 
                source: [ab_initio_AntiFam_tainted_proteins/oseqids]
                linkMerge: merge_flattened
            operation:
                default: '-' # subracts B from A
        out: [output] 
    Good_ab_initio_annotations:
        label: "Good ab initio annotations"
        run: ../progs/bact_filter_preserved.cwl
        in:
            annotation: models1 
            ifmt:  
                default: seq-entry
            only_those_ids: Good_ab_initio_proteins/output 
            nogenbank:
                default: true
        out: [out_annotation] # goes out -o
        
