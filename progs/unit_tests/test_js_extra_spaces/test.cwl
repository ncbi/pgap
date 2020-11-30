#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow
label: "test 8 space problem"
requirements:
  - class: SubworkflowFeatureRequirement
inputs:

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
  
  cat:
    label: "cat"
    run: cat.cwl 
    in:
      blastdb_dir: blastdb_dir
      blastdb: 
        default: 
          - blastdb
          - blast_rules_db
        linkMerge: merge_flattened
      all_order_specific_blastdb: Get_Order_Specific_Strings/values
    out: [ ]

