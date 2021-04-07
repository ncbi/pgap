class: CommandLineTool
cwlVersion: v1.2
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: univec_wnode
baseCommand: univec_wnode
requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entry:  $(inputs.blastdb_dir)
        writable: False
      - entry:  $(inputs.asn_cache)
        writable: False
arguments: [ -nogenbank ]
inputs:
  asn_cache:
    type: Directory
    inputBinding:
      prefix: -asn-cache
  blastdb_dir:
    type: Directory
    doc: 'Hidden parameter, hidden within input_jobs:'
  input_jobs:
    type: File?
    inputBinding:
      position: 0
      prefix: '-input-jobs'
    label: input_jobs
    doc: >
        XML file with input univec jobs, this parameter is _referential_
        which CWL does not like.
        
  O:
    type: string?
    default: 'output'
    doc: 'Base path to files of output generated from processes'
    inputBinding:
      position: 0
      prefix: '-O'
outputs:
  outdir:
    type: Directory
    outputBinding:
      glob: $(inputs.O)
label: univec_wnode
