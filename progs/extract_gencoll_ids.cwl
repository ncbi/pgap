cwlVersion: v1.0 
label: "extract_gencoll_ids"
# File: progs/extract_gencoll_ids.cwl
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest
baseCommand: gc_extract_ids
inputs:
    assemblies: 
        type: File
        inputBinding:
            prefix: -input
    o:
        type: string
        inputBinding:
            prefix: -output
        
outputs:
   gc_id_list: 
        type: File
        outputBinding:
            glob: $(inputs.o)



