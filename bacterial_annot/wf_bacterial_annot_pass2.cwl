#!/usr/bin/env cwl-runner
label: "Bacterial Annotation, pass 2, blastp-based functional annotation (first pass)"
cwlVersion: v1.2
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
    blastdb:
        label: "Input blastdb databases"
        type: string[]
    blast_rules_db:
        label: "parameter to store the literal 'blast_rules_db'"
        type: string
        default: blast_rules_db
    identification_db_dir:
        label: "Create identification BLASTdb"
        type: Directory
    annotation:
        label: "Get ORFs/outseq"
        type: File
    raw_seqs: 
        label: "Prepare_Unannotated_Sequences/sequences"
        type: File
    plasmids:
        label: "Prepare_Unannotated_Sequences/plasmids"
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
    Separate_Plasmid_ORFs:
        label: "Separate Plasmid ORFs"
        run: ../progs/separate_plasmid_orfs.cwl
        in:
          orf_ids: Remove_off_frame_ORFs/output
          orf_entries: annotation
          raw_seqs: raw_seqs # Prepare_Unannotated_Sequences/sequences
          plasmids: plasmids
        out: [chomosome_orfs, plasmid_orfs]
    Find_Naming_Protein_Hits_for_struct: # this is used now for chromosomes only
        label: "Find Naming Protein Hits for struct" 
        run: ../task_types/tt_blastp_wnode_naming.cwl
        in:
            scatter_gather_nchunks: scatter_gather_nchunks
            ids: 
              source: [Separate_Plasmid_ORFs/chomosome_orfs]
              linkMerge: merge_flattened
            lds2: lds2
            proteins: proteins
            blastdb_dir: identification_db_dir
            blastdb: 
              source: #will this fly?
                - blastdb # Get_Proteins/selected_blastdb
                - blast_rules_db
              linkMerge: merge_flattened
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
                default: 5
            taxid: taxid
            genus_list: genus_list
            blast_hits_cache: 
              source: blast_hits_cache
            blast_type:
              default: 'orf'
            taxon_db: taxon_db
        out: [blast_align] 
    Find_Struct_Protein_Hits_for_Plasmids: 
        label: "Find Struct Protein Hits for Plasmids" # i.e. ORFs
        run: ../task_types/tt_blastp_wnode_struct.cwl
        in:
            scatter_gather_nchunks: scatter_gather_nchunks
            ids: 
              source: [Separate_Plasmid_ORFs/plasmid_orfs]
              linkMerge: merge_flattened
            lds2: lds2
            proteins: proteins
            blastdb_dir: identification_db_dir
            blastdb: # whole naming databases is used for plasmids
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
            # Find_Struct_Protein_Hits_for_Plasmids
            extra_coverage: 
                default: 29
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
                default: 5
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
        run: bacterial_hit_mapping.cwl
        in:
            hmm_hits: 
              source: 
                - Find_Naming_Protein_Hits_for_struct/blast_align
                - Find_Struct_Protein_Hits_for_Plasmids/blast_align
              linkMerge: merge_flattened
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
            outfile:
              default: "mapped-aligns.asn"

            # bogus because requirements from this are imported down
            proteins: proteins
        out: [aligns]
        
        
