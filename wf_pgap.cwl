#!/usr/bin/env cwl-runner
label: "PGAP Pipeline"
cwlVersion: v1.0
class: Workflow

requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: DockerRequirement
    dockerPull: ncbi/pgap:2018-04-16.build2734
    
inputs:
  fasta: File
  submit_block_template: File
  taxid: int
  gc_assm_name: string

  # Cached computational steps
  hmm_hits: File
  
  # Auxillary files
  hmm_path: Directory
  hmms_tab: File
  uniColl_cache: Directory
  gene_master_ini: File
  16s_blastdb_dir: Directory
  23s_blastdb_dir: Directory
  5s_model_path: File
  rfam_model_path: File
  rfam_amendments: File
  rfam_stockholm: File

outputs:
  # aligns: 
  #   type: File
  #   outputSource: bacterial_annot/aligns
  prok_entrez_gene_stuff: 
    type: File
    outputSource: cache_entrez_gene/prok_entrez_gene_stuff
  # annotations_5s:
  #   type: File
  #   outputSource: bacterial_noncoding/annotations_5s
  # annotations_16s:
  #   type: File
  #   outputSource: bacterial_noncoding/annotations_16s
  # annotations_23s:
  #   type: File
  #   outputSource: bacterial_noncoding/annotations_23s
  
  # lds2: 
  #   type: File
  #   outputSource: bacterial_annot/lds2
  # seqids: 
  #   type: File
  #   outputSource: bacterial_annot/seqids
  #strace: 
  #  type: File
  #  outputSource: bacterial_annot/strace
  # sequences:
  #   type: File
  #   outputSource: bacterial_prepare_unannotated/sequences
  # asncache:
  #   type: Directory
  #   outputSource: bacterial_prepare_unannotated/asncache
    
steps:
  genomic_source:
    run: genomic_source/wf_genomic_source.cwl
    in:
      fasta: fasta
      submit_block_template: submit_block_template
      taxid: taxid
      gc_assm_name: gc_assm_name
    out: [gencoll_asn, seqid_list, stats_report, asncache]
    
  bacterial_prepare_unannotated:
    run: bacterial_prepare_unannotated.cwl
    in:
      asn_cache: genomic_source/asncache
      gc_assembly: genomic_source/gencoll_asn
      ids: genomic_source/seqid_list
      submit_block: submit_block_template
    out: [master_desc, sequences]

  cache_entrez_gene:
    run: cache_entrez_gene.cwl
    in:
      asn_cache: [genomic_source/asncache, uniColl_cache]
      egene_ini: gene_master_ini
      input: bacterial_prepare_unannotated/sequences
    out: [prok_entrez_gene_stuff]

  # preserve_annot_markup:
  #   run: preserve_annot_markup.cwl
  #   in:
  #     seq_cache: bacterial_prepare_unannotated/asncache
  #     unicoll_cache: uniColl_cache
  #     asn_cache: [bacterial_prepare_unannotated/asncache, uniColl_cache]
  #     egene_ini: gene_master_ini
  #     gc_assembly: genomic_source/gencoll_asn
      
  #     prok_entrez_gene_stuff: cache_entrez_gene/prok_entrez_gene_stuff
  #   out: [asncache, annotations]
    
  # bacterial_trna:
  #   run: bacterial_trna/wf_trnascan.cwl
  #   in:
  #     asn_cache: genomic_source/asncache
  #     seqids: genomic_source/seqid_list
  #     taxid: taxid
  #   out: [annots]

  # bacterial_ncrna:
  #   run: bacterial_ncrna/wf_gcmsearch.cwl
  #   in:
  #     asn_cache: genomic_source/asncache
  #     seqids: genomic_source/seqid_list
  #     model_path: rfam_model_path
  #     rfam_amendments: rfam_amendments
  #     rfam_stockholm: rfam_stockholm
  #   out: [annots]
    
  # bacterial_annot:
  #   run: bacterial_annot/wf_bacterial_annot.cwl
  #   in:
  #     asn_cache: bacterial_prepare_unannotated/asncache
  #     inseq: bacterial_prepare_unannotated/sequences
  #     hmm_path: hmm_path
  #     hmms_tab: hmms_tab
  #     uniColl_cache: uniColl_cache
  #     hmm_hits: hmm_hits
  #     trna_annots: bacterial_trna/annots
  #     ncrna_annots: bacterial_ncrna/annots

  #   out:
  #     #[lds2,seqids]
  #     #[strace]
  #     #[hmm_hits]
  #     [aligns]

  # bacterial_noncoding:
  #   run: bacterial_noncoding/wf_bacterial_noncoding.cwl
  #   in:
  #     asn_cache: genomic_source/asncache
  #     seqids: genomic_source/seqid_list
  #     16s_blastdb_dir: 16s_blastdb_dir
  #     23s_blastdb_dir: 23s_blastdb_dir
  #     model_path: 5s_model_path
  #     rfam_amendments: rfam_amendments
  #     rfam_stockholm: rfam_stockholm
  #   out: [ annotations_5s, annotations_16s, annotations_23s ]

