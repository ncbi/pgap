#!/usr/bin/env cwl-runner
label: bacterial_kmer
cwlVersion: v1.0
class: Workflow 
requirements: 
    - class: SubworkflowFeatureRequirement    
    - class: MultipleInputFeatureRequirement
    
inputs:
  # kmer_minhash_tarball: File # tarball of all reference minhashes. For Mycoplasma genitalium, there are 8K files, in total 1G
  Extract_Kmers_From_Input___entry: File
  gencoll_asn: File
  asn_cache: Directory
  # kmer_cache_path: Directory
  kmer_cache_sqlite: File
  kmer_cache_uri: string
  ref_assembly_taxid: int
  ANI_cutoff: File
  kmer_reference_assemblies: File
outputs:
  Identify_Top_N_ANI_annot:
    type: File
    outputSource: Identify_Top_N_ANI/annot
  Identify_Top_N_ANI_top:
    type: File
    outputSource: Identify_Top_N_ANI/top
  Extract_Top_Assemblies___tax_report:
    type: File
    outputSource: Extract_Top_Assemblies/tax_report
steps:
# order manually set to match the order of display on the GPC graph for the plane in the buildrun
  Query_Kmer_Cache:
    run: ../task_types/tt_kmer_cache_retrieve.cwl
    in:
      gc_id_list: kmer_reference_assemblies
      kmer_cache_path: kmer_cache_path
    out: [new_gc_id_list, out_kmer_file_list, out_kmer_cache_path]
  Extract_Kmer_List:
    run: ../task_types/tt_kmer_gc_extract_wnode.cwl
    in:
      new_gc_id_list: Query_Kmer_Cache/new_gc_id_list
      asn_cache: asn_cache
    out: [out_kmer_file_list]
  Store_in_Kmer_Cache:
    run: ../task_types/tt_kmer_cache_store.cwl
    in:
      kmer_cache_path: Query_Kmer_Cache/out_kmer_cache_path
      kmer_file_list: Extract_Kmer_List/out_kmer_file_list
    out: [out_kmer_file_list]
  Extract_Kmers_From_Input:
    run: ../task_types/tt_kmer_seq_entry_extract_wnode.cwl
    in:
      entry: Extract_Kmers_From_Input___entry
      kmer_file_list: 
        source: [Query_Kmer_Cache/out_kmer_file_list, Store_in_Kmer_Cache/out_kmer_file_list]
        linkMerge: merge_flattened
      asn_cache: asn_cache
    out: [out_kmer_file_list]
  Compare_Kmer:
    run: ../task_types/tt_kmer_ref_compare_wnode.cwl
    in:
      kmer_file_list: Extract_Kmers_From_Input/out_kmer_file_list
      ref_kmer_file_list:  
        source: [Query_Kmer_Cache/out_kmer_file_list, Store_in_Kmer_Cache/out_kmer_file_list]
        linkMerge: merge_flattened
      dist_method:
        default: minhash
      minhash_signature:
        default: minhash
      score_method:
        default: boolean
    out: [distances]
  Identify_Top_N:
    run: ../task_types/tt_kmer_top_n.cwl
    in:
      distances: Compare_Kmer/distances
    out: [matches, top_distances]
  Compare_Kmer__Pairwise_:
    run: ../task_types/tt_kmer_compare_wnode.cwl
    in:
      kmer_file_list: 
        source: [Extract_Kmers_From_Input/out_kmer_file_list, Identify_Top_N/matches]
        linkMerge: merge_flattened
      dist_method:
        default: minhash
      minhash_signature:
        default: minhash
      score_method:
        default: boolean
    out: [distances]
  Extract_Top_Assemblies:
    run: ../task_types/tt_kmer_top_n_extract.cwl
    in:
      top_distances: Identify_Top_N/top_distances
      ref_assembly_taxid: ref_assembly_taxid
    out: [tax_report, gc_id_list]
  Build_Kmer_Tree:
    run: ../task_types/tt_kmer_build_tree.cwl
    in:
        distances: Compare_Kmer__Pairwise_/distances
        sort:
            default: leaf-count-ascending
        no_merge:
            default: true
        skip_markup:
            default: true
    out: [tree]
  Get_Top_Assemblies_GenColl_ASN:
    run: ../task_types/tt_gcaccess_from_list.cwl
    in:
      gc_id_list: Extract_Top_Assemblies/gc_id_list
    out: [gencoll_asn]
  Extract_Input_GenColl_IDs:
    run: ../task_types/tt_extract_gencoll_ids.cwl
    in: 
        assemblies: gencoll_asn
    out: [gc_id_list]
  Assembly_Assembly_BLASTn:
    run: ../task_types/tt_assm_assm_blastn_wnode.cwl
    in:
      queries_gc_id_list: Extract_Input_GenColl_IDs/gc_id_list
      subjects_gc_id_list: Extract_Top_Assemblies/gc_id_list
      # this will brea here
      Get_Top_Assemblies_GenColl_ASN_assemblies: Get_Top_Assemblies_GenColl_ASN/gencoll_asn
      gencoll_asn: gencoll_asn
      affinity:
        default: 'subject'
      # settings
      asn_cache: asn_cache
      compart: 
        default: "true"
      evalue: 
        default: 0.0001
      gapextend: 
        default: 1
      gapopen: 
        default: 2
      max_bases_per_call: 
        default: 500000000
      max_target_seqs: 
        default: 250
      merge_align_filter: 
        default: "((reciprocity = 3 AND align_length_ungap >= 5) OR align_length > 1000) AND pct_identity_gap > 25"
      merge_engine: 
        default: "tree-merger"
      soft_masking:  
        default: "true"
      task:  
        default: megablast
      use_common_components:  
        default: "true"
      window_size:  
        default: 150
      word_size:  
        default: 28
      workers_per_cpu:  
        default:  0.4
    out: [blast_align]
  Identify_Top_N_ANI:
    run: ../task_types/tt_ani_top_n.cwl
    in:
        asn_cache: asn_cache
        ANI_cutoff: ANI_cutoff
        gencoll_asn: gencoll_asn
        blast_align: Assembly_Assembly_BLASTn/blast_align
        ref_assembly_taxid: ref_assembly_taxid
    out: [top,annot]
