cwlVersion: v1.0 
label: "identify_wp"

class: CommandLineTool
baseCommand: identify_wp
inputs:
  wp_hashes:
    type: File
    inputBinding:
      prefix: -wp-hashes
  taxon_db:
    type: File
    inputBinding:
      prefix: -taxon-db
  asn_cache:
    type: Directory[]?
    inputBinding:
      prefix: -asn-cache
      itemSeparator: ","
  fast:
    type: boolean
    inputBinding:
      prefix: -fast
  ifmt:
    type: string?
    inputBinding:
      prefix: -ifmt
  lds2:
    type: File
    inputBinding:
      prefix: -lds2
  proteins:
    type: File
  sequences: 
    type: File
    inputBinding:
      prefix: -input
  names:
    type: string
    default: names.xml
    inputBinding:
        prefix: -onames
stderr: application.log    
stdout: application.out
outputs:
    stdout:
        type: stdout
    stderr:
        type: stderr
    out_names:
        type: File
        outputBinding:
            glob: $(inputs.names)
