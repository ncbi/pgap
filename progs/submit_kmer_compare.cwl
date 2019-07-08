cwlVersion: v1.0
label: "submit_kmer_compare"

class: CommandLineTool
        
inputs:
    kmer_list: 
        type: File
        inputBinding:
            prefix: -kmer-files
    ref_kmer_list: 
        type: File?
        inputBinding:
            prefix: -ref-kmer-files
    o:
        type: string
        default: jobs.xml
        inputBinding:
            prefix: -output
    
outputs: 
    output:
        type: File
        outputBinding:
            glob: $(inputs.o)
    