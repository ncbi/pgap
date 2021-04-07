#!/usr/bin/env cwl-runner
label: "PGAP Pipeline"
cwlVersion: v1.2
class: Workflow

requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
    
inputs:
  var_bact_univ_prot_stats_xml: File
  var_proc_annot_stats_xml: File
  xsltproc_asndisc: File
  xsltproc_asnvalidate: File
  var_bact_univ_prot_details_xml: File # Validate_Annotation_bact_univ_prot_stats/var_bact_univ_prot_details_xml
# '${work}/bact_univ_prot_details.xml,
  var_proc_annot_details_xml: File # Validate_Annotation_proc_annot_stats/var_proc_annot_details_xml
steps:
  test_stats:
    run: ../../collect_annot_stats.cwl
    in:
      input:
        source:  
            - var_bact_univ_prot_stats_xml # Validate_Annotation_bact_univ_prot_stats/var_bact_univ_prot_stats_xml 
            # '${work}/bact_univ_prot_stats.xml,
            - var_proc_annot_stats_xml # Validate_Annotation_proc_annot_stats/var_proc_annot_stats_xml 
            # ${work}/proc_annot_stats.xml,
            - xsltproc_asndisc # Validate_Annotation_xsltproc_asndisc/output 
            # ${work}/proc_annot_stats.disc.xml,
            - xsltproc_asnvalidate # Validate_Annotation_xsltproc_asnvalidate/output 
            # ${work}/proc_annot_stats.val.xml'
        linkMerge: merge_flattened
      output_name:
        default: proc_annot_stats.xml
    out: [output]
  test_details:
    run: ../../collect_annot_stats.cwl
    in:
      input:
      
        source: 
            - var_bact_univ_prot_details_xml # Validate_Annotation_bact_univ_prot_stats/var_bact_univ_prot_details_xml
            # '${work}/bact_univ_prot_details.xml,
            - var_proc_annot_details_xml # Validate_Annotation_proc_annot_stats/var_proc_annot_details_xml
            # ${work}/proc_annot_details.xml'
        linkMerge: merge_flattened
      output_name:
        default: proc_annot_details.xml
    out: [output]
   
outputs:
  stats:
    type: File
    outputSource: test_stats/output
  details:
    type: File
    outputSource: test_details/output
