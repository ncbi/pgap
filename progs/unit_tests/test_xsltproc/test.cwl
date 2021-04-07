#!/usr/bin/env cwl-runner
label: "PGAP Pipeline"
cwlVersion: v1.2
class: Workflow

requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
    
inputs:
  validation_xml: File 
  asndisc_xml: File
  asn2pas_xsl: File
steps:
  test_asnvalidate:
    run: ../../xsltproc.cwl
    in:
      xml: validation_xml # Final_Bacterial_Package_std_validation/outval # final_bacterial_package.10054022/out/annot.val.summary.xml
      xslt: asn2pas_xsl # /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/home/badrazat/local-install/2018-05-17/etc/asn2pas.xsl)
      output_name: 
        default: 'var_proc_annot_stats.val.xml'
    out: [output]
  test_asndisc:
    run: ../../xsltproc.cwl
    in:
      xml: asndisc_xml # Final_Bacterial_Package_std_validation/outdiscxml # final_bacterial_package.10054022/out/annot.disc.xml
      xslt: asn2pas_xsl # /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/home/badrazat/local-install/2018-05-17/etc/asn2pas.xsl)
      output_name: 
        default: 'var_proc_annot_stats.disc.xml'
    out: [output]
   
outputs:
  asndisc:
    type: File
    outputSource: test_asndisc/output
  asnvalidate:
    type: File
    outputSource: test_asnvalidate/output
