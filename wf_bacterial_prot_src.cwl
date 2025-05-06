#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: Workflow
label: "Get Proteins"

requirements: 
  - class: SubworkflowFeatureRequirement 
inputs:
  uniColl_asn_cache: Directory
  naming_sqlite: File
  taxid: int
  tax_sql_file: File
  blastdb_dir: Directory 
  all_order_specific_blastdb: string[]
outputs:
  universal_clusters:
    type: File
    outputSource: Get_Proteins_app/universal_clusters
  all_prots:
    type: File
    outputSource: Get_Proteins_app/all_prots
  selected_blastdb:
    type: string[]
    outputSource: File2Basenames/values
steps:
  Get_Proteins_app:
    label: "Get Proteins: application run"
    run: protein_alignment/bacterial_prot_src.cwl
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
      all_order_specific_blastdb: all_order_specific_blastdb
    out: [ universal_clusters, all_prots, selected_blastdb ]
  File2Basenames:
    # worth describing a trick here:
    # Get_Proteins_app/selected_blastdb is a manifest File in Gpipe sense. It contains full absolute paths
    # to order specific blastdb 
    #
    # file paths are transient and unreliable, but information here is in the basename of the selected blastdb, which is 
    # a persistent name findable under the unicol reference data
    #
    # Bottom line: no, we cannot pass manifests from one step to another, we are just using a clever trick here
    #
    run: progs/file2basenames.cwl
    in:
      input: Get_Proteins_app/selected_blastdb
    out: [values]

