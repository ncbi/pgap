class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: generate_fscr_feats
baseCommand: generate_fscr_feats
arguments: [ -nogenbank  ]
label: generate_fscr_feats
inputs:
    input:
        type: File
        inputBinding:
            prefix: '-input'
    excluded_seqs:
        type: File?
        inputBinding:
            prefix: '-excluded-seqs'
    label_suffix:
        type: string
        inputBinding:
            prefix: '-label-suffix'
    source:
        type: string
        inputBinding:
            prefix: '-source'
    o:
        type: string
        inputBinding:
            prefix: '-o'
outputs:
    feats:
        type: File
        outputBinding:
          glob: $(inputs.o)


