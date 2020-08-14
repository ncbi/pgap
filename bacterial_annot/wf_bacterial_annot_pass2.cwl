#!/usr/bin/env cwl-runner
label: "Bacterial Annotation, pass 2, blastp-based functional annotation (first pass)"
cwlVersion: v1.0
class: Workflow
requirements:
    - class: SubworkflowFeatureRequirement
    - class: MultipleInputFeatureRequirement

inputs:
    scatter_gather_nchunks: 
        type: string
    # This LDS2 resource needs to be fixed by removing absolute path from files
    lds2: 
        label: "Extract ORF Proteins/lds2"
        type: File
    # therefore it should always come with original ASN.1 file with seq-entries
    proteins: 
        label: "Extract ORF Proteins/proteins"
        type: File
    prot_ids_A: 
        label: "Extract ORF Proteins/prot_ids"
        type: File
    prot_ids_B1: 
        label: "Get off-frame ORFs/prot_ids"
        type: File
    prot_ids_B2: 
        label: "AntiFam tainted proteins I/oseqids"
        type: File
    blast_rules_db_dir: 
        label: "Get BLAST Rules db const"
        type: Directory
    blast_rules_db: 
        label: "Name of blast_rules_db"
        type: string
    identification_db_dir:
        label: "Create identification BLASTdb"
        type: Directory
    annotation:
        label: "Get ORFs/outseq"
        type: File
    sequence_cache: 
        type: Directory
    # cluster_blastp_wnode_output: # shortcut to bypass cluster_blastp
    #    type: Directory
    unicoll_cache: 
        type: Directory
    taxid:
      type: int
    blast_hits_cache: 
      type: File?
    taxon_db: 
      type: File
    genus_list: 
      type: int[]
outputs:
    aligns: 
        label: "goes to protein_alignment/Seed Search Compartments/compartments"
        type: File
        outputSource: Map_Naming_Hits/aligns
        
steps:
    Remove_off_frame_ORFs: 
        label: "Remove off-frame ORFs"
        run: ../progs/set_operation.cwl  # validated
        in:
            A: 
                source: [prot_ids_A]
                linkMerge: merge_flattened
            B: 
                source: [prot_ids_B1, prot_ids_B2]
                linkMerge: merge_flattened
            operation:
                default: '-' # subracts B from A
        out: [output] # does not go out
        
    Find_Naming_Protein_Hits_for_struct: # 30 minutes
        label: "Find Naming Protein Hits for struct"
        run: ../task_types/tt_blastp_wnode_naming.cwl
        in:
            scatter_gather_nchunks: scatter_gather_nchunks
            ids: 
                source: [Remove_off_frame_ORFs/output]
                linkMerge: merge_flattened
            lds2: lds2
            proteins: proteins
            blastdb_dir: 
                # source: [blast_rules_db_dir] # test only: for testing InitialWorkDirRequirement for Directory[] case
                source: [blast_rules_db_dir, identification_db_dir] # production
                linkMerge: merge_flattened
            blastdb:
                default: [blastdb, blast_rules_db]
            # cluster_blastp_wnode_output: cluster_blastp_wnode_output # shortcut
            affinity: 
                default: subject
            asn_cache: [sequence_cache, unicoll_cache]
            max_batch_length: 
                default: 10000
            nogenbank: 
                default: true
            align_filter: 
                default: 'score>0 && pct_identity_gapopen_only > 35' 
            allow_intersection: 
                default: false
            comp_based_stats:   
                default: F
            compart: 
                default: false
            dbsize: 
                default: '6000000000'
            evalue: 
                default: 0.1
            extra_coverage: 
                default: 20
            max_jobs: 
                default: 1
            max_target_seqs: 
                default: 50
            no_merge: 
                default: true
            ofmt: 
                default: asn-binary
            seg: 
                default:  '30 2.2 2.5'
            soft_masking:
                default: 'yes'
            threshold: 
                default: 21
            top_by_score: 
                default: 10
            word_size: 
                default: 6
            taxid: taxid
            genus_list: genus_list
            blast_hits_cache: 
              source: blast_hits_cache
            blast_type:
              default: 'orf'
            taxon_db: taxon_db
        out: [blast_align] 
    Map_Naming_Hits: 
        label: "Map Naming Hits"
        run: ../bacterial_annot/bacterial_hit_mapping.cwl
        in:
            hmm_hits: Find_Naming_Protein_Hits_for_struct/blast_align
            sequences: annotation
            align_fmt:
                default: seq-align-set
            asn_cache: [sequence_cache, unicoll_cache]
            expansion_ratio:
                default: 1.1
            nogenbank:
                default: true
            no_compart:
                default: false
            # bogus because requirements from this are imported down
            proteins: proteins
        out: [aligns]
        
        
