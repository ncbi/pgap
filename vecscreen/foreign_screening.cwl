class: Workflow
cwlVersion: v1.2
id: foreign_screening
label: foreign_screening
requirements:
  - class: SubworkflowFeatureRequirement
inputs:
  adaptor_fasta:
    type: File
  contig_fasta:
    type: File
steps:
  Cache_WGS_contig_FASTA:
    run: ../progs/prime_cache.cwl
    label: prime_cache
    in:
      input:
        source: contig_fasta
    out: [asn_cache, oseq_ids]
  Create_Adaptor_BLASTdb:
    run: ../progs/gp_makeblastdb.cwl
    label: gp_makeblastdb
    in:
      asn_cache:
        source: [Cache_WGS_contig_FASTA/asn_cache]
        linkMerge: merge_flattened
      fasta:
        source: adaptor_fasta
      title:
        default: BLASTdb created by GPipe
      dbtype:
        default: nucl
    out: [blastdb]
  Align_To_Adaptor:
    run: ../task_types/tt_univec_wnode.cwl
    label: univec_wnode
    in:
      asn_cache:
        source: Cache_WGS_contig_FASTA/asn_cache
      blastdb_dir:
        source: Create_Adaptor_BLASTdb/blastdb
      blastdb:
        default: 'blastdb'
      gilist:
        source: Cache_WGS_contig_FASTA/oseq_ids
    out: [feats, hits]
outputs:
  adaptor_blastdb_dir:
    outputSource: Create_Adaptor_BLASTdb/blastdb
    type: Directory
  contig_ids_out:
    outputSource: Cache_WGS_contig_FASTA/oseq_ids
    type: File
  feats:
    outputSource:  Align_To_Adaptor/feats
    type: File
  hits:
    outputSource: Align_To_Adaptor/hits
    type: File
  out_cache_dir:
    outputSource: Cache_WGS_contig_FASTA/asn_cache
    type: Directory
