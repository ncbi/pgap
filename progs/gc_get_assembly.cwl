cwlVersion: v1.0 
label: "gc_get_assembly"

class: CommandLineTool
hints:
baseCommand: gc_get_assembly
inputs:
  mode:
    type: string?
    inputBinding:
      prefix: -mode
  output:
    type: File
    default: gencoll.asn
    inputBinding:
      prefix: -o
  release_id:
    type: File
    inputBinding:
      prefix: -release_id
outputs: 
    gencoll_asn:
        type: File
        outputBinding:
            glob: $(inputs.output)