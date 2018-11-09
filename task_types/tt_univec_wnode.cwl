class: Workflow
cwlVersion: v1.0
id: tt_univec_wnode
doc: univ_wnode
label: univec_wnode
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
inputs:
  - id: asn_cache
    type: Directory
    'sbg:x': -1
    'sbg:y': 465
  - id: blastdb
    type: string
    'sbg:x': 0
    'sbg:y': 321
  - id: blastdb_dir
    type: Directory
    'sbg:x': 0
    'sbg:y': 205
  - id: gilist
    type: File
    'sbg:x': 0
    'sbg:y': 74
outputs:
  - id: feats
    outputSource:
      - generate_fscr_feats/feats
    type: File
    'sbg:x': 704
    'sbg:y': 353
  - id: hits
    outputSource:
      - gpx_qdump/output
    type: File
    'sbg:x': 550
    'sbg:y': 66
steps:
  - id: generate_fscr_feats
    in:
      - id: input
        source: gpx_qdump/output
      - id: label_suffix
        default: Adaptor
      - id: source
        default: vector
    out:
      - id: feats
    run: ../progs/generate_fscr_feats.cwl
    label: generate_fscr_feats
    'sbg:x': 559
    'sbg:y': 335
  - id: gpx_qdump
    in:
      - id: input_path
        source: univec_wnode/outdir
      - id: unzip
        default: '*'
    out:
      - id: output
    run: ../progs/gpx_qdump.cwl
    label: gpx_qdump
    'sbg:x': 403
    'sbg:y': 277
  - id: gpx_qsubmit
    in:
      - id: asn_cache
        source:
          - asn_cache
      - id: blastdb
        source:
          - blastdb
      - id: blastdb_dir
        source:
          - blastdb_dir
      - id: ids
        source:
          - gilist
    out:
      - id: jobs
    run: ../progs/gpx_qsubmit.cwl
    label: gpx_qsubmit
    'sbg:x': 179
    'sbg:y': 86
  - id: univec_wnode
    in:
      - id: input_jobs
        source: gpx_qsubmit/jobs
    out:
      - id: outdir
    run: ../progs/univec_wnode.cwl
    label: univec_wnode
    'sbg:x': 296
    'sbg:y': 198
requirements: []
