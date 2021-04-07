class: Workflow
cwlVersion: v1.2
id: tt_univec_wnode
doc: univ_wnode
label: univec_wnode
requirements: 
    - class: MultipleInputFeatureRequirement
    
inputs:
  asn_cache:
    type: Directory
  blastdb:
    type: string
  blastdb_dir:
    type: Directory
  gilist:
    type: File
steps:
  gpx_qsubmit:
    run: ../progs/gpx_qsubmit.cwl
    label: gpx_qsubmit
    in:
      proteins:
        default:
            class: File
            path: '/dev/null'
            basename: 'null'
            contents: ''
      asn_cache:
        source: [asn_cache]
        linkMerge: merge_flattened
      blastdb:
        source: [blastdb]
        linkMerge: merge_flattened
      blastdb_dir: blastdb_dir
      ids:
        source: [gilist]
        linkMerge: merge_flattened
    out: [jobs]
  univec_wnode:
    run: ../progs/univec_wnode.cwl
    label: univec_wnode
    in:
      input_jobs: gpx_qsubmit/jobs
      asn_cache: asn_cache
      blastdb_dir: blastdb_dir
    out: [outdir]
  gpx_qdump:
    run: ../progs/gpx_qdump.cwl
    label: gpx_qdump
    in:
      input_path: univec_wnode/outdir
      unzip:
        default: '*'
    out: [output]
  generate_fscr_feats:
    run: ../progs/generate_fscr_feats.cwl
    label: generate_fscr_feats
    in:
      input: gpx_qdump/output
      label_suffix:
        default: Adaptor
      source:
        default: vector
      o:
        default: fscr_feats.asn
    out: [feats]
outputs:
  feats:
    type: File
    outputSource: generate_fscr_feats/feats
  hits:
    type: File
    outputSource: gpx_qdump/output
