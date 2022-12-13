#!/usr/bin/env cwl-runner
label: "Produce Roary input"
doc: "Produce Prokka and Roary ready GFF enhancement = GFF + nuc FASTA"
cwlVersion: v1.2
class: CommandLineTool
baseCommand: cat
requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entryname: separator.txt
        entry: ${ return inputs.separator + '\n'; }
inputs:
  gff:
    type: File?
    inputBinding: 
      position: 1
  separator:
    type: string?
    default: '### FASTA'
  separator_file:
    type: string?
    default: 'separator.txt'
    inputBinding: 
      position: 2
  fasta:
    type: File?
    inputBinding:
      position: 3
  output_name:
    type: string?
    default: 'annot_with_genomic_fasta.gff'
stdout: $(inputs.output_name)
outputs:
  output: 
    type: stdout
