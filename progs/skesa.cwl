#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: skesa
inputs:
  reads:
    type: File?
    inputBinding:
      prefix: --reads
  sra_run:
    type: string?
    inputBinding:
      prefix: --sra_run
  use_paired_ends:
    type: boolean?
    inputBinding:
      prefix: --use_paired_ends
  contigs_out_name:
    type: string?
    default: contigs.out
    inputBinding:
      prefix: --contigs_out
outputs:
  contigs_out:
    type: File
    outputBinding:
      glob: $(inputs.contigs_out_name)
