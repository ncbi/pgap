cwlVersion: v1.0 
label: "cache_kmer"
# file: progs/cache_kmer.cwl
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/pgap:latest
requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.kmer_cache_path)
        writable: True
      - entryname: kmer_file_list.mft
        entry: |
          ${
            var blob = '';
            for (var i = 0; i < inputs.kmer_file_list.length; i++) {
                blob += inputs.kmer_file_list[i].path + '\n';
            }
            return blob;
          }
    
baseCommand: cache_kmer
inputs:
      gc_id_list:
        type: File?
        inputBinding:
            prefix: -gc-id-list 
      kmer_file_list: File[]?
      kmer_file_list_mft:
        type: string
        default: kmer_file_list.mft
        inputBinding:
            prefix: -input-manifest 
      kmer_cache_path: 
        type: Directory
        inputBinding:
            prefix: -cache-path 
      retrieve: 
        type: boolean?
        inputBinding:
            prefix: -retrieve 
      store: 
        type: boolean?
        inputBinding:
            prefix: -store 
      onew:
        type: string
        default: new.list
        inputBinding:
            prefix: -onew
      ofull:
        type: string
        default: full.list
        inputBinding:
            prefix: -ofull
        
outputs:
    out_kmer_cache_path: 
        type: Directory
        outputBinding:
            glob: $(input.kmer_cache_path) 
    new_gc_id_list:
        type: File
        outputBinding:
            glob: $(inputs.onew)
    out_kmer_file_list:
        type: File[]
        outputBinding:
            glob: |
                ${
                    List<File> fileList new ArrayList<>();
                    File manifests = new File(inputs.ofull);
                    manifests.open("r");
                    while (!manifests.eof) {
                        // read each line of text
                        var str;
                        str = file.readln();
                        if ( str[0] == '#' ) continue; 
                        fileList.add(new File(str));
                    }
                    file.close();
                    return fileList;
                }
