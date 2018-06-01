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
    default: protein.fa
    inputBinding:
        prefix: -o
outputs:
    fasta:
        type: File
        outputBinding:
            glob: $(inputs.fasta_name)

    