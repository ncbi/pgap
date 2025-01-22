#!/usr/bin/env cwl-runner

label: "PGAP Pipeline"
cwlVersion: v1.2
class: Workflow
doc: PGAP pipeline for external usage, powered via containers

requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: LoadListingRequirement
    loadListing: deep_listing
  - class: NetworkAccess
    networkAccess: true
inputs:
    #
    # User specific input
    #
    go: 
        type: boolean[]
    entries: File?
    seq_submit: File?
    taxid: int
    gc_assm_name: string
    locus_tag_prefix: string?
    dbname: string?
    report_usage: boolean

    #
    # User independent, static input
    #
    scatter_gather_nchunks:
        type: string
        default: '1'
    supplemental_data:
        type: Directory
    blast_hits_cache_data:
        type: Directory?
    submol_block_json: File
    ignore_all_errors: boolean?
    contact_as_author_possible: boolean?
    xpath_fail_initial_asndisc: 
        type: string?
        doc: 'The default: setting is for standard call of pgap.cwl (for example, from pgap.py)'
        default: //*[@severity="FATAL"]
    xpath_fail_initial_asnvalidate: 
        type: string?
        doc: 'The default: setting is for standard call of pgap.cwl (for example, from pgap.py)'
        default: >
            //*[
                ( @severity="ERROR" or @severity="REJECT" )
                and not(contains(@code, "GENERIC_MissingPubRequirement")) 
                and not(contains(@code, "SEQ_DESCR_ChromosomeLocation")) 
                and not(contains(@code, "SEQ_DESCR_MissingLineage")) 
                and not(contains(@code, "SEQ_DESCR_NoTaxonID")) 
                and not(contains(@code, "SEQ_DESCR_OrganismIsUndefinedSpecies"))
                and not(contains(@code, "SEQ_DESCR_StrainWithEnvironSample"))
                and not(contains(@code, "SEQ_DESCR_BacteriaMissingSourceQualifier"))
                and not(contains(@code, "SEQ_DESCR_UnwantedCompleteFlag")) 
                and not(contains(@code, "SEQ_FEAT_BadCharInAuthorLastName")) 
                and not(contains(@code, "SEQ_FEAT_ShortIntron")) 
                and not(contains(@code, "SEQ_INST_InternalNsInSeqRaw")) 
                and not(contains(@code, "SEQ_INST_ProteinsHaveGeneralID")) 
                and not(contains(@code, "SEQ_PKG_NucProtProblem")) 
                and not(contains(@code, "SEQ_PKG_ComponentMissingTitle")) 
            ]
    xpath_fail_final_asndisc: 
        type: string?
        doc: 'The default: setting is for standard call of pgap.cwl (for example, from pgap.py)'
        default: //*[@severity="FATAL"]
    xpath_fail_final_asnvalidate: 
        type: string?
        doc: 'The default: setting is for standard call of pgap.cwl (for example, from pgap.py)'
        default: >
                //*[( @severity="ERROR" or @severity="REJECT" )
                    and not(contains(@code, "GENERIC_MissingPubRequirement")) 
                    and not(contains(@code, "SEQ_DESCR_ChromosomeLocation")) 
                    and not(contains(@code, "SEQ_DESCR_MissingLineage")) 
                    and not(contains(@code, "SEQ_DESCR_NoTaxonID")) 
                    and not(contains(@code, "SEQ_DESCR_OrganismIsUndefinedSpecies"))
                    and not(contains(@code, "SEQ_DESCR_StrainWithEnvironSample"))
                    and not(contains(@code, "SEQ_DESCR_BacteriaMissingSourceQualifier"))
                    and not(contains(@code, "SEQ_DESCR_UnwantedCompleteFlag")) 
                    and not(contains(@code, "SEQ_FEAT_BadCharInAuthorLastName")) 
                    and not(contains(@code, "SEQ_FEAT_ShortIntron")) 
                    and not(contains(@code, "SEQ_INST_InternalNsInSeqRaw")) 
                    and not(contains(@code, "SEQ_INST_ProteinsHaveGeneralID")) 
                    and not(contains(@code, "SEQ_PKG_ComponentMissingTitle")) 
                    and not(contains(@code, "SEQ_PKG_NucProtProblem")) 
                ]
    no_internet:
      type: boolean?
    make_uuid:
      type: boolean?
      default: true
    uuid_in:
      type: File?
    
steps:
  ping_start:
    run: progs/pinger.cwl
    in:
      report_usage: report_usage
      make_uuid: make_uuid
      uuid_in: uuid_in
      state:
        default: "start"
      workflow:
        default: "pgap"
      instring: gc_assm_name
    out: [stdout, outstring, uuid_out]

  passdata:
    in:
      data: supplemental_data
    run: expr/supplemental_data_split_dir.cwl
    out:
      - 5s_model_path
      - 16s_model_path
      - 23s_model_path
      - AntiFamLib
      - all_order_specific_blastdb_file
      - asn2pas_xsl
      - identification_db_dir
      - CDDdata2
      - CDDdata
      - checkm_data_path
      - defline_cleanup_rules
      - filter_for_raw_checkm
      - gc_cache
      - gene_master_ini
      - hmm_path
      - hmms_tab
      - naming_hmms_combined
      - naming_hmms_tab
      - naming_sqlite
      - package_versions
      - rfam_amendments
      - rfam_model_path
      - rfam_stockholm
      - selenoproteins
      - species_genome_size
      - taxon_db
      - thresholds
      - uniColl_cache
      - uniColl_nuc_cache
      - univ_prot_xml
      - val_res_den_xml
      - wp_hashes
  # 
  # massage passdata output here
  #
  Get_Order_Specific_Strings:
    label: "Get List of Order Specific Databases in the form of string[]"
    run: progs/file2basenames.cwl
    in: 
      input: passdata/all_order_specific_blastdb_file
    out: [values]
  log_package_versions:
    run: progs/catlog.cwl
    in:
      input: 
        source: 
          - passdata/package_versions
        linkMerge: merge_flattened
    out: []
  blast_hits_cache_data_split_dir:
    in:
      data: blast_hits_cache_data
    run: expr/blast_hits_cache_data_split_dir.cwl
    out:
      - blast_hits_cache
      - genus_list
  genus_list_file2ints:
    run: progs/file2ints.cwl
    in:
      input: blast_hits_cache_data_split_dir/genus_list
    out: [values]
  # end of massaging passdata output
  genomic_source: # PLANE
    run: genomic_source/wf_genomic_source_asn.cwl
    in:
      entries: entries
      seq_submit: seq_submit
      # taxid: taxid
      gc_assm_name: ping_start/outstring
      taxon_db: passdata/taxon_db
    out: [gencoll_asn, seqid_list, stats_report, asncache, ids_out, submit_block_template, order]
  #
  #  Pseudo plane "default 1"
  #
  Prepare_Unannotated_Sequences: # ORIGINAL TASK NAME: Prepare Unannotated Sequences # default 1
    label: "Prepare Unannotated Sequences"
    run: bacterial_prepare_unannotated.cwl
    in:
      asn_cache: genomic_source/asncache
      gc_assembly: genomic_source/gencoll_asn
      ids: genomic_source/seqid_list
      submit_block: genomic_source/submit_block_template
      taxon_db: passdata/taxon_db
      no_internet: no_internet
    out: [master_desc, sequences, plasmids]
  Prepare_Unannotated_Sequences_pgapx_input_check:
        run: progs/pgapx_input_check.cwl
        in:  
            input: Prepare_Unannotated_Sequences/sequences
            max_size: { default: 15000000 }
            min_size: { default: 300 }
            species_genome_size: passdata/species_genome_size
            taxon_db: passdata/taxon_db
            ignore_all_errors: ignore_all_errors
        out: []
  Prepare_Unannotated_Sequences_text:
        run: progs/asn_translator.cwl
        in: 
            input: Prepare_Unannotated_Sequences/sequences
            output_output: {default: 'sequences.text.asn'}
        out: [output]
  Prepare_Unannotated_Sequences_asndisc_cpp:
        run: progs/asndisc_cpp.cwl
        in:
            XML: {default: true}
            genbank: {default: false}
            P: {default: 't'}
            a: {default: 'c'}
            asn_cache: genomic_source/asncache
            o_output: {default: 'sequences.disc.xml'}
            i: Prepare_Unannotated_Sequences_text/output
            d:
                default:
                    - AUTODEF_USER_OBJECT
                    - FEATURE_LIST
                    - BACTERIAL_PARTIAL_NONEXTENDABLE_PROBLEMS 
                    - PARTIAL_CDS_COMPLETE_SEQUENCE
                    - MISSING_AFFIL
                    - OVERLAPPING_CDS
                    - BAD_BGPIPE_QUALS
                    - FLATFILE_FIND
                    - COMMENT_PRESENT
                    - SHORT_PROT_SEQUENCES
                    - OVERLAPPING_GENES
                    - EXTRA_GENES
                    - N_RUNS
                    - TAX_LOOKUP_MISMATCH
                    - TAX_LOOKUP_MISSING
        out: [o]
  Prepare_Unannotated_Sequences_asndisc_evaluate:
        run: progs/xml_evaluate.cwl
        in:
            input: Prepare_Unannotated_Sequences_asndisc_cpp/o
            xpath_fail: xpath_fail_initial_asndisc
            ignore_all_errors: ignore_all_errors
            stdout_redir: 
              default: 'initial_asndisc_diag.xml'
        out: [success, xml_output] 
  Prepare_Unannotated_Sequences_asnvalidate:
        run: progs/asnvalidate.cwl
        in:
            Q:
                default: 0
            R:
                default: 5
            i: Prepare_Unannotated_Sequences/sequences
            o_output:
                default: 'sequences.val'
            v: { default: 4 }
            A:
                default: true
            U:
                default: true
            Z:
                default: true
            y:
                default: true
        out: [o]
  Prepare_Unannotated_Sequences_asnvalidate_evaluate:
        run: progs/xml_evaluate.cwl
        in:
            input: Prepare_Unannotated_Sequences_asnvalidate/o
            xpath_fail: xpath_fail_initial_asnvalidate
            ignore_all_errors: ignore_all_errors
            stdout_redir: 
              default: 'initial_asnval_diag.xml'
        out: [success, xml_output] 

  Cache_Entrez_Gene: # ORIGINAL TASK NAME: Cache Entrez Gene # default 1
    label: "Cache Entrez Gene"
    run: cache_entrez_gene.cwl
    in:
      asn_cache: [genomic_source/asncache, passdata/uniColl_cache]
      egene_ini: passdata/gene_master_ini
      input: Prepare_Unannotated_Sequences/sequences
      go: 
        - Prepare_Unannotated_Sequences_asndisc_evaluate/success
        - Prepare_Unannotated_Sequences_asnvalidate_evaluate/success
    out: [prok_entrez_gene_stuff]

  Create_Genomic_BLASTdb: # default 1
   label: "Create Genomic BLASTdb" # default 1
   run: progs/gp_makeblastdb.cwl
   in:
       ids: genomic_source/ids_out
       title:
           default: 'BLASTdb  created by GPipe'
       asn_cache:
         source: [ genomic_source/asncache ]
         linkMerge: merge_flattened
       dbtype:
           default: 'nucl'
   out: [blastdb]
  #
  # end of pseudo plane "default 1"
  #
  Get_Proteins: 
    label: "Get Proteins"
    run: wf_bacterial_prot_src.cwl
    in:
      uniColl_asn_cache: passdata/uniColl_cache
      naming_sqlite: passdata/naming_sqlite
      taxid: taxid
      tax_sql_file: passdata/taxon_db
      blastdb_dir: passdata/identification_db_dir
      all_order_specific_blastdb: Get_Order_Specific_Strings/values
    out: [universal_clusters, all_prots, selected_blastdb]
  bacterial_ncrna: # PLANE
    run: bacterial_ncrna/wf_gcmsearch.cwl
    in:
      go: 
        - Prepare_Unannotated_Sequences_asndisc_evaluate/success
        - Prepare_Unannotated_Sequences_asnvalidate_evaluate/success
      asn_cache: genomic_source/asncache
      seqids: genomic_source/seqid_list
      model_path: passdata/rfam_model_path
      rfam_amendments: passdata/rfam_amendments
      rfam_stockholm: passdata/rfam_stockholm
      taxon_db: passdata/taxon_db
    out: [annots]

  bacterial_mobile_elem: # PLANE
    run: bacterial_mobile_elem/wf_bacterial_mobile_elem.cwl
    in:
      go: 
        - Prepare_Unannotated_Sequences_asndisc_evaluate/success
        - Prepare_Unannotated_Sequences_asnvalidate_evaluate/success
      asn_cache: genomic_source/asncache
      seqids: genomic_source/seqid_list
    out: [annots]

  bacterial_noncoding: # PLANE
    run: bacterial_noncoding/wf_bacterial_noncoding.cwl
    in:
      go: 
        - Prepare_Unannotated_Sequences_asndisc_evaluate/success
        - Prepare_Unannotated_Sequences_asnvalidate_evaluate/success
      asn_cache: genomic_source/asncache
      seqids: genomic_source/seqid_list
      model_path_5s: passdata/5s_model_path
      model_path_16s: passdata/16s_model_path
      model_path_23s: passdata/23s_model_path
      rfam_amendments: passdata/rfam_amendments
      rfam_stockholm: passdata/rfam_stockholm
      taxon_db: passdata/taxon_db
    out: [ annotations_5s, annotations_16s, annotations_23s ]

  bacterial_trna: # PLANE
    run: bacterial_trna/wf_trnascan.cwl
    in:
      go: 
        - Prepare_Unannotated_Sequences_asndisc_evaluate/success
        - Prepare_Unannotated_Sequences_asnvalidate_evaluate/success
      asn_cache: genomic_source/asncache
      seqids: genomic_source/seqid_list
      taxid: taxid
      taxon_db: passdata/taxon_db
      scatter_gather_nchunks: scatter_gather_nchunks
    out: [annots]

  ab_initio_training: 
    run: bacterial_annot/wf_ab_initio_training.cwl
    in:
      go: 
        - Prepare_Unannotated_Sequences_asndisc_evaluate/success
        - Prepare_Unannotated_Sequences_asnvalidate_evaluate/success
      selenoproteins: passdata/selenoproteins
      uniColl_cache: passdata/uniColl_cache
      naming_sqlite: passdata/naming_sqlite
      genemark_path: 
        default: /netmnt/vast01/gp/ThirdParty/GeneMark/
      thresholds: passdata/thresholds
      
      asn_cache: genomic_source/asncache
      inseq: Prepare_Unannotated_Sequences/sequences
      trna_annots: bacterial_trna/annots
      ncrna_annots: bacterial_ncrna/annots
      Execute_CRISPRs_annots: bacterial_mobile_elem/annots
      Generate_16S_rRNA_Annotation_annotation: bacterial_noncoding/annotations_16s
      Generate_23S_rRNA_Annotation_annotation: bacterial_noncoding/annotations_23s
      Post_process_CMsearch_annotations_annots_5S: bacterial_noncoding/annotations_5s
      
      nogenbank:
        default: true
    out: [annotation, out_hmm_params, models1]

  spurious_annot_prelim: # PLANE
    run: spurious_annot/wf_spurious_annot_pass1.cwl
    in:
      Extract_ORF_Proteins_proteins: orfs_hmms/proteins
      Extract_ORF_Proteins_seqids: orfs_hmms/seqids
      Extract_ORF_Proteins_lds2: orfs_hmms/lds2
      AntiFamLib: passdata/AntiFamLib
      sequence_cache: genomic_source/asncache
      scatter_gather_nchunks: scatter_gather_nchunks
    out: [AntiFam_tainted_proteins_I___oseqids]

  bacterial_annot_1st_pass: # PLANE
    run: bacterial_annot/wf_bacterial_annot_pass2.cwl
    in:
        lds2: orfs_hmms/lds2
        proteins: orfs_hmms/proteins
        prot_ids_A: orfs_hmms/seqids
        prot_ids_B1: orfs_hmms/prot_ids
        prot_ids_B2: spurious_annot_prelim/AntiFam_tainted_proteins_I___oseqids
        identification_db_dir: passdata/identification_db_dir
        blastdb: Get_Proteins/selected_blastdb
        annotation: orfs_hmms/outseqs
        sequence_cache: genomic_source/asncache
        unicoll_cache: passdata/uniColl_cache
        raw_seqs: Prepare_Unannotated_Sequences/sequences
        plasmids: Prepare_Unannotated_Sequences/plasmids
        scatter_gather_nchunks: scatter_gather_nchunks
        taxid: taxid
        blast_hits_cache: blast_hits_cache_data_split_dir/blast_hits_cache
        taxon_db: passdata/taxon_db
        genus_list: genus_list_file2ints/values
    out: [aligns] #   label: "goes to protein_alignment/Seed Search Compartments/compartments"

  protein_alignment: # PLANE
    run: protein_alignment/wf_protein_alignment_miniprot.cwl
    in:
      go: 
        - Prepare_Unannotated_Sequences_asndisc_evaluate/success
        - Prepare_Unannotated_Sequences_asnvalidate_evaluate/success
      asn_cache: genomic_source/asncache
      uniColl_asn_cache: passdata/uniColl_cache
      blastdb_dir: Create_Genomic_BLASTdb/blastdb
      taxid: taxid
      taxon_db: passdata/taxon_db
      
      compartments: bacterial_annot_1st_pass/aligns
      all_prots: Get_Proteins/all_prots
      genomic_ids: genomic_source/seqid_list
    out: [align]

  ab_initio_antifam:
    run: bacterial_annot/wf_ab_initio_antifam.cwl
    in:
        AntiFamLib: passdata/AntiFamLib
        
        sequence_cache: genomic_source/asncache
        models1: ab_initio_training/models1
        
        scatter_gather_nchunks: scatter_gather_nchunks
    out: [out_annotation]
        
  bacterial_annot_2nd_pass_genemark:
    run: bacterial_annot/wf_bacterial_annot_2nd_pass.cwl
    in:
        uniColl_cache: passdata/uniColl_cache
        thresholds: passdata/thresholds
        naming_sqlite: passdata/naming_sqlite
        naming_hmms_combined: passdata/naming_hmms_combined
        hmms_tab: passdata/naming_hmms_tab
        wp_hashes: passdata/wp_hashes
        taxon_db: passdata/taxon_db
        selenoproteins: passdata/selenoproteins
        genemark_path: 
          default: /netmnt/vast01/gp/ThirdParty/GeneMark/
        
        sequence_cache: genomic_source/asncache
        hmm_aligns: orfs_hmms/aligns
        prot_aligns: protein_alignment/align  # label: "Filter Protein Alignments/align"
        annotation: ab_initio_training/annotation
        raw_seqs: Prepare_Unannotated_Sequences/sequences
        hmm_params: ab_initio_training/out_hmm_params # Run GeneMark Training/hmm_params (EXTERNAL, put to input/
        good_ab_initio_annotations: ab_initio_antifam/out_annotation
        
        scatter_gather_nchunks: scatter_gather_nchunks
        
    out:
        - id: Find_Best_Evidence_Alignments_aligns
        - id: Run_GeneMark_Post_models
        - id: Extract_Model_Proteins_seqids
        - id: Extract_Model_Proteins_lds2
        - id: Extract_Model_Proteins_proteins
        - id: Search_Naming_HMMs_hmm_hits
        - id: Assign_Naming_HMM_to_Proteins_assignments
        - id: Name_by_WPs_names
        - id: PGAP_plus_ab_initio_annotation

  orfs_hmms: 
    run: bacterial_annot/wf_orf_hmms.cwl
    in:
      go: 
        - Prepare_Unannotated_Sequences_asndisc_evaluate/success
        - Prepare_Unannotated_Sequences_asnvalidate_evaluate/success
      uniColl_cache: passdata/uniColl_cache
      asn_cache: genomic_source/asncache
      inseq: Prepare_Unannotated_Sequences/sequences
      hmm_path: passdata/hmm_path
      hmms_tab: passdata/hmms_tab
      nogenbank:
        default: true
      scatter_gather_nchunks: scatter_gather_nchunks
      annotation: ab_initio_antifam/out_annotation
      
    out: [lds2, seqids, proteins, aligns, outseqs, prot_ids]

  spurious_annot_final:
    run: spurious_annot/wf_spurious_annot_pass2.cwl
    in:
      Extract_Model_Proteins_proteins: bacterial_annot_2nd_pass_genemark/Extract_Model_Proteins_proteins
      Extract_Model_Proteins_seqids: bacterial_annot_2nd_pass_genemark/Extract_Model_Proteins_seqids
      Extract_Model_Proteins_lds2: bacterial_annot_2nd_pass_genemark/Extract_Model_Proteins_lds2
      AntiFamLib: passdata/AntiFamLib
      sequence_cache: genomic_source/asncache
      scatter_gather_nchunks: scatter_gather_nchunks
      input_models: bacterial_annot_2nd_pass_genemark/PGAP_plus_ab_initio_annotation
    out:
      - AntiFam_tainted_proteins___oseqids
      - Good_AntiFam_filtered_annotations_out
      - Good_AntiFam_filtered_proteins_output

  bacterial_annot_2nd_pass_blastp:
    run: bacterial_annot/wf_bacterial_annot_pass4.cwl
    in:
        lds2: bacterial_annot_2nd_pass_genemark/Extract_Model_Proteins_lds2
        proteins: bacterial_annot_2nd_pass_genemark/Extract_Model_Proteins_proteins
        annotation: spurious_annot_final/Good_AntiFam_filtered_annotations_out
        Good_AntiFam_filtered_proteins_gilist: spurious_annot_final/Good_AntiFam_filtered_proteins_output
        sequence_cache: genomic_source/asncache
        uniColl_cache: passdata/uniColl_cache
        identification_db_dir: passdata/identification_db_dir
        naming_sqlite: passdata/naming_sqlite
        hmm_assignments:  bacterial_annot_2nd_pass_genemark/Assign_Naming_HMM_to_Proteins_assignments
        wp_assignments:  bacterial_annot_2nd_pass_genemark/Name_by_WPs_names
        Extract_Model_Proteins_prot_ids: bacterial_annot_2nd_pass_genemark/Extract_Model_Proteins_seqids
        CDDdata: passdata/CDDdata
        CDDdata2: passdata/CDDdata2
        thresholds: passdata/thresholds
        defline_cleanup_rules: passdata/defline_cleanup_rules
        blastdb: Get_Proteins/selected_blastdb
        scatter_gather_nchunks: scatter_gather_nchunks
        taxid: taxid
        blast_hits_cache: blast_hits_cache_data_split_dir/blast_hits_cache
        taxon_db: passdata/taxon_db
        genus_list: genus_list_file2ints/values
    out:
        - id: out_annotation
  # #
  # # Pseudo plane default 2, we do not need that for new submissions in off-NCBI environment
  # #
  # # Preserve_Annotations: # Pseudo plane default 2
   # # run: task_types/tt_preserve_annot.cwl
   # # in:
     # # asn_cache:
        # # source: [genomic_source/asncache]
        # # linkMerge: merge_flattened
     # # input_annotation: ab_initio_training/annotation
     # # rfam_amendments: rfam_amendments
     # # no_ncRNA:
       # # default: true
   # # out: [annotations]
  # # preserve_annot_markup: # Pseudo plane default 2
    # # # uncharted territory!!!
    # # run: preserve_annot_markup.cwl # Preserve Product Accessions
    # # in:
      # # #seq_cache: genobacterial_prepare_unannotated/asncache
      # # #unicoll_cache: uniColl_cache
      # # input_annotation: Preserve_Annotations/annotations
      # # asn_cache: [genomic_source/asncache, uniColl_cache]
      # # egene_ini: gene_master_ini
      # # gc_assembly: genomic_source/gencoll_asn
      # # input: Preserve_Annotations/annotations
      # # prok_entrez_gene_stuff: Cache_Entrez_Gene/prok_entrez_gene_stuff
    # # out: [annotations]

  # #
  # # End of Pseudo plane default 2
  # #
  # # This step takes input from bacterial_annot 4/Bacterial Annot Filter, see GP-23942
  # # Status:
    # # tasktype coded, input/output matches
    # # application not coded
  # ###############################################
  # # AMR plane is for later stages skipping 
  # ###############################################
  bacterial_orthology_conditional:
    run: bacterial_orthology/wf_bacterial_orthology_conditional.cwl
    in:
      input: Add_Locus_Tags/output
      taxid: taxid
      naming_sqlite: passdata/naming_sqlite
      taxon_db: passdata/taxon_db
      gc_cache: passdata/gc_cache
      asn_cache: 
        source: [passdata/uniColl_nuc_cache, genomic_source/asncache]
        linkMerge: merge_flattened
      genus_list: genus_list_file2ints/values
      blastdb:
        default: [blastdb]
      scatter_gather_nchunks: scatter_gather_nchunks
      gencoll_asn: genomic_source/gencoll_asn
    out: [output]
  Add_Locus_Tags:
    run: progs/add_locus_tags.cwl
    in:
        input: bacterial_annot_2nd_pass_blastp/out_annotation
        locus_tag_prefix: locus_tag_prefix
        dbname: dbname
    out: [output]

  #
  # Pseudo plane default 3
  #

  #
  #  Final_Bacterial_Package task
  #
  Final_Bacterial_Package_asn_cleanup:
    run: progs/asn_cleanup.cwl
    in:
      inp_annotation: bacterial_orthology_conditional/output # production
    out: [annotation]

  Final_Bacterial_Package_final_bact_asn:
    run: progs/final_bact_asn.cwl
    in:
      annotation:
        source: [Final_Bacterial_Package_asn_cleanup/annotation]
        linkMerge: merge_flattened
      asn_cache: genomic_source/asncache
      gc_assembly: genomic_source/gencoll_asn # gc_create_from_sequences
      master_desc: Prepare_Unannotated_Sequences/master_desc
           
      it:
        default: true
      submission_mode_genbank:
        default: true
      nogenbank:
        default: true
      order: genomic_source/order
    out: [outfull]
  Final_Bacterial_Package_dumb_down_as_required:
    run: progs/dumb_down_as_required.cwl
    in:
      annotation:  Final_Bacterial_Package_final_bact_asn/outfull
      asn_cache:
        source: [genomic_source/asncache]
        linkMerge: merge_flattened
      max_x_ratio:
        default: 0.1
      max_x_run:
        default: 3
      partial_cov_threshold:
        default: 65
      partial_len_threshold:
        default: 30
      drop_partial_in_the_middle:
        default: true
      submission_mode_genbank:
        default: true
      submol_block_json: submol_block_json
      nogenbank:
        default: true
      it:
        default: true
    out: [outent]
  Final_Bacterial_Package_ent2sqn:
    run: progs/ent2sqn.cwl
    in:
        annotation: Final_Bacterial_Package_dumb_down_as_required/outent
        asn_cache:
            source: [genomic_source/asncache]
            linkMerge: merge_flattened
        gc_assembly: genomic_source/gencoll_asn # gc_create_from_sequences
        submit_block_template: 
            source: [genomic_source/submit_block_template]
            linkMerge: merge_flattened
        it:
            default: true
        contact_as_author_possible: contact_as_author_possible
        output_impl:
            default: annot-wo-checksum.sqn
    out: [output]
  add_checksum_sqn:
        label: Add Checksum to SQN
        run: progs/annot_checksum.cwl
        in: 
            input: Final_Bacterial_Package_ent2sqn/output
            output_name: 
                default: 'annot.sqn'
            t: 
                default: true
            ifmt:
                default: seq-submit
            mode:
                default: add
        out: [output]
  Final_Bacterial_Package_sqn2gbent:
    run: progs/sqn2gbent.cwl
    doc: We are not taking here sqn with added annot checksum.
    in:
      input: Final_Bacterial_Package_ent2sqn/output
      it:
        default: true
      out_name:
            default: annot-gb-wo-checksum.ent
    out: [output]
  checkm:
    label: 'Run CheckM in PGAP graph'
    doc: 'Identify completeness of genome based on core HMM models in CheckM'
    run: checkm/wf_checkm.cwl
    in:
      models: Final_Bacterial_Package_sqn2gbent/output
      checkm_data_path: passdata/checkm_data_path
      filter_for_raw_checkm: passdata/filter_for_raw_checkm
      taxid: taxid
      taxon_db: passdata/taxon_db
    out: [checkm_raw, checkm_results]
  add_checksum_gbent:
        label: Add Checksum to Genbank class ENT
        run: progs/annot_checksum.cwl
        in: 
            input: Final_Bacterial_Package_sqn2gbent/output
            output_name: 
                default: 'annot-gb.ent'
            t: 
                default: true
            ifmt:
                default: seq-entry
            mode:
                default: add
        out: [output]
  Generate_Annotation_Reports_gff:
    run: progs/gp_annot_format.cwl
    in:
        input: Final_Bacterial_Package_dumb_down_as_required/outent
        ifmt:
            default: seq-entry
        t:
            default: true
        ofmt:
            default: gff3
        exclude_external:
            default: true
    out: [output]
  Generate_Annotation_Reports_gbk:
    run: progs/asn2flat.cwl
    in:
        input: Final_Bacterial_Package_sqn2gbent/output
        no_external:
            default: true
        type:
            default: seq-entry
        mode:
            default: entrez
        style:
            default: master
        gbload:
            default: false
    out: [output]
  Generate_Annotation_Reports_nuc_fasta:
    run: progs/asn2fasta.cwl
    in:
        i: Final_Bacterial_Package_sqn2gbent/output
        type:
            default: seq-entry
        nuc_fasta_name:
            default: annot.fna
    out: [nuc_fasta]
  Generate_Annotation_Reports_prot_fasta:
    run: progs/asn2fasta.cwl
    in:
            i: Final_Bacterial_Package_sqn2gbent/output
            type:
                default: seq-entry
            prot_fasta_name:
                default: annot.faa
    out: [prot_fasta]
  Generate_Annotation_Reports_cds_nuc_fasta:
    run: progs/asn2fasta.cwl
    in:
      i: Final_Bacterial_Package_sqn2gbent/output
      type:
        default: seq-entry
      feats:
        default: fasta_cds_na
      fasta_name:
        default: annot_cds_from_genomic.fna
    out: [fasta]
  Generate_Annotation_Reports_cds_prot_fasta:
    run: progs/asn2fasta.cwl
    in:
      i: Final_Bacterial_Package_sqn2gbent/output
      type:
          default: seq-entry
      feats:
          default: fasta_cds_aa
      fasta_name:
          default: annot_translated_cds.faa
    out: [fasta]
  Final_Bacterial_Package_std_validation:
    run: progs/std_validation.cwl
    in:
      annotation: Final_Bacterial_Package_dumb_down_as_required/outent
      asn_cache:
        source: [genomic_source/asncache]
      exclude_asndisc_codes: #
        default: 
            - AUTODEF_USER_OBJECT
            - FEATURE_LIST
            - BACTERIAL_PARTIAL_NONEXTENDABLE_PROBLEMS
            - PARTIAL_CDS_COMPLETE_SEQUENCE
            - MISSING_AFFIL
            - OVERLAPPING_CDS
            - BAD_BGPIPE_QUALS
            - FLATFILE_FIND
            - COMMENT_PRESENT
            - SHORT_PROT_SEQUENCES
            - OVERLAPPING_GENES
            - EXTRA_GENES
            - N_RUNS
            - BAD_LOCUS_TAG_FORMAT 
            - TAX_LOOKUP_MISMATCH
            - TAX_LOOKUP_MISSING
      inent: Final_Bacterial_Package_dumb_down_as_required/outent
      ingb: Final_Bacterial_Package_sqn2gbent/output
      insqn: Final_Bacterial_Package_ent2sqn/output
      master_desc:
        source: [Prepare_Unannotated_Sequences/master_desc]
        linkMerge: merge_flattened
      submit_block_template:
        source: [genomic_source/submit_block_template]
        linkMerge: merge_flattened
      it:
        default: true
      submission_mode_genbank:
        default: true
      nogenbank:
        default: true
    out:
      - id: outdisc
      - id: outdiscxml
      - id: outmetamaster
      - id: outval
      
  Final_Bacterial_Package_asndisc_evaluate:
        run: progs/xml_evaluate.cwl
        in:
            input: Final_Bacterial_Package_std_validation/outdisc
            xpath_fail: xpath_fail_final_asndisc
            ignore_all_errors: ignore_all_errors
            stdout_redir: 
              default: 'final_asndisc_diag.xml'
        out: [xml_output] 
  Final_Bacterial_Package_asnvalidate_evaluate:
        run: progs/xml_evaluate.cwl
        in:
            input: Final_Bacterial_Package_std_validation/outval
            xpath_fail: xpath_fail_final_asnvalidate
            ignore_all_errors: ignore_all_errors
            stdout_redir: 
              default: 'final_asnval_diag.xml'
        out: [success, xml_output] 
  Final_Bacterial_Package_val_stats: # TESTED (unit test)
    run: progs/val_stats.cwl
    in:
      annot_val: Final_Bacterial_Package_std_validation/outval
      c_toolkit:
        default: true
    out: [output, xml]
  #
  #  end of Final_Bacterial_Package task
  #

  #### we do not need this
  # Prepare_Init_Refseq_Molecules:
  #  run: progs/

  #
  #  Validate_Annotation task
  #

  Validate_Annotation_bact_univ_prot_stats:
    run: progs/bact_univ_prot_stats.cwl
    in:
      annot_request_id:
        default: -1 # this is dummy annot_request_id
      hmm_search: bacterial_annot_2nd_pass_genemark/Search_Naming_HMMs_hmm_hits
      hmm_search_proteins: bacterial_annot_2nd_pass_genemark/PGAP_plus_ab_initio_annotation
      input:  Final_Bacterial_Package_final_bact_asn/outfull
      univ_prot_xml:  passdata/univ_prot_xml
      val_res_den_xml:  passdata/val_res_den_xml
      it:
        default: true
    out: [bact_univ_prot_stats_old_xml, var_bact_univ_prot_details_xml, var_bact_univ_prot_stats_xml]

  Validate_Annotation_proc_annot_stats:
    run: progs/proc_annot_stats.cwl
    in:
      input: Final_Bacterial_Package_dumb_down_as_required/outent
      max_unannotated_region:
        default: 5000
      univ_prot_xml:  passdata/univ_prot_xml
      val_res_den_xml:  passdata/val_res_den_xml
      it:
        default: true
    out:  
      - id: var_proc_annot_stats_xml
      - id: var_proc_annot_details_xml
  Validate_Annotation_xsltproc_asnvalidate:
    run: progs/xsltproc.cwl
    in:
      xml: Final_Bacterial_Package_val_stats/xml
      xslt: passdata/asn2pas_xsl
      output_name:
        default: 'var_proc_annot_stats.val.xml'
    out: [output]
  Validate_Annotation_xsltproc_asndisc:
    run: progs/xsltproc.cwl
    in:
      xml: Final_Bacterial_Package_std_validation/outdiscxml
      xslt: passdata/asn2pas_xsl
      output_name:
        default: 'var_proc_annot_stats.disc.xml'
    out: [output]
  Validate_Annotation_collect_annot_stats: # TESTED (unit test)
    run: progs/collect_annot_stats.cwl
    in:
      input:
        source:
            - Validate_Annotation_bact_univ_prot_stats/var_bact_univ_prot_stats_xml
            - Validate_Annotation_proc_annot_stats/var_proc_annot_stats_xml
            - Validate_Annotation_xsltproc_asndisc/output
            - Validate_Annotation_xsltproc_asnvalidate/output
        linkMerge: merge_flattened
      output_name:
        default: proc_annot_stats.xml
    out: [output]
  Validate_Annotation_collect_annot_details:
    run: progs/collect_annot_stats.cwl
    in:
      input:
        source:
            - Validate_Annotation_bact_univ_prot_stats/var_bact_univ_prot_details_xml
            - Validate_Annotation_proc_annot_stats/var_proc_annot_details_xml
        linkMerge: merge_flattened
      output_name:
        default: proc_annot_details.xml
    out: [output]

  ping_stop:
    run: progs/pinger.cwl
    in:
      report_usage: report_usage
      uuid_in: ping_start/uuid_out
      state:
        default: "stop"
      workflow:
        default: "pgap"
      # Note: the input on the following line should be the same as all of the outputs
      # for this workflow, so we ensure this is the final step.
      infile:
        - Final_Bacterial_Package_sqn2gbent/output
        - Generate_Annotation_Reports_gff/output
        - Generate_Annotation_Reports_gbk/output
        - Generate_Annotation_Reports_nuc_fasta/nuc_fasta
        - Generate_Annotation_Reports_prot_fasta/prot_fasta
    out: [stdout]

  #
  #  end of Validate_Annotation task
  #

  #
  # End of Pseudo plane default 3
  #

  ###############################################
  # taxonomy plane is for later stages skipping
  ###############################################

  #
  # Pseudo plane default 4
  #

  # task: Generate Annotation Reports
  #
  # Generate_Annotation_Reports_pgaap_prepare_review:
    # run: progs/pgaap_prepare_review.cwl
  # Generate_Annotation_Reports_lds2_indexer:
    # run: progs/lds2_indexer.cwl
  #
  # comparisons only for pre-existing annotation, one of the next phases
  #
  # # Generate_Annotation_Reports_comparison_format_curr_comparison:
    # # run: progs/comparison_format.cwl
  # # Generate_Annotation_Reports_comparison_format_prev_comparison:
    # # run: progs/comparison_format.cwl
  # # Generate_Annotation_Reports_comparison_format_prev_assm_comparison:
    # # run: progs/comparison_format.cwl
  # # Generate_Annotation_Reports_comparison_format_ref_comparison:
    # # run: progs/comparison_format.cwl
  # Generate_Annotation_Reports_bact_asn_stats:
    # run: progs/bact_asn_stats.cwl
    # in:
      # input_annotation: Final_Bacterial_Package_dumb_down_as_required/outent
      # it:
        # default: true
    # out: [output,  xml_output]
  # Generate_Annotation_Reports_val_format:
    # run: progs/val_format.cwl
  # Generate_Annotation_Reports_gbproject:
    # run: progs/gbproject.cwl
  # Generate_Annotation_Reports_asn2nucleotide_fasta:
    # run: progs/asn2fasta.cwl
  # Generate_Annotation_Reports_asn2all_protein_fasta:
    # run: progs/asn2fasta.cwl
  # Generate_Annotation_Reports_asn2protein_fasta:
    # run: progs/asn2fasta.cwl
  # Generate_Annotation_Reports_asn2flat:
    # run: progs/asn2flat.cwl
  # Generate_Annotation_Reports_format_rrnas:
    # run: progs/format_rrnas.cwl
  # Generate_Annotation_Reports_asn2rrna_fa:
    # run: progs/asn2fasta.cwl
  # Generate_Annotation_Reports_gp_annot_format:
    # run: progs/gp_annot_format.cwl
  # end of task: Generate Annotation Reports
  #

  #
  # End of Pseudo plane default 4
  #

outputs:
  gbent:
    type: File
    outputSource: add_checksum_gbent/output
  gff:
    type: File
    outputSource:  Generate_Annotation_Reports_gff/output
  gbk:
    type: File
    outputSource:  Generate_Annotation_Reports_gbk/output
  nucleotide_fasta:
    type: File?
    outputSource: Generate_Annotation_Reports_nuc_fasta/nuc_fasta
  protein_fasta:
    type: File?
    outputSource: Generate_Annotation_Reports_prot_fasta/prot_fasta
  cds_nucleotide_fasta:
    type: File?
    outputSource: Generate_Annotation_Reports_cds_nuc_fasta/fasta
  cds_protein_fasta:
    type: File?
    outputSource: Generate_Annotation_Reports_cds_prot_fasta/fasta
  sqn:
    type: File
    outputSource:  add_checksum_sqn/output
  proc_annot_stats: 
    type: File
    outputSource:  Validate_Annotation_proc_annot_stats/var_proc_annot_stats_xml
  all_proc_annot_stats: 
    type: File
    outputSource:  Validate_Annotation_collect_annot_stats/output
  initial_asndisc_error_diag:
    type: File?
    outputSource:  Prepare_Unannotated_Sequences_asndisc_evaluate/xml_output 
  initial_asnval_error_diag:
    type: File?
    outputSource:  Prepare_Unannotated_Sequences_asnvalidate_evaluate/xml_output 
  final_asndisc_error_diag:
    type: File?
    outputSource:  Final_Bacterial_Package_asndisc_evaluate/xml_output 
  final_asnval_error_diag:
    type: File?
    outputSource:  Final_Bacterial_Package_asnvalidate_evaluate/xml_output 
  checkm_raw: 
    type: File
    outputSource: checkm/checkm_raw
  checkm_results: 
    type: File
    outputSource: checkm/checkm_results
  
