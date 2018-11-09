class: Workflow
cwlVersion: v1.0
id: foreign_screening
label: foreign_screening
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: adaptor_fasta
    type: File
    'sbg:x': -28
    'sbg:y': -18
  - id: cache_dir
    type: Directory
    'sbg:x': -18
    'sbg:y': 113
  - id: contig_fasta
    type: File
    'sbg:x': 0
    'sbg:y': 276.5
outputs:
  - id: adaptor_blastdb_dir
    outputSource:
      - Create_Adaptor_BLASTdb/blastdb
    type: Directory
    'sbg:x': 736
    'sbg:y': -108
  - id: contig_ids_out
    outputSource:
      - Cache_WGS_contig_FASTA/oseq_ids
    type: File
    'sbg:x': 758
    'sbg:y': 259
  - id: feats
    outputSource:
      - Align_To_Adaptor/feats
    type: File
    'sbg:x': 746
    'sbg:y': 135
  - id: hits
    outputSource:
      - Align_To_Adaptor/hits
    type: File
    'sbg:x': 738
    'sbg:y': 14
  - id: out_cache_dir
    outputSource:
      - Cache_WGS_contig_FASTA/asn_cache
    type: Directory
    'sbg:x': 755
    'sbg:y': 407
steps:
  - id: Align_To_Adaptor
    in:
      - id: asn_cache
        source: Cache_WGS_contig_FASTA/asn_cache
      - id: blastdb_dir
        source: Create_Adaptor_BLASTdb/blastdb
      - id: gilist
        source: Cache_WGS_contig_FASTA/oseq_ids
    out:
      - id: feats
      - id: hits
    run: ../task_types/tt_univec_wnode.cwl
    label: univec_wnode
    'sbg:x': 539
    'sbg:y': 37
  - id: Cache_WGS_contig_FASTA
    in:
      - id: cache_dir
        source: cache_dir
      - id: input
        source: contig_fasta
    out:
      - id: asn_cache
      - id: oseq_ids
    run: ../progs/prime_cache.cwl
    label: prime_cache
    'sbg:x': 272
    'sbg:y': 258
  - id: Create_Adaptor_BLASTdb
    in:
      - id: asn_cache
        source:
          - cache_dir
      - id: fasta
        source: adaptor_fasta
      - id: title
        default: BLASTdb created by GPipe
    out:
      - id: blastdb
    run: ../progs/gp_makeblastdb.cwl
    label: gp_makeblastdb
    'sbg:x': 235.5
    'sbg:y': -18
requirements:
  - class: SubworkflowFeatureRequirement
