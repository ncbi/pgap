#!/usr/bin/env cwl-runner
cwlVersion: v1.0
label: "pgapx_yaml_ctl"
doc: "Converts input JSON file to ASN.1 template"
class: CommandLineTool
baseCommand: pgapx_yaml_ctl
requirements:
  - class: InlineJavascriptRequirement

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
    ifmt:
        type: string
        default: 'JSON'
        inputBinding:
            prefix: -ifmt
    ofmt:
        type: string
        default: 'JSON'
        inputBinding:
            prefix: -ofmt
    output_entries_name:
        type: string
        default: input_entries.asn
        inputBinding:
            prefix: -output-entries
    output_seq_submit_name:
        type: string
        default: input_seq_submit.sqn
        inputBinding:
            prefix: -output-seq-submit
    output_ltp_name:
        type: string
        default: genome.ltp.txt
        inputBinding:
            prefix: -output-ltp
    taxon_db:
        type: File
        inputBinding:
            prefix: -taxon-db
outputs:
    output_entries:
        type: File?
        outputBinding:
            glob: $(inputs.output_entries_name)
    output_seq_submit:
        type: File?
        outputBinding:
            glob: $(inputs.output_seq_submit_name)
    output_ltp:
        type: File
        outputBinding:
            glob: $(inputs.output_ltp_name)
