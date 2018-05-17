cwlVersion: v1.0
label: "Extract ORF Proteins"
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest

#protein_extract -input-manifest models.mft -o proteins.asn -olds2 LDS2 -oseqids proteins.seq_ids -nogenbank
baseCommand: protein_extract
inputs:
  input:
    type: File
    inputBinding:
      prefix: -input
  nogenbank:
    type: boolean
    inputBinding:
      prefix: -nogenbank
  oproteins:
    type: string?
    default: "proteins.asn"
    inputBinding:
      prefix: -o
  olds2:
    type: string?
    default: "LDS2"
    inputBinding:
      prefix: -olds2
  oseqids:
    type: string?
    default: "proteins.seq_ids"
    inputBinding:
      prefix: -oseqids

outputs:
  proteins:
    type: File
    outputBinding:
      glob: $(inputs.oproteins)
  lds2:
    type: File
    outputBinding:
      glob: $(inputs.olds2)
  seqids:
    type: File
    outputBinding:
      glob: $(inputs.oseqids)
