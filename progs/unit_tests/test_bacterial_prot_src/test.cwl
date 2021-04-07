#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: Workflow
label: "test bacterial_prot_src"
requirements:
  - class: SubworkflowFeatureRequirement
inputs:

  uniColl_asn_cache: Directory
  naming_sqlite: File
  taxid: 
    type: int
    default: 2097
  tax_sql_file: File
  blastdb_dir: Directory
  all_order_specific_blastdb_file: File

outputs: []
steps:
  Get_Order_Specific_Strings:
    label: "Get List of Order Specific Databases in the form of string[]"
    run: ../../file2basenames.cwl
    in: 
      input: all_order_specific_blastdb_file
    out: [values]
  
  bacterial_prot_src:
    label: "Get Proteins: application run"
    run: ../../../protein_alignment/bacterial_prot_src.cwl 
    in:
      uniColl_asn_cache: uniColl_asn_cache
      naming_sqlite: naming_sqlite
      taxid: taxid
      tax_sql_file: tax_sql_file
      blastdb_dir: blastdb_dir
      blastdb: 
        default: 
          - blastdb
          - blast_rules_db
        linkMerge: merge_flattened
      all_order_specific_blastdb: Get_Order_Specific_Strings/values
    out: [ ]

