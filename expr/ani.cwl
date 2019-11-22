#!/usr/bin/env cwl-runner

label: "Split input directory into subpath flows for top level user workflow ani.cwl"
cwlVersion: v1.0
class: ExpressionTool
requirements:
  InlineJavascriptRequirement: {}
inputs:
  data:
    type: Directory
expression: |
  ${
    var r = {};
    var l = inputs.data.listing;
    var n = l.length;
    for (var i = 0; i < n; i++) {
      switch (l[i].basename) {
        case 'uniColl_path':
          var ul = l[i].listing;
          var un = ul.length;
          for (var j = 0; j < un; j++) {
            switch (ul[j].basename) {
              case 'taxonomy.sqlite3':
                r['taxon_db'] = ul[j];
                break;
            }
          }
          break;
        case 'TaxSynon.tsv':
          r['tax_synon'] = l[i];
          break;    
        case 'GCExtract2.sqlite':
          r['gcextract2_sqlite'] = l[i];
          break;    
        }
    }
    return r;
  }
outputs:
  ANI_cutoff:
    type: File
  gc_cache:
    type: File
  gc_seq_cache:
    type: Directory
  gcextract2_sqlite:
    type: File
  kmer_cache_sqlite:
    type: File
  kmer_reference_assemblies:
    type: File
  tax_synon:
    type: File
  taxon_db:
    type: File