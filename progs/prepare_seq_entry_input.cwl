#!/usr/bin/env cwl-runner
cwlVersion: v1.0
label: "prepare_seq_entry_input"
doc: ""
class: CommandLineTool
baseCommand: prepare_seq_entry_input
  - class: InlineJavascriptRequirement

inputs:
    seq_submit:
        type: File?
    entries: 
        type: File?
    input:
        type: string
        inputBinding:
            prefix: -input
            valueFrom: ${ return inputs.seq_submit.path ? inputs.seq_submit.path : inputs.entries.path; }
    ifmt:
        type: string
        inputBinding:
            prefix: -ifmt
            valueFrom: ${ return inputs.seq_submit.path ? 'seq-submit' :  'seq-entry'; } 
    order_name:
        type: string
        default: order.seqids
        inputBinding:
            prefix: -order
    submit_block_name:        
        type: string
        default: submit_block_template.asn
        inputBinding:
            prefix: -submit-block 
outputs:
    order:
        type: File
        outputBinding:
            glob: $( inputs.order_name )
    submit_block:
        type: File
        outputBinding:
            glob: $( inputs.submit_block_name  )            
