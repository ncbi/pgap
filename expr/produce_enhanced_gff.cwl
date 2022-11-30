#!/usr/bin/env cwl-runner

label: "Produce Prokka and Roary ready GFF enhancement = GFF + nuc FASTA"
cwlVersion: v1.2
class: ExpressionTool
requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.gff)
        writable: False
      - entry: $(inputs.fasta)
        writable: False
inputs:
  gff:
    type: File
    inputBinding:
      loadContents: true    
  separator:
    type: string?
    default: '### FASTA'
  fasta:
    type: File
    inputBinding:
      loadContents: true    
  output_name:
    type: string?
    default: 'annot_with_genomic_fasta.gff'
outputs:
  output: 
    type: File
expression: |
  ${
    var r={"output": {}};
    r.output.contents = inputs.gff.contents + inputs.separator + '\n' + inputs.fasta.contents;
    // r.output.contents = inputs.gff; // DEBUG
    r.output.class = "File";
    r.output.basename = inputs.output_name;
    return r;
  }