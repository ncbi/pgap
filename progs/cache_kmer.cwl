cwlVersion: v1.0 
label: "cache_kmer"
# file: progs/cache_kmer.cwl
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/pgap:latest
baseCommand: cache_kmer
inputs:
      gc_id_list:
        type: File
        inputBinding:
            prefix: -gc-id-list 
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
    new_list:
        type: File[]
        outputBinding:
            glob: |
                ${
                    List<File> fileList new ArrayList<>();
                    File manifests = new File(inputs.onew);
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
    full_list:
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
