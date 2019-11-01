cwlVersion: v1.0 
label: "gc_get_assembly"

class: CommandLineTool
baseCommand: gc_get_assembly
inputs:
    mode:
        type: string?
        inputBinding:
          prefix: -mode
    output_name:
        type: string
        default: gencoll.asn
        inputBinding:
          prefix: -o
    release_id_list:
        type: File?
        inputBinding:
          prefix: -release_id_list
    gc_cache:
        type: File
        inputBinding:
          prefix:  -gc-cache
outputs: 
    gencoll_asn:
        type: File
        outputBinding:
            glob: $(inputs.output_name)