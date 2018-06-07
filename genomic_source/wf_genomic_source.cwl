#!/usr/bin/env cwl-runner
label: "Create Genomic Collection for Bacterial Pipeline"
cwlVersion: v1.0
class: Workflow

requirements:
  - class: ScatterFeatureRequirement        

inputs:
  fasta: File
  submit_block_template: File
  taxid: int
  gc_assm_name: string
  taxon_db: File
  # sequence_cache_shortcut: Directory
  # ids_out_shortcut: File
outputs:
  ids_out:
    type: File
    outputSource: Cache_FASTA_Sequences/ids_out
    # outputSource: ids_out_shortcut
  asncache:
    type: Directory
    outputSource: Cache_FASTA_Sequences/asncache # waiting for GP-24223
    # outputSource: sequence_cache_shortcut # this is over when GP-24223 is resolved
    
  gencoll_asn:
    type: File
    outputSource: Create_Assembly_From_Sequences/gencoll_asn
  seqid_list:
    #type: File[]
    type: File
    outputSource: Extract_Assembly_Information/seqid_list
  stats_report:
    type: File
    outputSource: Extract_Assembly_Information_XML/stats_report
  
  
    
steps:
  #### waiting for GP-24223
  #### commented out
  Cache_FASTA_Sequences:
    run: prime_cache.cwl
    in:
      fasta: fasta
      submit_block_template: submit_block_template
      taxon_db: taxon_db
      taxid: taxid
    out: [ids_out, asncache]

  Create_Assembly_From_Sequences:
    run: gc_create.cwl
    in:
      unplaced: Cache_FASTA_Sequences/ids_out # waiting for GP-24223
      # unplaced: ids_out_shortcut  # waiting for GP-24223
      asn_cache: Cache_FASTA_Sequences/asncache # waiting for GP-24223
      # asn_cache: sequence_cache_shortcut  # waiting for GP-24223
      
      gc_assm_name: gc_assm_name

    out: [gencoll_asn]

  Extract_Assembly_Information:
    run: gc_get_molecules.cwl
    # 
    #   In Classic PGAP we call this many times to produce all kind of filtered output, while
    #   using only one filtered output: reference-no-organelle downstream
    #
    #scatter: [ filter, outfile ]
    #scatterMethod: dotproduct
    in:
      gc_assembly: Create_Assembly_From_Sequences/gencoll_asn
      filter:
        #default: ["all", "all-no-organelle", "non-reference-no-organelle", "organelle", "reference-no-organelle"]
        default: "reference-no-organelle"
      outfile:
        #default: ["all.gi", "no_organelle.gi", "no_ref_no_organelle.gi", "organelle.gi", "ref_no_organelle.gi"]
        default: "ref_no_organelle.gi"
    out: [seqid_list]
      
  Extract_Assembly_Information_XML:
    run: gc_asm_xml_description.cwl
    in:
      asnfile: Create_Assembly_From_Sequences/gencoll_asn
    out: [stats_report]
    
