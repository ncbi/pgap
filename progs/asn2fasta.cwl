cwlVersion: v1.0 
label: "asn2fasta"

class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest
baseCommand: asn2fasta
inputs:
  i: 
    type: File
    inputBinding:
        prefix: -i
  type:
    type: string
    inputBinding:
        prefix: -type 
  serial: 
    type: string?
    inputBinding:
        prefix: -serial
  prots_only: 
    type: boolean?
    inputBinding:
        prefix: -prots-only
  fasta_name:
    type: string?
    inputBinding:
        prefix: -o
  nuc_fasta_name:
    type: string?
    inputBinding:
        prefix: -on
  prot_fasta_name:
    type: string?
    inputBinding:
        prefix: -op
outputs:
    fasta:
        type: File?
        outputBinding:
            glob: $(inputs.fasta_name)
    nuc_fasta:
        type: File?
        outputBinding:
            glob: $(inputs.nuc_fasta_name)
    prot_fasta:
        type: File?
        outputBinding:
            glob: $(inputs.prot_fasta_name)

    