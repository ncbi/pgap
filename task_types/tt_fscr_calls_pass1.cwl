cwlVersion: v1.0
label: "tt_fscr_calls_pass1"
class: Workflow # task type
inputs:
  contigs:
    type: File
  input:
    type: File[]
  asn_cache:
    type: Directory

steps:
  fscr_calls_pass1:
    run: ../progs/fscr_calls_pass1.cwl
    label: fscr_calls_pass1
    in:
        contigs: contigs
        input: input
        asn_cache: asn_cache
        max_reblast_spans: 
            default: 50000
        repeat_threshold:
            default: 300
    out:
        [calls, reblast_locs, masked_locs]
  fscr_format_calls:
    run: ../progs/fscr_format_calls.cwl
    in:
        calls: fscr_calls_pass1/calls
    out: [o]
    
outputs:
  calls:
    type: File
    outputSource: fscr_format_calls/o
