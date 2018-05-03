cwlVersion: v1.0
label: "submit_kmer_compare"
class: CommandLineTool
requirements:
  # - class: InlineJavascriptRequirement 
  - class: InitialWorkDirRequirement
    listing:
      - entryname: kmer_file_list.mft
        entry: |
          ${
            var blob = '';
            for (var i = 0; i < inputs.kmer_file_list.length; i++) {
                blob += inputs.kmer_file_list[i].path + '\n';
            }
            return blob;
          }
      - entryname: ref_kmer_file_list.mft
        entry: |
          ${
            var blob = '';
            for (var i = 0; i < inputs.ref_kmer_file_list.length; i++) {
                blob += inputs.ref_kmer_file_list[i].path + '\n';
            }
            return blob;
          }
        
inputs:
    kmer_file_list: File[]
    ref_kmer_file_list: File[]?
    kmer_files_manifest:
        type: string
        default: kmer_file_list.mft
        inputBinding:
            prefix: -kmer-files-manifest
    ref_kmer_files_manifest:
        type: string?
        default: ref_kmer_file_list.mft
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
    