cwlVersion: v1.2
label: "submit_kmer_compare"

class: CommandLineTool

requirements:
 - class: InlineJavascriptRequirement
 - class: InitialWorkDirRequirement
   listing:
     - entryname: submit_kmer_compare.kmer-files.mft
       entry: ${return '# submit_kmer_compare.kmer-files.mft created for submit_kmer_compare from input kmer_list File\n' + inputs.kmer_list.path + '\n'; }
     - entryname: submit_kmer_compare.ref-kmer-files.mft
       entry: ${var blob =  '# submit_kmer_compare.ref-kmer-files.mft created for submit_kmer_compare from input ref_kmer_list File\n'; if ( inputs.ref_kmer_list == null) { return blob; } else { return blob + inputs.ref_kmer_list.path + '\n'; }}


baseCommand: submit_kmer_compare        
inputs:
    kmer_list: 
        type: File
    kmer_list_impl:
        type: string
        default: submit_kmer_compare.kmer-files.mft
        inputBinding:
            prefix: -kmer-files-manifest
    ref_kmer_list: 
        type: File?
    ref_kmer_list_impl:
        type: string
        default: submit_kmer_compare.ref-kmer-files.mft
        inputBinding:
            prefix: -ref-kmer-files-manifest
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
    