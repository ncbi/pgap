#!/usr/bin/env cwl-runner
label: "PGAP Pipeline"
cwlVersion: v1.2
class: Workflow

requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
    
inputs:
  hmm_hits: File
  hmm_search_proteins: File
  outfull: File
  univ_prot_xml: File
  val_res_den_xml: File
steps:  
  test:
    run: ../..//bact_univ_prot_stats.cwl
    in:
      annot_request_id: 
        default: -1 # this is dummy annot_request_id
      hmm_search: hmm_hits # bacterial_annot_3_Search_Naming_HMMs_hmm_hits_bypass # for bacterial_annot_misc/Search_Naming_HMMs_hmm_hits # Search Naming HMMs bacterial_annot 3       
      hmm_search_proteins: hmm_search_proteins #  bacterial_annot_3_Run_GeneMark_Post_models_bypass # for bacterial_annot_misc/Run_GeneMark_Post_models # genemark models
      input:  outfull # Final_Bacterial_Package_final_bact_asn/outfull
      univ_prot_xml:  univ_prot_xml # /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/home/badrazat/local-install/2018-05-17/third-party/data/BacterialPipeline/uniColl/ver-3.2/universal.xml 
      val_res_den_xml:  val_res_den_xml # /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/home/badrazat/local-install/2018-05-17/etc/validation-results.xml
      it:
        default: true
    out: [bact_univ_prot_stats_old_xml, var_bact_univ_prot_details_xml, var_bact_univ_prot_stats_xml]
      
   
outputs:
  bact_univ_prot_stats_old_xml:
    type: File
    outputSource: test/bact_univ_prot_stats_old_xml
  var_bact_univ_prot_details_xml:
    type: File
    outputSource: test/var_bact_univ_prot_details_xml
  var_bact_univ_prot_stats_xml:
    type: File
    outputSource: test/var_bact_univ_prot_stats_xml
