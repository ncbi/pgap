cwlVersion: v1.2
label: "asn_cleanup"

class: Workflow
inputs:
    seq_entry: 
        type: File
    seq_submit: 
        type: File
steps:
    seq_entry1: 
        run: ../..//asn_cleanup.cwl
        in:
            inp_annotation:  seq_entry
            type1: 
                default: 'seq-entry'
            serial: 
                default: 'text'
            outformat:
                default: 'text' 
            out_annotation_name:
                default:  'seq_entry.asn'
        out: [annotation]
    seq_submit1: 
        run: ../..//asn_cleanup.cwl
        in:
            inp_annotation:  seq_submit
            type1: 
                default: 'seq-submit'
            serial: 
                default: 'text'
            outformat:
                default: 'text' 
            out_annotation_name:
                default:  'seq_submit.asn'
        out: [annotation]
    seq_entry_default: 
        run: ../..//asn_cleanup.cwl
        in:
            inp_annotation:  seq_entry
            serial: 
                default: 'text'
            outformat:
                default: 'text' 
            out_annotation_name:
                default:  'seq_entry_default.asn'
        out: [annotation]
    seq_submit_default: 
        run: ../..//asn_cleanup.cwl
        in:
            inp_annotation:  seq_submit
            serial: 
                default: 'text'
            outformat:
                default: 'text' 
            out_annotation_name:
                default:  'seq_submit_default.asn'
        out: [annotation]
outputs:
    seq_entry_output: 
        type: File
        outputSource: seq_entry1/annotation
    seq_submit_output: 
        type: File
        outputSource: seq_submit1/annotation
    seq_entry_default_output: 
        type: File
        outputSource: seq_entry_default/annotation
    seq_submit_default_output: 
        type: File
        outputSource: seq_submit_default/annotation    