#!/usr/bin/env cwl-runner
cwlVersion: v1.2
label: "prepare_seq_entry_input"
doc: ""
class: CommandLineTool
baseCommand: prepare_seq_entry_input
arguments: [ -nogenbank  ]
requirements: 
  - class: InlineJavascriptRequirement

inputs:
    seq_submit:
        type: File?
    entries: 
        type: File?
    input:
        type: string
        default: '/dev/null' # to cause calculations
        inputBinding:
            prefix: -input
            valueFrom: ${ if( inputs.seq_submit != null ) { return  inputs.seq_submit.path; } else { return inputs.entries.path;  } }
    ifmt:
        type: string
        default: '/dev/null' # to cause calculations
        inputBinding:
            prefix: -ifmt
            valueFrom: ${ if( inputs.seq_submit != null ) {return 'seq-submit'; } else { return 'seq-entry'; } } 
    t:
        type: boolean
        default: true
        inputBinding:
            prefix: -t
    order_name:
        type: string
        default: order.seqids
        inputBinding:
            prefix: -order
    pathogen_mode:
        type: boolean?
        default: true
        inputBinding:
            prefix: -pathogen-mode
    submit_block_name:        
        type: string
        default: submit_block_template.asn
        inputBinding:
            prefix: -submit-block 
    output_entries_name:
        type: string
        default: entries.asn
        inputBinding:
            prefix: -output 
outputs:
    order:
        type: File
        outputBinding:
            glob: $( inputs.order_name )
    submit_block:
        type: File
        outputBinding:
            glob: $( inputs.submit_block_name  )  
    output_entries:
        type: File
        outputBinding:
            glob: $( inputs.output_entries_name  )  
