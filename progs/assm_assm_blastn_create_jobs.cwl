#!/usr/bin/env cwl-runner
label: assm_assm_blastn_create_jobs.cwl
class: CommandLineTool
cwlVersion: v1.0

inputs:
    affinity_bin: 
        type: int?
    queries_gc_id_list:
        type: File?
        inputBinding:
            prefix: -query-assemblies
    subjects_gc_id_list: 
        type: File?
        inputBinding:
            prefix: -target-assemblies
    output_xml_file_name:
        type: string?
        default: jobs.xml
        inputBinding:
            prefix: -output
outputs: 
    output:
        type: File
        outputBinding:
            glob: $(inputs.output_xml_file_name)
