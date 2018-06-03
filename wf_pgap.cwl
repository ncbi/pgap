#!/usr/bin/env cwl-runner
label: "PGAP Pipeline"
cwlVersion: v1.0
class: Workflow

requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: DockerRequirement
    dockerPull: ncbi/pgap:latest
    
inputs:
  fasta: File
  submit_block_template: File
  taxid: int
  gc_assm_name: string

  # Cached computational steps
  hmm_hits: File
  
  # Auxillary files
  hmm_path: Directory
  hmms_tab: File
  naming_hmms_tab: File
  uniColl_cache: Directory
  # uniColl_path: Directory
  gene_master_ini: File
  16s_blastdb_dir: Directory
  23s_blastdb_dir: Directory
  5s_model_path: File
  rfam_model_path: File
  rfam_amendments: File
  rfam_stockholm: File
  AntiFamLib: Directory
  blast_rules_db_dir: Directory
  identification_db_dir: Directory
  thresholds: File
  naming_sqlite: File # /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/home/badrazat/local-install/2018-05-17/third-party/data/BacterialPipeline/uniColl/ver-3.2/naming.sqlite
  selenoproteins: Directory
  naming_hmms_combined: Directory
  wp_hashes: File
  taxon_db: File   
  genemark_path: Directory
  naming_blast_db: Directory
  CDDdata: Directory
  CDDdata2: Directory
  defline_cleanup_rules: File
outputs:
  # aligns: 
  #   type: File
  #   outputSource: bacterial_annot/aligns
  prok_entrez_gene_stuff: 
    type: File
    outputSource: cache_entrez_gene/prok_entrez_gene_stuff
  # annotations:
  #   type: File
  #   outputSource: preserve_annot_markup/annotations
  # annotations_5s:
  #   type: File
  #   outputSource: bacterial_noncoding/annotations_5s
  # annotations_16s:
  #   type: File
  #   outputSource: bacterial_noncoding/annotations_16s
  # annotations_23s:
  #   type: File
  #   outputSource: bacterial_noncoding/annotations_23s
  
  # lds2: 
  #   type: File
  #   outputSource: bacterial_annot/lds2
  # seqids: 
  #   type: File
  #   outputSource: bacterial_annot/seqids
  #strace: 
  #  type: File
  #  outputSource: bacterial_annot/strace
  sequences:
    type: File
    outputSource: bacterial_prepare_unannotated/sequences
  asncache:
    type: Directory
    outputSource: genomic_source/asncache
###############################################################################
###############################################################################
###############################################################################
steps:
###############################################################################
###############################################################################
###############################################################################
  genomic_source: # PLANE
    run: genomic_source/wf_genomic_source.cwl
    in:
      fasta: fasta
      submit_block_template: submit_block_template
      taxid: taxid
      gc_assm_name: gc_assm_name
    out: [gencoll_asn, seqid_list, stats_report, asncache, ids_out]

  #
  #  Pseudo plane "default 1"
  #   
  bacterial_prepare_unannotated: # ORIGINAL TASK NAME: Prepare Unannotated Sequences # default 1
    label: "Prepare Unannotated Sequences"
    run: bacterial_prepare_unannotated.cwl
    in:
      asn_cache: genomic_source/asncache
      gc_assembly: genomic_source/gencoll_asn
      ids: genomic_source/seqid_list
      submit_block: submit_block_template
    out: [master_desc, sequences]
    
  cache_entrez_gene: # ORIGINAL TASK NAME: Cache Entrez Gene # default 1
    label: "Cache Entrez Gene"
    run: cache_entrez_gene.cwl
    in:
      asn_cache: [genomic_source/asncache, uniColl_cache]
      egene_ini: gene_master_ini
      input: bacterial_prepare_unannotated/sequences
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
   out: [dbdir,dbname]
  #
  # end of pseudo plane "default 1"
  #
  bacterial_ncrna: # PLANE
    run: bacterial_ncrna/wf_gcmsearch.cwl
    in:
      asn_cache: genomic_source/asncache
      seqids: genomic_source/seqid_list
      model_path: rfam_model_path
      rfam_amendments: rfam_amendments
      rfam_stockholm: rfam_stockholm
    out: [annots]
   
  bacterial_mobile_elem: # PLANE
    run: bacterial_mobile_elem/wf_bacterial_mobile_elem.cwl
    in:
      asn_cache: genomic_source/asncache
      seqids: genomic_source/seqid_list
    out: [outdir]
  
  bacterial_noncoding: # PLANE
    run: bacterial_noncoding/wf_bacterial_noncoding.cwl
    in:
      asn_cache: genomic_source/asncache
      seqids: genomic_source/seqid_list
      16s_blastdb_dir: 16s_blastdb_dir
      23s_blastdb_dir: 23s_blastdb_dir
      model_path: 5s_model_path
      rfam_amendments: rfam_amendments
      rfam_stockholm: rfam_stockholm
    out: [ annotations_5s, annotations_16s, annotations_23s ]

  bacterial_trna: # PLANE
    run: bacterial_trna/wf_trnascan.cwl
    in:
      asn_cache: genomic_source/asncache
      seqids: genomic_source/seqid_list
      taxid: taxid
    out: [annots]

  bacterial_annot: # PLANE
    run: bacterial_annot/wf_bacterial_annot_pass1.cwl
    in:
      #asn_cache: bacterial_prepare_unannotated/asncache
      asn_cache: genomic_source/asncache
      inseq: bacterial_prepare_unannotated/sequences
      hmm_path: hmm_path
      hmms_tab: hmms_tab
      uniColl_cache: uniColl_cache
      # hmm_hits: hmm_hits
      trna_annots: bacterial_trna/annots
      ncrna_annots: bacterial_ncrna/annots
      nogenbank:
        default: true
    out:
      [lds2,seqids,proteins, hmm_hits, annotation, out_hmm_params]
      #[strace]

  spurious_annot_1: # PLANE
    run: spurious_annot/wf_spurious_annot_pass1.cwl      
    in:
      Extract_ORF_Proteins_proteins: bacterial_annot/proteins
      Extract_ORF_Proteins_seqids: bacterial_annot/seqids
      Extract_ORF_Proteins_lds2: bacterial_annot/lds2
      AntiFamLib: AntiFamLib
      sequence_cache: genomic_source/asncache
    out:[AntiFam_tainted_proteins_I___oseqids]
    
  bacterial_annot_2: # PLANE  
    run: bacterial_annot_pass2/wf_bacterial_annot_pass2.cwl
    in:
        # This LDS2 resource needs to be fixed by removing absolute path from files
        lds2: bacterial_annot/lds2
        proteins: bacterial_annot/proteins
        prot_ids_A: bacterial_annot/seqids
        prot_ids_B1: bacterial_annot/prot_ids
        prot_ids_B2: spurious_annot_1/AntiFam_tainted_proteins_I___oseqids
        blast_rules_db_dir: blast_rules_db_dir
        identification_db_dir: identification_db_dir
        annotation: bacterial_annot/outseq
        sequence_cache: enomic_source/asncache
        unicoll_cache: uniColl_cache
    out: [aligns] #   label: "goes to protein_alignment/Seed Search Compartments/compartments"
  
  # ### GP-23940: almost ready need testing
  # protein_alignment: # PLANE
    # run: protein_alignment/wf_protein_alignment.cwl
    # in:
        # ___aligns___: bacterial_annot_2/aligns
        # asn_cache: genomic_source/asncache
        # uniColl_asn_cache: uniColl_cache
        # uniColl_path: uniColl_path
        # blastdb_dir: Create_Genomic_BLASTdb/dbdir
        # seqids: File
        # clade: File
        # taxid: string
        # gc_assembly: File
        # asn: File
    # out: 
  
  bacterial_annot_3:
    run: bacterial_annot_pass3/wf_bacterial_annot_pass3.cwl
    in:
        uniColl_cache: uniColl_cache
        sequence_cache: genomic_source/asncache
        hmm_aligns: bacterial_annot/hmm_hits
        prot_aligns: protein_alignment/___aligns____ 
            label: "Filter Protein Alignments I/align"
        annotation: bacterial_annot/annotation
        raw_seqs: bacterial_prepare_unannotated/sequences
        thresholds: thresholds # ${GP_HOME}/etc/thresholds.xml
        naming_sqlite: naming_sqlite # /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/home/badrazat/local-install/2018-05-17/third-party/data/BacterialPipeline/uniColl/ver-3.2/naming.sqlite
        hmm_params: bacterial_annot/out_hmm_params # Run GeneMark Training/hmm_params (EXTERNAL, put to input/
        selenoproteins: selenoproteins # /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/home/badrazat/local-install/2018-05-17/third-party/data/BacterialPipeline/Selenoproteins/selenoproteins
        naming_hmms_combined: naming_hmms_combined # ${GP_HOME}/third-party/data/BacterialPipeline/uniColl/ver-3.2/naming_hmms_combined.mft
        hmms_tab: naming_hmms_tab
        wp_hashes: wp_hashes
        taxon_db: taxon_db
        genemark_path: genemark_path
        sequence_cache: genomic_source/asncache
        uniColl_cache: uniColl_cache
    out:
        # long output names are preliminary.
        # after the list is complete, drop the long prefixes
        - Find_Best_Evidence_Alignments_aligns: 
            # sink: Generate Annotation Reports/cluster_prot_aligns (EXTERNAL, put to output/)
            # sink: Validate Annotation/cluster_best_mft (EXTERNAL, put to output/)
            # label: "goes to protein_alignment/Seed Search Compartments/compartments"
            # type: File
            # outputSource: Find_Best_Evidence_Alignments/out_align
        - Run_GeneMark_Post_models:
            # type: File
            # outputSource: Run_GeneMark_Post/models
        - Extract_Model_Proteins_seqids:
            # type: File
            # outputSource: Extract_Model_Proteins/seqids
        - Extract_Model_Proteins_lds2:
            # type: File
            # outputSource: Extract_Model_Proteins/lds2
        - Extract_Model_Proteins_proteins:
            # type: File
            # outputSource: Extract_Model_Proteins/proteins
        - Search_Naming_HMMs_hmm_hits:
            # type: File
            # outputSource: Search_Naming_HMMs/hmm_hits
        - Assign_Naming_HMM_to_Proteins_assignments:
            # type: File
            # outputSource: Assign_Naming_HMM_to_Proteins/assignments
        - Name_by_WPs_names:
            # type: File
            # outputSource: Name_by_WPs/out_names    
    
  spurious_annot_2:
    run: spurious_annot/wf_spurious_annot_pass2.cwl
    in:
      Extract_Model_Proteins_proteins: bacterial_annot_3/Extract_Model_Proteins_proteins
      Extract_Model_Proteins_seqids: bacterial_annot_3/Extract_Model_Proteins_seqids
      Extract_Model_Proteins_lds2: bacterial_annot_3/Extract_Model_Proteins_lds2
      AntiFamLib: AntiFamLib
      sequence_cache: genomic_source/asncache
      Run_GeneMark_models: bacterial_annot_3/Run_GeneMark_Post_models
    out:
      - AntiFam_tainted_proteins___oseqids
        # type: File
        # outputSource: AntiFam_tainted_proteins/oseqids
      - Good_AntiFam_filtered_annotations_out
        # type: File
        # outputSource: Good_AntiFam_filtered_annotations/out_annotation
      - Good_AntiFam_filtered_proteins_output
    
  bacterial_annot_4:
    run: bacterial_annot_pass4/wf_bacterial_annot_pass4.cwl
    in:
        lds2: bacterial_annot_3/Extract_Model_Proteins_lds2
        proteins: bacterial_annot_3/Extract_Model_Proteins_proteins
        annotation: spurious_annot_2/Good_AntiFam_filtered_annotations_out
        Good_AntiFam_filtered_proteins_gilist: spurious_annot_2/Good_AntiFam_filtered_proteins_output
        sequence_cache: genomic_source/asncache
        uniColl_cache: uniColl_cache
        naming_blast_db: naming_blast_db 
        naming_sqlite: naming_sqlite
        hmm_assignments:  bacterial_annot_3/Assign_Naming_HMM_to_Proteins_assignments # XML assignments
        wp_assignments:  bacterial_annot_3/Name_by_WPs_names # XML assignments
        Extract_Model_Proteins_prot_ids: Extract_Model_Proteins_seqids # pass 3
        CDDdata: CDDdata # ${GP_HOME}/third-party/data/CDD/cdd -
        CDDdata2: CDDdata2 # ${GP_HOME}/third-party/data/cdd_add 
        thresholds: thresholds
        defline_cleanup_rules: defline_cleanup_rules # defline_cleanup_rules # ${GP_HOME}/etc/product_rules.prt
        blast_rules_db_dir: blast_rules_db_dir
        identification_db_dir: blast_rules_db_dir
        # cached for intermediate testing
        # cached_Find_Naming_Protein_Hits:
    out:
        - out_annotation: 
            # type: File
            # outputSource: Bacterial_Annot_Filter/out_annotation
  #
  # Pseudo plane default 2
  #
  Preserve_Annotations: # Pseudo plane default 2
   run: task_types/tt_preserve_annot.cwl
   in:
     asn_cache: [genomic_source/asncache]
     input_annotation: bacterial_annot/bact_annot_filter_annotations
     rfam_amendments: rfam_amendments
     no_ncRNA: 
       default: true
   out: [annotations]
  preserve_annot_markup: # Pseudo plane default 2
    # uncharted territory!!!
    run: preserve_annot_markup.cwl # Preserve Product Accessions
    in:
      #seq_cache: genobacterial_prepare_unannotated/asncache
      #unicoll_cache: uniColl_cache
      input_annotation: Preserve_Annotations/annotations
      asn_cache: [genomic_source/asncache, uniColl_cache]
      egene_ini: gene_master_ini
      gc_assembly: genomic_source/gencoll_asn
      
      prok_entrez_gene_stuff: cache_entrez_gene/prok_entrez_gene_stuff
    out: [annotations]
      
  #
  # End of Pseudo plane default 2
  #
  # This step takes input from bacterial_annot 4/Bacterial Annot Filter, see GP-23942
  # Status: 
    # tasktype coded, input/output matches
    # application not coded
  ###############################################
  # AMR plane is for later stages skipping
  ###############################################
  
  #
  # Pseudo plane default 3
  # 
  
  #
  #  Final_Bacterial_Package task
  #
  Final_Bacterial_Package_asn_cleanup:
    run: progs/asn_cleanup.cwl
  Final_Bacterial_Package_final_bact_asn:
    run: progs/final_bact_asn.cwl
  Final_Bacterial_Package_dumb_down_as_required:
    run: progs/dumb_down_as_required.cwl
  Final_Bacterial_Package_ent2sqn:
    run: progs/ent2sqn.cwl
  Final_Bacterial_Package_sqn2gbent:
    run: progs/sqn2gbent.cwl
  Final_Bacterial_Package_std_validation:
    run: progs/std_validation.cwl
  Final_Bacterial_Package_val_stats:
    run: progs/val_stats.cwl  
  #
  #  end of Final_Bacterial_Package task
  #
  Prepare_Init_Refseq_Molecules:
    run: progs/
  Validate_Annotation:
    run: progs/
  
  #
  # End of Pseudo plane default 3
  #
  
  ###############################################
  # taxonomy plane is for later stages skipping
  ###############################################

  #
  # Pseudo plane default 4
  # 
  
  # step: Generate Annotation Reports
  
  #
  # End of Pseudo plane default 4
  #
    
