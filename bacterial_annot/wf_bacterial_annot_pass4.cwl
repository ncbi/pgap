#!/usr/bin/env cwl-runner
label: "Bacterial Annotation, pass 4, blastp-based functional annotation (second pass)"
cwlVersion: v1.2
class: Workflow
requirements:
    - class: SubworkflowFeatureRequirement
    - class: MultipleInputFeatureRequirement

inputs:
    scatter_gather_nchunks: 
        type: string
    lds2: # Extract Model Proteins/lds2
        type: File
    proteins: # Extract Model Proteins/proteins
        type: File
    annotation: #  Good, AntiFam filtered annotations
        type: File
    Good_AntiFam_filtered_proteins_gilist: 
        type: File
    sequence_cache:
        type: Directory
    uniColl_cache:
        type: Directory
    naming_sqlite: # see bacterial_annot_pass3
        type: File
    hmm_assignments:  # XML assignments
        type: File
    wp_assignments:  # XML assignments
        type: File
    Extract_Model_Proteins_prot_ids: # pass 3
        type: File
    CDDdata: # ${GP_HOME}/third-party/data/CDD/cdd -
       type: Directory
    CDDdata2: # ${GP_HOME}/third-party/data/cdd_add 
        type: Directory
    thresholds:
        type: File
    defline_cleanup_rules: # defline_cleanup_rules # ${GP_HOME}/etc/product_rules.prt
        type: File
    blast_rules_db: 
        label: "parameter to store the literal 'blast_rules_db'"
        type: string
        default: blast_rules_db
    blastdb:
        label: "Input blastdb databases"
        type: string[]        
    identification_db_dir:
        type: Directory
    taxid:
      type: int
    blast_hits_cache: 
      type: File?
    taxon_db: 
      type: File
    genus_list: 
      type: int[]
steps:
    Find_Naming_Protein_Hits:
        label: "Find Naming Protein Hits"
        run: ../task_types/tt_blastp_wnode_naming.cwl
        in:
            scatter_gather_nchunks: scatter_gather_nchunks
            # files/directories
            ids: 
                source: [Good_AntiFam_filtered_proteins_gilist]
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
            # literal parameters
            affinity: 
                default: subject
            asn_cache: [sequence_cache, uniColl_cache]
            align_filter: 
                default: 'score>0 && pct_identity_gapopen_only > 35' 
            allow_intersection: 
                default: true
            # batch-size:
            #    default: 1
            comp_based_stats:   
                default: F
            compart: 
                default: true
            dbsize: 
                default: '6000000000'
            delay:
                default: 0
            evalue: 
                default: 0.1
            # extra_coverage:  # application default
            max_batch_length: 
                default: 10000
            max_jobs: 
                default: 1
            max_target_seqs: 
                default: 50
            no_merge: 
                default: false
            nogenbank: 
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
              default: 'predicted-protein'
            taxon_db: taxon_db
        out: [blast_align] # does not go out
    Find_best_protein_hits:
        label: "Find best protein hits"
        run: ../progs/align_filter.cwl
        in:
            input: Find_Naming_Protein_Hits/blast_align
            # input: cached_Find_Naming_Protein_Hits # for shortcuts
            asn_cache: [sequence_cache, uniColl_cache]
            filter:
                default: 'subject_coverage >= 10'
            ifmt:
                default: seq-align-set
            nogenbank:
                default: true
        out: [o]
    Assign_Clusters_to_Proteins_sort:
        label: "Assign Clusters to Proteins: pre-sort alignments"
        run: ../progs/align_sort.cwl
        in:
            input: Find_best_protein_hits/o
            ifmt:
                default: seq-align-set
            k:
                default: query,subject,-score,-num_ident,query_align_len,subject_align_len,query_start,subject_start
            limit_mem: 
                default: '13G'
            nogenbank:
                default: true
            # internal: tmp
        out: [output]
    Assign_Clusters_to_Proteins:
        label: "Assign Clusters to Proteins: actual task"
        run: ../progs/assign_cluster.cwl
        in:
            asn_cache: [sequence_cache, uniColl_cache]
            lds2: lds2
            proteins: proteins
            comp_based_stats:
                default: F
            cutoff:
                default: 0.5
            hfmt:
                default: seq-align
            hits: Assign_Clusters_to_Proteins_sort/output
            margin:
                default: 0.05
            namedb_dir: identification_db_dir # NamingDatabase
            namedb:
                default: blast_rules_db
            seg:
                default: no
            sure_cutoff:
                default: 0.15
            task:
                default: blastp
            threshold:
                default: 21
            unicoll_sqlite: naming_sqlite
            word_size:
                default: 6
            nogenbank:
                default: true
        out: [protein_assignments] # xml format does, not go out of the workflow
    Prepare_SPARCLBL_input:
        label: "Prepare SPARCLBL input"
        run: ../progs/prepare_sparclbl_input.cwl
        in:
            other_assignments: 
                source: [Assign_Clusters_to_Proteins/protein_assignments, hmm_assignments, wp_assignments]
                linkMerge: merge_flattened
            input: Extract_Model_Proteins_prot_ids # pass 3
            unicoll_sqlite: naming_sqlite
        out: [prot_ids, precedences] # not go out of the workflow
    Assign_SPARCL_Architecture_Names_to_Proteins_gp_fetch_sequences:
        label: "Assign SPARCL Architecture Names to Proteins"
        run: ../progs/gp_fetch_sequences.cwl
        in:
            # not sure why do we have this in PGAP.
            # asn_cache: [full_id_cache]
            #    linkMerge: merge_flattened
            input: Prepare_SPARCLBL_input/prot_ids
            lds2: lds2
            proteins: proteins
        out: [out_proteins]
    Assign_SPARCL_Architecture_Names_to_Proteins_asn2fasta:
        label: "Assign SPARCL Architecture Names to Proteins"
        run: ../progs/asn2fasta.cwl
        in:
            i: Assign_SPARCL_Architecture_Names_to_Proteins_gp_fetch_sequences/out_proteins
            serial:
                default: binary
            type:   
                default: seq-entry
            prots_only:
                default: true
            fasta_name:
                default: proteins.fa
        out: [fasta]
    Assign_SPARCL_Architecture_Names_to_Proteins_sparclbl:
        label: "Assign SPARCL Architecture Names to Proteins"
        run: ../progs/sparclbl.cwl
        in:
            s: Assign_SPARCL_Architecture_Names_to_Proteins_asn2fasta/fasta
            p: Prepare_SPARCLBL_input/precedences
            m: # number_of_blast_processes
                default: 20 
            n: # max_files_per_proc
                default: 500
            b: CDDdata
            d: CDDdata2
            x:
                default: 1
        out: [protein_assignments] # not go out of the workflow
    Add_Names_to_Proteins:
        label: "Add Names to Proteins"
        run: ../progs/add_prot_names_to_annot.cwl
        in:
            # let's ditch full_id_cache for now
            # asn_cache: [sequence_cache, full_id_cache]
            asn_cache: 
                source: [sequence_cache]
                linkMerge: merge_flattened
            defline_cleanup_rules: defline_cleanup_rules # ${GP_HOME}/etc/product_rules.prt
            proteins: 
                - Assign_Clusters_to_Proteins/protein_assignments
                - Assign_SPARCL_Architecture_Names_to_Proteins_sparclbl/protein_assignments
                - hmm_assignments
                - wp_assignments
            input: annotation #  Good, AntiFam filtered annotations
            unicoll_sqlite: naming_sqlite
            nogenbank:
                default: true
            submission_mode_genbank:
                default: true
        out: [out_annotation]
    Bacterial_Annot_Filter:
        label: "Bacterial Annot Filter"
        run: ../progs/bact_annot_filter.cwl
        in:
            abs_short_model_limit:
                default: 60
            asn_cache: 
                source: [sequence_cache]
                linkMerge: merge_flattened
            input: 
                source: [Add_Names_to_Proteins/out_annotation]
                linkMerge: merge_flattened
            long_model_limit:
                default: 1000000 # 1,000,000
            max_overlap:
                default: 120
            max_unannotated_region:
                default: 5000
            short_model_limit:
                default: 180
            thr: thresholds
            nogebank:
                default: true
        out:
            - out_annotation # this goes out
            # - good_proteins # internal to taxcheck
    # this is later.
    # WP_Tax_Check:
    #     label: "WP Tax Check"
    #    run: ../progs/wp_taxcheck.cwl    
    #    in:
    #        __input__: Bacterial_Annot_Filter/good_proteins
            
outputs:
    out_annotation: 
        type: File
        outputSource: Bacterial_Annot_Filter/out_annotation
