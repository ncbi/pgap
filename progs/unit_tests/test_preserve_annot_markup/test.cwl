#!/usr/bin/env cwl-runner
label: "PGAP Pipeline"
cwlVersion: v1.2
class: Workflow

requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
    
inputs:
  input_annotation: File
  uniColl_cache: Directory
  sequence_cache_shortcut: Directory
  genomic_source_gencoll_asn_bypass: File
steps:
  test: # Pseudo plane default 2
    run: ../../../preserve_annot_markup.cwl # Preserve Product Accessions
    in:
      input_annotation: input_annotation # bacterial_annot/annotations
      asn_cache: [sequence_cache_shortcut, uniColl_cache]
      # egene_ini: gene_master_ini
      gc_assembly: genomic_source_gencoll_asn_bypass
      prok_entrez_gene_stuff: # cache_entrez_gene/prok_entrez_gene_stuff
    out: [annotations]
      
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
  
  #
  # Pseudo plane default 3
  # 
  
  #
  #  Final_Bacterial_Package task
  #
  Final_Bacterial_Package_asn_cleanup: # TESTED as part of "last couple of nodes" test
    run: progs/asn_cleanup.cwl
    in:
      # inp_annotation: bacterial_annot_4/out_annotation 
      # inp_annotation: bacterial_annot_4_out_annotation_bypass # , this bypass does not work: SQD-4522
      # using oroginal input from official buildrun template (that is from fam_report output)
      inp_annotation: fam_report_bypass
    out: [annotation]

  Final_Bacterial_Package_final_bact_asn: # TESTED (as part of "last couple of nodes" test
    run: progs/final_bact_asn.cwl
    in:
      annotation: 
        source: [Final_Bacterial_Package_asn_cleanup/annotation]
        linkMerge: merge_flattened
      # asn_cache: genomic_source/asncache
      asn_cache: sequence_cache_shortcut
      # gc_assembly: genomic_source/gencoll_asn # gc_create_from_sequences
      gc_assembly: genomic_source_gencoll_asn_bypass # gc_create_from_sequences
      # master_desc: bacterial_prepare_unannotated/master_desc
      master_desc: bacterial_prepare_unannotated_master_desc_bypass
      submit_block_template: 
        source: [submit_block_template]
        linkMerge: merge_flattened
      it:
        default: true
      submission_mode_genbank:
        default: true
      nogenbank:
        default: true
        
    out: [outfull]
  Final_Bacterial_Package_dumb_down_as_required: # TESTED (as part of "last couple of nodes" test
    run: progs/dumb_down_as_required.cwl
    in: 
      annotation:  Final_Bacterial_Package_final_bact_asn/outfull
      asn_cache: 
        # source: [genomic_source/asncache]
        source: [sequence_cache_shortcut]
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
      nogenbank:
        default: true
      it:
        default: true
    out: [outent]
  Final_Bacterial_Package_ent2sqn: # TESTED (as part of "last couple of nodes" test
    run: progs/ent2sqn.cwl
    in:
      annotation: Final_Bacterial_Package_dumb_down_as_required/outent
      asn_cache: 
        # source: [genomic_source/asncache]
        source: [sequence_cache_shortcut]

        linkMerge: merge_flattened
        
      # gc_assembly: genomic_source/gencoll_asn # gc_create_from_sequences
      gc_assembly: genomic_source_gencoll_asn_bypass # gc_create_from_sequences
      submit_block_template: 
        source: [submit_block_template]
        linkMerge: merge_flattened
      it:
        default: true
    out: [output]
  Final_Bacterial_Package_sqn2gbent: # TESTED (as part of "last couple of nodes" test
    run: progs/sqn2gbent.cwl
    in:
      input: Final_Bacterial_Package_ent2sqn/output
      it:
        default: true
    out: [output]
  Final_Bacterial_Package_std_validation: # asnvalidation path in container is not valid: either no program at all, or it is in the wrong place 
  #  this is need to be fixed GP-24257
    run: progs/std_validation.cwl
    in:
      annotation: Final_Bacterial_Package_dumb_down_as_required/outent
      asn_cache:
        # source: [genomic_source/asncache]
        source: [sequence_cache_shortcut]
      exclude_asndisc_codes: # 
        default: ['OVERLAPPING_CDS']
      inent: Final_Bacterial_Package_dumb_down_as_required/outent
      ingb: Final_Bacterial_Package_sqn2gbent/output
      insqn: Final_Bacterial_Package_ent2sqn/output
      # master_desc: bacterial_prepare_unannotated/master_desc
      master_desc: bacterial_prepare_unannotated_master_desc_bypass
      submit_block_template:
        source: [submit_block_template]
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
      - id: tempdir
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
  
  Validate_Annotation_bact_univ_prot_stats: # TESTED (as part of "last couple of nodes" test
    run: progs/bact_univ_prot_stats.cwl
    in:
      annot_request_id: 
        default: -1 # this is dummy annot_request_id
      # hmm_search: bacterial_annot_3/Search_Naming_HMMs_hmm_hits # Search Naming HMMs bacterial_annot 3       
      hmm_search: bacterial_annot_3_Search_Naming_HMMs_hmm_hits_bypass # for bacterial_annot_3/Search_Naming_HMMs_hmm_hits # Search Naming HMMs bacterial_annot 3       
      # hmm_search_proteins: bacterial_annot_3/Run_GeneMark_Post_models # genemark models
      hmm_search_proteins: bacterial_annot_3_Run_GeneMark_Post_models_bypass # for bacterial_annot_3/Run_GeneMark_Post_models # genemark models
      input:  Final_Bacterial_Package_final_bact_asn/outfull
      univ_prot_xml:  univ_prot_xml # /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/home/badrazat/local-install/2018-05-17/third-party/data/BacterialPipeline/uniColl/ver-3.2/universal.xml 
      val_res_den_xml:  val_res_den_xml # /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/home/badrazat/local-install/2018-05-17/etc/validation-results.xml
      it:
        default: true
    out: [bact_univ_prot_stats_old_xml, var_bact_univ_prot_details_xml, var_bact_univ_prot_stats_xml]
      
  Validate_Annotation_proc_annot_stats: # TESTED (as part of "last couple of nodes" test
    run: progs/proc_annot_stats.cwl
    in:
      input: Final_Bacterial_Package_dumb_down_as_required/outent
      max_unannotated_region: 
        default: 5000
      univ_prot_xml:  univ_prot_xml 
      val_res_den_xml:  val_res_den_xml
      it:
        default: true
    out:
      - id: var_proc_annot_stats_xml
      - id: var_proc_annot_details_xml
  Validate_Annotation_xsltproc_asnvalidate: # TESTED (unit test)
    run: progs/xsltproc.cwl
    in:
      xml: validation_xml # Final_Bacterial_Package_std_validation/outval # final_bacterial_package.10054022/out/annot.val.summary.xml
      xslt: asn2pas_xsl # /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/home/badrazat/local-install/2018-05-17/etc/asn2pas.xsl)
      output_name: 
        default: 'var_proc_annot_stats.val.xml'
    out: [output]
  Validate_Annotation_xsltproc_asndisc: # TESTED (unit test)
    run: progs/xsltproc.cwl
    in:
      xml: asndisc_xml # Final_Bacterial_Package_std_validation/outdiscxml # final_bacterial_package.10054022/out/annot.disc.xml
      xslt: asn2pas_xsl # /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/home/badrazat/local-install/2018-05-17/etc/asn2pas.xsl)
      output_name: 
        default: 'var_proc_annot_stats.disc.xml'
    out: [output]
  Validate_Annotation_collect_annot_stats: # TESTED (unit test)
    run: progs/collect_annot_stats.cwl
    in:
      input:
        source:  
            - Validate_Annotation_bact_univ_prot_stats/var_bact_univ_prot_stats_xml 
            # '${work}/bact_univ_prot_stats.xml,
            - Validate_Annotation_proc_annot_stats/var_proc_annot_stats_xml 
            # ${work}/proc_annot_stats.xml,
            - Validate_Annotation_xsltproc_asndisc/output 
            # ${work}/proc_annot_stats.disc.xml,
            - Validate_Annotation_xsltproc_asnvalidate/output 
            # ${work}/proc_annot_stats.val.xml'
        linkMerge: merge_flattened
      output_name:
        default: proc_annot_stats.xml
    out: [output]
  Validate_Annotation_collect_annot_details: # TESTED (unit test)
    run: progs/collect_annot_stats.cwl 
    in:
      input:
        source: 
            - Validate_Annotation_bact_univ_prot_stats/var_bact_univ_prot_details_xml
            # '${work}/bact_univ_prot_details.xml,
            - Validate_Annotation_proc_annot_stats/var_proc_annot_details_xml
            # ${work}/proc_annot_details.xml'
        linkMerge: merge_flattened
      output_name:
        default: proc_annot_details.xml
    out: [output]
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
    outputSource: Final_Bacterial_Package_sqn2gbent/output
 
