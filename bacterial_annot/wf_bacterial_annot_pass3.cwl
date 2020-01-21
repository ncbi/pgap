#!/usr/bin/env cwl-runner
label: "Bacterial Annotation, pass 3, structural annotation, functional annotation: ab initio GeneMark, by WP, by HMM (second pass)"
cwlVersion: v1.0
class: Workflow
requirements:
    - class: SubworkflowFeatureRequirement
    - class: MultipleInputFeatureRequirement

inputs:
    uniColl_cache:
        type: Directory
    sequence_cache:
        type: Directory
    hmm_aligns:
        type: File
        label: "Map HMM Hits/align"
    prot_aligns:
        type: File
        label: "Filter Protein Alignments I/align"
    annotation:
        type: File
        label: "Resolve Annotation Conflicts/annotation"
    models1:
        type: File
        label: "Run GeneMark Training/models"
    raw_seqs: 
        type: File
        label: #Prepare Unannotated Sequences/raw_seqs"
    thresholds: # ${GP_HOME}/etc/thresholds.xml
        type: File
    naming_sqlite: # /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/home/badrazat/local-install/2018-05-17/third-party/data/BacterialPipeline/uniColl/ver-3.2/naming.sqlite
        type: File
    hmm_params: # Run GeneMark Training/hmm_params (EXTERNAL, put to input/
        type: File
    selenoproteins:  # /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/home/badrazat/local-install/2018-05-17/third-party/data/BacterialPipeline/Selenoproteins/selenoproteins
        type: Directory
    selenocysteines_db:
        type: string
        default: blastdb
    naming_hmms_combined: # ${GP_HOME}/third-party/data/BacterialPipeline/uniColl/ver-3.2/naming_hmms_combined.mft
        type: Directory
    hmms_tab:
        type: File
    wp_hashes: File #    input/wp-hashes.sqlite
    taxon_db: File # input/taxonomy.sqlite3
    genemark_path: Directory
    scatter_gather_nchunks: string
steps:
    Find_Best_Evidence_Alignments:
        label: "Find Best Evidence Alignments"
        run: ../progs/bact_best_evidence_alignments.cwl  
        in:
            annotation: [annotation, models1]
            asn_cache: [uniColl_cache, sequence_cache]  # ${GP_cache_dir},${GP_HOME}/third-party/data/BacterialPipeline/uniColl/ver-3.2/cache
                # type: Directory[]
            align:  [hmm_aligns, prot_aligns] # -input-manifest 
                # type: File[]
                # source: 
                # linkMerge: merge_flattened
            max_overlap:
                default: 120
            output_align_name:
                default: best_aligns.asn
            start_stop_allowance:
                default: 60
            thr: thresholds
            unicoll_sqlite: naming_sqlite
            nogenbank: 
                default: true
        out: [out_align]  # -o
    Run_GeneMark:
        label: "Run GeneMark"
        run: ../progs/genemark.cwl  
        in: # so far, the whole node!
            alignments: Find_Best_Evidence_Alignments/out_align
            annotation: annotation # Resolve Annotation Conflicts/annotation (EXTERNAL, put to input/
            asn_cache: [uniColl_cache, sequence_cache]  # ${GP_cache_dir},${GP_HOME}/third-party/data/BacterialPipeline/uniColl/ver-3.2/cache
                # type: Directory[]
            genemark_path: genemark_path # ${GP_HOME}/third-party/GeneMark 
                # type: Directory
            hmm_params: hmm_params 
            marked_annotation_name:
                default: marked-annotation.asn
            min_seq_len:
                default: 200
            preliminary_models_name: # -out
                default: preliminary-models.asn
            sequences: raw_seqs 
            thr:  thresholds
            tmp_dir_name: 
                default: workdir  
                # type: Directory
            nogenbank: 
                default: true
        out: [marked_annotation, preliminary_models] # all internal!
    Run_GeneMark_Post:
        label: "Run GeneMark (genemark_post)"
        run: ../progs/genemark_post.cwl  
        in: 
            abs_short_model_limit:
                default: 60
            asn_cache: [uniColl_cache, sequence_cache] # ${GP_cache_dir},${GP_HOME}/third-party/data/BacterialPipeline/uniColl/ver-3.2/cache
                # type: Directory[]
            genemark_annot: Run_GeneMark/preliminary_models
            max_overlap:
                default: 120
            max_unannotated_region:
                default: 5000
            models_name: # -out
                default: models.asn
            out_product_ids_name: 
                default: all-proteins.ids
            pre_annot: Run_GeneMark/marked_annotation
            selenocysteines: selenoproteins
            selenocysteines_db: selenocysteines_db
            short_model_limit:
                default: 180
            unicoll_sqlite: naming_sqlite
            nogenbank: 
                default: true
        out: [models] 
    Extract_Model_Proteins:
        label: "Extract Model Proteins"
        run: ../progs/protein_extract.cwl  
        in: 
              input: Run_GeneMark_Post/models
              nogenbank: 
                default: true
        out: [proteins, lds2, seqids]
    Search_Naming_HMMs:
        label: "Search Naming HMMs"
        run: ../task_types/tt_hmmsearch_wnode.cwl  
        in:
              proteins: Extract_Model_Proteins/proteins
              hmm_path: naming_hmms_combined # naming_hmms_combined.mft converted to Directory
              seqids: Extract_Model_Proteins/seqids
              lds2: Extract_Model_Proteins/lds2
              hmms_tab: hmms_tab # goes eventually to -fam parameter
              asn_cache: sequence_cache
              scatter_gather_nchunks: scatter_gather_nchunks
        out:
          [hmm_hits]    
    Assign_Naming_HMM_to_Proteins:
        label: "Assign Naming HMM to Proteins"
        run: ../progs/assign_hmm.cwl  
        in: 
            input: Search_Naming_HMMs/hmm_hits
            db: naming_sqlite
        out: [assignments]
    Name_by_WPs:
        label: "Name by WPs"
        run: ../progs/identify_wp.cwl  
        in:
            wp_hashes: wp_hashes 
            taxon_db: taxon_db
            ifmt:
                default: seq-entries
            lds2: Extract_Model_Proteins/lds2
            proteins: Extract_Model_Proteins/proteins
            sequences: Run_GeneMark_Post/models # -input
            fast:
                default: true
        out: [out_names] # -onames, there is also prot2wp, but it goes only to tax check, which we dropped in the first round
outputs:
    # long output names are preliminary.
    # after the list is complete, drop the long prefixes
    Find_Best_Evidence_Alignments_aligns: 
        # sink: Generate Annotation Reports/cluster_prot_aligns (EXTERNAL, put to output/)
        # sink: Validate Annotation/cluster_best_mft (EXTERNAL, put to output/)
        label: "goes to protein_alignment/Seed Search Compartments/compartments"
        type: File
        outputSource: Find_Best_Evidence_Alignments/out_align
    Run_GeneMark_Post_models:
        type: File
        outputSource: Run_GeneMark_Post/models
    Extract_Model_Proteins_seqids:
        type: File
        outputSource: Extract_Model_Proteins/seqids
    Extract_Model_Proteins_lds2:
        type: File
        outputSource: Extract_Model_Proteins/lds2
    Extract_Model_Proteins_proteins:
        type: File
        outputSource: Extract_Model_Proteins/proteins
    Search_Naming_HMMs_hmm_hits:
        type: File
        outputSource: Search_Naming_HMMs/hmm_hits
    Assign_Naming_HMM_to_Proteins_assignments:
        type: File
        outputSource: Assign_Naming_HMM_to_Proteins/assignments
    Name_by_WPs_names:
        type: File
        outputSource: Name_by_WPs/out_names
        
