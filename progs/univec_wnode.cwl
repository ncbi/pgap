class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: univec_wnode
baseCommand:
  - univec_wnode
inputs:
  - id: input_jobs
    type: File?
    inputBinding:
      position: 0
      prefix: '-input-jobs'
    label: input_jobs
    doc: XML file with input univec jobs
  - id: O
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
