cwlVersion: v1.0
label: "bact_univ_prot_stats"

class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest
requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entryname: A.mft
        # using more than line of JS code leads to a wrong result
        entry: ${var blob = ''; for (var i = 0; i < inputs.A.length; i++) { blob += inputs.A[i].path + '\n'; } return blob; }
      - entryname: B.mft
        # using more than line of JS code leads to a wrong result
        entry: ${var blob = ''; for (var i = 0; i < inputs.B.length; i++) { blob += inputs.B[i].path + '\n'; } return blob; }

baseCommand: bact_univ_prot_stats
inputs:
  annot_request_id: # -1
    type: int
    inputBinding:
      prefix: -annot-request-id
  hmm_search:
    type: File
    inputBinding:
      prefix: -hmm-search
  hmm_search_proteins: # genemark models
    type: File
    inputBinding:
      prefix: -hmm-search-proteins
  input:  # annot-full.ent
    type: File
    inputBinding:
      prefix: -input
  bact_univ_prot_stats_old_xml_name:  # annot-full.ent
    type: File
    default: bact_univ_prot_stats_old.xml
    inputBinding:
      prefix: -o
  univ_prot_xml:  # /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/home/badrazat/local-install/2018-05-17/third-party/data/BacterialPipeline/uniColl/ver-3.2/universal.xml 
    type: File
    inputBinding:
      prefix: -univ-prot-xml
  val_res_den_xml:  # /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/home/badrazat/local-install/2018-05-17/etc/validation-results.xml
    type: File
    inputBinding:
      prefix: -val-res-den-xml
  var_bact_univ_prot_details_xml_name:
    type: File
    default: var_bact_univ_prot_details.xml
    inputBinding:
      prefix: -xml-pgap-details
  var_bact_univ_prot_stats_xml_name:
    type: File
    default: var_bact_univ_prot_stats.xml
    inputBinding:
      prefix: -xml-pgap-output
  it:
    type: boolean?
    inputBinding:
      prefix: -it
outputs:
  bact_univ_prot_stats_old_xml:  
    type: File
    outputBinding:
      glob: $(inputs.bact_univ_prot_stats_old_xml_name)

  var_bact_univ_prot_details_xml:  
    type: File
    outputBinding:
      glob: $(inputs.var_bact_univ_prot_details_xml_name)
  
  var_bact_univ_prot_stats_xml:  
    type: File
    outputBinding:
      glob: $(inputs.var_bact_univ_prot_stats_xml_name)
  
