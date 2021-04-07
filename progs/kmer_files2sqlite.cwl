#!/usr/bin/env cwl-runner4
label: kmer_files2sqlite.cwl
cwlVersion: v1.2
doc: |
        Convert input .kmer.gz (kmer_file) and .xml (kmer_metadata_file)
        into new sqlite database
        Takes a directory input
class: CommandLineTool
baseCommand:    kmer_files2sqlite 
requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.kmer_dir)
        writable: False
      - entryname: keys.ids
        entry: ${
                var blob = ''; 
                for (var i = 0; i < inputs.kmer_dir.listing.length; i++) { 
                    var nameext = inputs.kmer_dir.listing[i].nameext;
                    if ( nameext == ".gz" ) {
                        blob += inputs.kmer_dir.listing[i].path + '\n'; 
                    }
                } 
                return blob; 
            }
        writable: False

inputs:
    kmer_dir: 
        type: Directory
        inputBinding:
            prefix: -file-uri
    output_file:
        type: string
        default: local_kmer_cache.sqlite
        inputBinding:
            prefix: -db-uri
    keys:
        type: string
        default: keys.ids
        inputBinding:
            prefix: -gencoll-ids
outputs: 
    out_kmer_cache_sqlite:
        type: File
        outputBinding:
            glob: $(inputs.output_file)
    