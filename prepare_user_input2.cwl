#!/usr/bin/env cwl-runner

label: "Prepare user input"
cwlVersion: v1.0
class: Workflow
doc: Prepare user input for  NCBI-PGAP pipeline

requirements:
  - class: MultipleInputFeatureRequirement
  - class: InlineJavascriptRequirement

inputs:
  submol: 
    type: File
  fasta:
    type: File
steps:
    yaml2json:
        label: "yaml2json"
        run: progs/yaml2json.cwl
        in: 
            input: submol
        out: [output]

    pgapx_yaml_ctl:
        label: "pgapx_yaml_ctl"
        run: progs/pgapx_yaml_ctl.cwl
        in:
            input: yaml2json/output
            input_fasta: fasta
        out: [output_fasta, output_template]
outputs:
    submit_block_template: 
        type: File
        outputSource: pgapx_yaml_ctl/output_template
    output_fasta:
        type: File
        outputSource: pgapx_yaml_ctl/output_fasta

