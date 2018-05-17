cwlVersion: v1.0
label: "Get ORFs"
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest

#gp_getorf -allowable-starts from-stop-to-stop -asn-cache sequence_cache -ifmt seq-entries-b -input-manifest inseq.mft -max-seq-gap 10000 -minsize 45 -seq-output entries.asnb
baseCommand: gp_getorf
inputs:
  allowable_starts:
    type: string?
    default: from-stop-to-stop
    inputBinding:
      prefix: -allowable-starts
  asn_cache:
    type: Directory
    inputBinding:
      prefix: -asn-cache
  ifmt:
    type: string?
    default: seq-entries-b
    inputBinding:
      prefix: -ifmt
  max_seq_gap:
    type: int?
    default: 10000
    inputBinding:
      prefix: -max-seq-gap
  minsize:
    type: int?
    default: 45
    inputBinding:
      prefix: -minsize
  input:
    type: File
    inputBinding:
      prefix: -input
  outfile:
    type: string?
    default: "entries.asnb"
    inputBinding:
      prefix: -seq-output
outputs:
  outseqs:
    type: File
    outputBinding:
      glob: $(inputs.outfile)

