cwlVersion: v1.0 
label: "extract_gencoll_ids"
# File: progs/extract_gencoll_ids.cwl
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/pgap:latest
baseCommand: extract_gencoll_ids
inputs:
    assemblies: 
        type: File
        inputBinding:
            prefix: -assemblies
    o:
        type: string
        inputBinding:
            prefix: -output
        
outputs:
   gc_id_list: 
        type: File
        outputBinding:
            glob: $(inputs.o)



