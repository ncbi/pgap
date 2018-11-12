class: Workflow
cwlVersion: v1.0
id: vecscreen
label: vecscreen
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: adaptor_fasta
    type: File
    'sbg:x': -73
    'sbg:y': 187
  - id: contam_in_prok_blastdb_dir
    type: Directory
    'sbg:x': -72.5
    'sbg:y': 310.5
  - id: contig_fasta
    type: File
    'sbg:x': -44
    'sbg:y': -105
outputs:
  - id: out_cache_dir
    outputSource:
      - Foreign_Screen/out_cache_dir
    type: Directory
    'sbg:x': 636.3505859375
    'sbg:y': -182
  - id: contamination_feats
    outputSource:
      - Contamination_Screen/feats
    type: File
  - id: foreign_feats
    outputSource:
      - Foreign_Screen/feats
    type: File
    'sbg:x': 620
    'sbg:y': 90
  - id: blast_align
    outputSource:
      - Contamination_Screen/blast_align
    type: File
    'sbg:x': 666
    'sbg:y': 451
  - id: filtered_align
    outputSource:
      - Contamination_Screen/filtered_align
    type: File
    'sbg:x': 652
    'sbg:y': 308
  - id: hits
    outputSource:
      - Foreign_Screen/hits
    type: File
    'sbg:x': 630.3136596679688
    'sbg:y': -38.5
  - id: adaptor_blastdb_dir
    outputSource:
      - Foreign_Screen/adaptor_blastdb_dir
    type: Directory
    'sbg:x': 735.3136596679688
    'sbg:y': 208.5
steps:
  - id: Contamination_Screen
    in:
      - id: asn_cache
        source: Foreign_Screen/out_cache_dir
      - id: contam_in_prok_blastdb_dir
        source: contam_in_prok_blastdb_dir
      - id: contig_gilist
        source: Foreign_Screen/contig_ids_out
    out:
      - id: blast_align
      - id: feats
      - id: filtered_align
    run: ../vecscreen/bacterial_screening.cwl
    label: bacterial_screening
    doc: >-
      corresponds to bacterial_screening plane in in foreign contamination
      screening graph of classic Gpipe
    'sbg:x': 427.3505859375
    'sbg:y': 287
  - id: Foreign_Screen
    in:
      - id: adaptor_fasta
        source: adaptor_fasta
      - id: contig_fasta
        source: contig_fasta
    out:
      - id: adaptor_blastdb_dir
      - id: contig_ids_out
      - id: feats
      - id: hits
      - id: out_cache_dir
    run: ../vecscreen/foreign_screening.cwl
    label: foreign_screening
    doc: >-
      corresponds to part of default plane in foreign contamination screening
      graph of classic Gpipe
    'sbg:x': 161.5
    'sbg:y': 39.5
requirements:
  - class: SubworkflowFeatureRequirement
