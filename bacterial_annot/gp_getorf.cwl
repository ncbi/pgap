cwlVersion: v1.0
label: "Get ORFs"
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/pgap:latest

requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.asn_cache)
        writable: True
    
#gp_getorf -allowable-starts from-stop-to-stop -asn-cache sequence_cache -ifmt seq-entries-b -input-manifest inseq.mft -max-seq-gap 10000 -minsize 45 -seq-output entries.asnb
baseCommand: gp_getorf
arguments: [ -allowable-starts, from-stop-to-stop, -ifmt, seq-entries-b, -max-seq-gap, "10000", -minsize, "45" ]
inputs:
  asn_cache:
    type: Directory
    inputBinding:
      prefix: -asn-cache
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
  asncache:
    type: Directory
    outputBinding:
      glob: $(inputs.asn_cache.basename)
  outseqs:
    type: File
    outputBinding:
      glob: $(inputs.outfile)
