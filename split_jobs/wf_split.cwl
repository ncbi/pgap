 #!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

label: "Seed Search Compartments"

inputs:
  chunk_size: string?
  nchunks: string?
  suffix: string?
  input: File
  mask: string?
  outdir_name: string?

outputs:
  outdir: 
    type: Directory
    outputSource: to_folder/outdir

steps:
  split:
    run: split.cwl
    in:
      chunk_size: chunk_size
      nchunks: nchunks
      suffix: suffix
      input: input
      mask: mask
    out: [jobs]

  to_folder:
    run: ctf.cwl
    in:
      outdir_name: outdir_name
      files: split/jobs
    out: [outdir]
