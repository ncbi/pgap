#!/usr/bin/env cwl-runner
label: "PGAP Pipeline"
cwlVersion: v1.0
class: Workflow


inputs:
  input: File
steps:
    test:
        run: ../../add_locus_tags.cwl
        in:
            input: input
        out: [output]
outputs:
  gbent:
    type: File
    outputSource: test/output
 
