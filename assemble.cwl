#!/usr/bin/env cwl-runner
class: Workflow
cwlVersion: v1.0
doc: |
  Assemble a set of reads using SKESA
requirements:
  - class: MultipleInputFeatureRequirement
inputs:
  reads: File?
  srr: string?
  report_usage: boolean
  no_internet:
    type: boolean?
  make_uuid:
    type: boolean?
    default: true
  uuid_in:
    type: File?
  output_name:
    type: string?
    default: contigs.out
outputs:
  contigs:
    type: File
    outputSource: skesa_assemble/contigs_out
steps:
  ping_start:
    run: progs/pinger.cwl
    in:
      report_usage: report_usage
      make_uuid: make_uuid
      uuid_in: uuid_in
      state:
        default: "start"
      workflow:
        default: "ani-analysis"
      instring: output_name
    out: [stdout, outstring, uuid_out]
  
  skesa_assemble:
    run: progs/skesa.cwl
    in:
      reads: fasta
      sra_run: srr
      contigs_out_name: ping_start/outstring
    out: [contigs_out]

  ping_stop:
    run: progs/pinger.cwl
    in:
      report_usage: report_usage
      uuid_in: ping_start/uuid_out
      state:
        default: "stop"
      workflow:
        default: "ani-analysis"
      # Note: the input on the following line should be the same as all of the outputs
      # for this workflow, so we ensure this is the final step.
      infile:
        - ping_start/stdout
        - skesa_assemble/contigs_out
    out: [stdout]
