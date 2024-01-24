#!/usr/bin/env cwl-runner

cwlVersion: v1.2
class: Workflow

label: "Align reference proteins plane complete workflow"

requirements: 
  - class: SubworkflowFeatureRequirement 
 
inputs:
  go: 
        type: boolean[]
  asn_cache: Directory
  uniColl_asn_cache: Directory
  blastdb_dir: Directory # genomic
  taxid: int
  tax_sql_file: File
  gc_assembly: File
  compartments: File
  all_prots: File

outputs:
  align:  
    type: File
    outputSource: Filter_Protein_Alignments/align
  align_non_match:  
    type: File
    outputSource: Filter_Protein_Alignments/align_non_match
steps:
  Compute_Gencode:
    run: ../progs/compute_gencode.cwl
    in:
        taxid: taxid
        taxon_db: tax_sql_file
        gencode: 
            default: true
    out: [ output ]
  Compute_Gencode_int:
    run: ../progs/file2int.cwl
    in:
        input: Compute_Gencode/output
    out: [ value ]
  Seed_Search_Compartments:
    run: wf_seed.cwl
    in:
      db_gencode: Compute_Gencode_int/value
      asn_cache: asn_cache
      uniColl_asn_cache: uniColl_asn_cache
      compartments: compartments
    out: [ blast_align ]

  Seed_Protein_Alignments:
    run: wf_seed_1.cwl
    in:
      db_gencode: Compute_Gencode_int/value
      asn_cache: asn_cache
      uniColl_asn_cache: uniColl_asn_cache
      seqids: all_prots # Get_Proteins/all_prots
      blastdb_dir: blastdb_dir
    out: [ blast_align ]

  cat:
    run: cat.cwl
    in:
      file_in_1st: Seed_Protein_Alignments/blast_align
      file_in_2nd: Seed_Search_Compartments/blast_align
    out: [ file_out ]

  Sort_Seed_Hits:
    run: align_sort.cwl
    in:
      asn_cache: asn_cache
      uniColl_asn_cache: uniColl_asn_cache
      blast_aligns: cat/file_out
      limit_mem: 
        default: '1G'      
    out: [ sorted_aligns ]

  Filter_Full_Coverage_Alignments:
    run: bacterial_protalign_filter.cwl
    in:
      asn_cache: asn_cache
      uniColl_asn_cache: uniColl_asn_cache
      sorted_seeds: Sort_Seed_Hits/sorted_aligns
    out: [ blast_full_cov, blast_partial_cov ]

  compart_filter_prosplign:
    run: wf_compart_filter_prosplign.cwl
    in:
      asn_cache: asn_cache
      uniColl_asn_cache: uniColl_asn_cache
      seed_hits: Filter_Full_Coverage_Alignments/blast_partial_cov
      gc_assembly: gc_assembly
    out: [ prosplign_align ]

  Filter_Protein_Alignments:
    run: wf_align_filter.cwl
    in:
      asn_cache: asn_cache
      uniColl_asn_cache: uniColl_asn_cache
      blast_full: Filter_Full_Coverage_Alignments/blast_full_cov
      prosplign: compart_filter_prosplign/prosplign_align
    out: [ align, align_non_match ]
