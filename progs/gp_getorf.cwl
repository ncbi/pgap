cwlVersion: v1.2
label: "gp_getorf"

class: CommandLineTool

#gp_getorf -allowable-starts from-stop-to-stop -asn-cache sequence_cache -ifmt seq-entries-b -input-manifest inseq.mft -max-seq-gap 10000 -minsize 45 -seq-output entries.asnb
baseCommand: gp_getorf
arguments: [ -nogenbank ]
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
  input:
    type: File
    inputBinding:
      prefix: -input
  max_seq_gap:
    type: int?
    default: 10000
    inputBinding:
      prefix: -max-seq-gap
  minsize:
    type: int?
    default: 42
    inputBinding:
      prefix: -minsize
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

