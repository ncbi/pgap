#!/usr/bin/env cwl-runner
label: "Create Genomic Collection for Bacterial Pipeline, ASN.1 input"
cwlVersion: v1.0
class: Workflow

requirements:
  - class: ScatterFeatureRequirement        

inputs:
  entries: File?
  seq_submit: File?
  taxid: int
  gc_assm_name: string
  taxon_db: File
outputs:
  ids_out:
    type: File
    outputSource: Cache_Seq_entries/oseq_ids
  asncache:
    type: Directory
    outputSource: Cache_Seq_entries/asn_cache 
  gencoll_asn:
    type: File
    outputSource: Create_Assembly_From_Sequences/gencoll_asn
  seqid_list:
    type: File
    outputSource: Extract_Assembly_Information/seqid_list
  stats_report:
    type: File
    outputSource: Extract_Assembly_Information_XML/stats_report
  submit_block_template:
    type: File
    outputSource: Prepare_Seq_entries/submit_block
steps:
  Prepare_Seq_entries:
    run: ../progs/prepare_seq_entry_input.cwl
    in: 
        entries: entries
        seq_submit: seq_submit
    out: [order, submit_block, out_entries]
  Cache_Seq_entries:
    run: ../progs/prime_cache.cwl
    in:
        input: Prepare_Seq_entries/out_entries
        taxon_db: taxon_db
        taxid: taxid
        ifmt: 
            default: asn-seq-entry
    out: [oseq_ids, asn_cache]
  Create_Assembly_From_Sequences:
    run: gc_create.cwl
    in:
      unplaced: Cache_Seq_entries/oseq_ids 
      asn_cache: Cache_Seq_entries/asn_cache 
      gc_assm_name: gc_assm_name
    out: [gencoll_asn]

  Extract_Assembly_Information:
    run: gc_get_molecules.cwl
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
    
