class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: fastaval
baseCommand:
  - fastaval
inputs:
  - id: in
    type: File?
    inputBinding:
      position: 0
      prefix: '-in'
  - id: input
    type: File?
    inputBinding:
      position: 0
  - id: outname
    type: string?
    inputBinding:
      position: 0
      prefix: '-out'
  - 'sbg:toolDefaultValue': '0'
    id: check_min_seqlen
    type: int?
    inputBinding:
      position: 0
      prefix: '-check_min_seqlen'
  - 'sbg:toolDefaultValue': '0'
    id: max_seqid_count
    type: int?
    inputBinding:
      position: 0
      prefix: '-max_seqid_count'
    doc: Maximum number of sequence IDs per sequence (0 means unlimited)
  - id: allow_implicit_gnl
    type: boolean?
    inputBinding:
      position: 0
      prefix: '-allow_implicit_gnl'
    doc: >-
      Allow sequence IDs lacking the gnl| prefix to be interpreted as 'general' 
      db/tag IDs (default is not to allow this)
  - id: disallow_seqid_type
    type: string?
    inputBinding:
      position: 0
      prefix: '-disallow_seqid_type'
    doc: Sequence ID types that are not allowed.
  - id: check_internal_ns
    type: boolean?
    inputBinding:
      position: 0
      prefix: '-check_internal_ns'
    doc: Check for internal N's
outputs:
  - id: out
    type: File?
    outputBinding:
      glob: $(inputs.outname)
label: fastaval
requirements:
  - class: InlineJavascriptRequirement
