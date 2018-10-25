cwlVersion: v1.0
label: "proc_annot_stats"

class: CommandLineTool
hints:
baseCommand: proc_annot_stats
inputs:
  input: # annot.ent
    type: File
    inputBinding:
      prefix: -input
  max_unannotated_region: # 5000
    type: int
    inputBinding:
      prefix: -max-unannotated-region
  univ_prot_xml:  # /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/home/badrazat/local-install/2018-05-17/third-party/data/BacterialPipeline/uniColl/ver-3.2/universal.xml 
    type: File
    inputBinding:
      prefix: -univ-prot-xml
  val_res_den_xml:  # /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/home/badrazat/local-install/2018-05-17/etc/validation-results.xml
    type: File
    inputBinding:
      prefix: -val-res-den-xml
  var_proc_annot_details_xml_name: # /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/home/badrazat/local-install/data/dev/Mycoplasma_genitalium_G37/GP-23495-Create-FASTA-based-Mycoplasma_ge_20180517_1128_my_external_pgap.250744/305417/annot_validate.10054142/var/proc_annot_details.xml 
    type: string
    default: var_proc_annot_details.xml
    inputBinding:
      prefix: -xml-pgap-details
  var_proc_annot_stats_xml_name: # /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/home/badrazat/local-install/data/dev/Mycoplasma_genitalium_G37/GP-23495-Create-FASTA-based-Mycoplasma_ge_20180517_1128_my_external_pgap.250744/305417/annot_validate.10054142/var/proc_annot_details.xml 
    type: string
    default: var_proc_annot_stats.xml
    inputBinding:
      prefix: -xml-pgap-output
  it:
    type: boolean?
    inputBinding:
      prefix: -it
outputs:
  var_proc_annot_stats_xml: 
    type: File
    outputBinding:
      glob: $(inputs.var_proc_annot_stats_xml_name)
  var_proc_annot_details_xml:
    type: File
    outputBinding:
      glob: $(inputs.var_proc_annot_details_xml_name)

  
  
