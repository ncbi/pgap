#!/usr/bin/env cwl-runner

label: "Split input directory into subpath flows"
cwlVersion: v1.0
class: ExpressionTool
requirements:
  InlineJavascriptRequirement: {}
inputs:
  data:
    type: Directory?
expression: |
  ${
    var r = {};
    if(inputs.data != null) {
      var l = inputs.data.listing;
      var n = l.length;
      for (var i = 0; i < n; i++) {
        switch (l[i].basename) {
          case 'blast_hits.sqlite':
            r['blast_hits_cache'] = l[i];
            break;
          case 'genus-list':
            r['genus_list'] = l[i];
            break;
        }
      }
    }
    return r;
  }
outputs:
  blast_hits_cache:
    type: File?
  genus_list:
    type: File?
