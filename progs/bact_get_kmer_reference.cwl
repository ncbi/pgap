cwlVersion: v1.0 
label: "bact_get_kmer_reference"
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest
baseCommand: bact_get_kmer_reference
inputs:
    o:
        type: string
        inputBinding:
            prefix: -o
outputs:
    gc_id_list:
        type: File
        outputBinding:
            glob: $(inputs.o)
            
