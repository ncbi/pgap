#!/usr/bin/env cwl-runner
cwlVersion: v1.0
label: "pgapx_yaml_ctl"
doc: "Converts input JSON file to ASN.1 template"
class: CommandLineTool
baseCommand: pgapx_yaml_ctl

inputs:
    input:
        type: File
        doc: "JSON file with submission and molecule specification"
        inputBinding:
            prefix: -input
    input_fasta:
        type: File
        doc: "FASTA file with user provided headers and user provided prokaryota genome"
        inputBinding:
            prefix: -input-fasta
    output_template_name:
        type: string
        default: input.template
        inputBinding:
            prefix: -output-template
    output_fasta_name:
        type: string
        default: genome.fasta
        inputBinding:
            prefix: -output-fasta

outputs:
    output_template:
        type: File
        doc: "ASN.1 template file recognizable by classic PGAP"
        outputBinding:
            glob: $(inputs.output_template_name)
    output_fasta:
        type: File
        doc: "FASTA file with corrected headers and user provided prokaryota genome"
        outputBinding:
            glob: $(inputs.output_fasta_name)
