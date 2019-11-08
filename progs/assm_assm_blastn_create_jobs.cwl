#!/usr/bin/env cwl-runner
label: "assm_assm_blastn_create_jobs"
class: CommandLineTool
baseCommand: assm_assm_blastn_create_jobs
cwlVersion: v1.0
requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
     - entryname: q.mft
       entry: |- 
        ${
          var blob = '# q.mft created for assm_assm_blastn_create_jobs from input "queries_gc_id_list" File\n'; 
          if(inputs.queries_gc_id_list != null) { blob += inputs.queries_gc_id_list.path + '\n'; } 
          return blob; 
        }
     - entryname: t.mft
       entry: |- 
        ${
          var blob = '# t.mft created for assm_assm_blastn_create_jobs from input "subjects_gc_id_list" File\n'; 
          if(inputs.subjects_gc_id_list != null) { blob += inputs.subjects_gc_id_list.path + '\n'; } 
          return blob; 
        }
arguments: [ -query-assemblies-manifest, q.mft, -target-assemblies-manifest, t.mft ]
# ~/gpipe-debug-bin/assm_assm_blastn_create_jobs -affinity-bin 10 
# -query-assemblies-manifest inp/query_ids.mft -target-assemblies-manifest inp/subject_ids.mft -output inp/jobs.xml
#
inputs:
    affinity_bin: 
        type: int?
        inputBinding:
          prefix: -affinity-bin
    queries_gc_id_list:
        type: File?
    subjects_gc_id_list: 
        type: File?
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
