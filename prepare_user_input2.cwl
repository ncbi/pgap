#!/usr/bin/env cwl-runner

label: "Prepare user input"
cwlVersion: v1.2
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
  taxon_db:
    type: File
  ignore_all_errors:
    type: boolean?
  no_internet:
    type: boolean?
        
outputs:
    input_asn_type: 
        type: string
        outputSource: file2string_input_asn_type/value
    output_entries:
        type: File?
        outputSource: type_based_splitter/output_entries
    output_seq_submit:
        type: File?
        outputSource: type_based_splitter/output_seq_submit
    locus_tag_prefix:
        type: string
        outputSource: file2string_ltp/value
    submol_block_json:
        type: File
        outputSource: yaml2json/output
    taxid:
        type: int
        outputSource: file2int_taxid/value
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
            taxon_db: taxon_db
            ignore_all_errors: ignore_all_errors
            no_internet: no_internet
        out: [output_annotation, output_ltp, input_asn_type, taxid]
    file2string_ltp:
        run: progs/file2string.cwl
        in:
             input: pgapx_yaml_ctl/output_ltp
        out: [value]
    file2string_input_asn_type:
        run: progs/file2string.cwl
        in:
             input: pgapx_yaml_ctl/input_asn_type
        out: [value]     
    file2int_taxid:
        run: progs/file2int.cwl
        in:
            input: pgapx_yaml_ctl/taxid
        out: [value]
    initial_cleanup:
        run: progs/asn_cleanup.cwl
        in:
            inp_annotation:  pgapx_yaml_ctl/output_annotation
            type1: file2string_input_asn_type/value
            serial: 
                default: 'text'
            outformat:
                default: 'text' 
            out_annotation_name:
                default:  'cleaned_input.asn'
        out: [annotation]
    type_based_splitter:
        run: 
            class: ExpressionTool
            inputs:
                input:
                    type: File
                input_asn_type: 
                    type: string
            outputs: 
                output_entries:
                    type: File?
                output_seq_submit:
                    type: File?
            expression: "${ 
                    if ( inputs.input_asn_type == 'seq-entry' ) {
                        return {
                            'output_entries': inputs.input,
                            'output_seq_submit': null
                        }
                    }
                    if ( inputs.input_asn_type == 'seq-submit' ) {
                        return {
                            'output_entries': null,
                            'output_seq_submit': inputs.input
                        }
                    }
                }"
        in: 
            input: initial_cleanup/annotation
            input_asn_type: file2string_input_asn_type/value
        out: [output_entries, output_seq_submit]
