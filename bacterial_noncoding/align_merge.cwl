cwlVersion: v1.0
label: "Merge rRNA Alignments"
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/pgap:latest

requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.asn_cache)
        writable: False
      - entry: $(inputs.blastdb_dir)
        writable: False
    
#align_merge -blastdb blastdb -asn-cache sequence_cache -filter 'align_length >= 60' -ifmt seq-align-set -input-manifest align.mft -logfile align_merge.log -max-discontinuity 20 -o align.asn -collated -compart -fill-gaps
baseCommand: align_merge
arguments: [ -filter, "align_length >= 60", -ifmt, seq-align-set, -max-discontinuity, "20", -collated, -compart, -fill-gaps ]
inputs:
  asn_cache:
    type: Directory
    inputBinding:
      prefix: -asn-cache
  blastdb_dir:
    type: Directory
  blastdb:
    type: string
    inputBinding:
      prefix: -blastdb
      valueFrom: $(inputs.blastdb_dir.path)/$(inputs.blastdb)
  alignments:
    type: File
    inputBinding:
      prefix: -input
  output:
    type: string?
    default: align.asn
    inputBinding:
      prefix: -o
outputs:
  aligns:
    type: File
    outputBinding:
      glob: $(inputs.output)

  
  
