#!/usr/bin/env cwl-runner
cwlVersion: v1.0
label: "asndisc_cpp"

class: CommandLineTool
baseCommand: asndisc_cpp
inputs:            
  XML: 
        type: boolean?
        inputBinding:
            prefix: -XML
  genbank: 
        type: boolean?
        inputBinding:
            prefix: -genbank
  L:
     type: string?
     inputBinding:
        prefix: -L
  P:
     type: string?
     inputBinding:
        prefix: -P
  X:
     type: string?
     inputBinding:
        prefix: -X
  a:
     type: string?
     inputBinding:
        prefix: -a
  asn_cache:
     type: Directory?
     inputBinding:
        prefix: -asn-cache
  blastdb:
     type: string?
     inputBinding:
        prefix: -blastdb
  conffile:
     type: File?
     inputBinding:
        prefix: -conffile
  d:
     type: string[]?
     inputBinding:
        itemSeparator: ","
        prefix: -d
  e:
     type: string?
     inputBinding:
        prefix: -e
  i:
     type: File?
     inputBinding:
        prefix: -i
  indir:
     type: File?
     inputBinding:
        prefix: -indir
  lds2:
     type: string?
     inputBinding:
        prefix: -lds2
  outdir_name:  # not used
     type: string?
     inputBinding:
        prefix: -outdir
  s:
     type: string?
     inputBinding:
        prefix: -s
  sra_acc:
     type: string?
     inputBinding:
        prefix: -sra-acc
  sra_file:
     type: string?
     inputBinding:
        prefix: -sra-file
  vdb_path:
     type: string?
     inputBinding:
        prefix: -vdb-path
  w:
     type: File?
     inputBinding:
        prefix: -w
  x:
     type: string?
     inputBinding:
        prefix: -x
  logfile_output:
     type: string?
     default: asndisc_cpp.applog
     inputBinding:
        prefix: -logfile
  o_output:
     type: string?
     default: asndisc_cpp.xml
     inputBinding:
        prefix: -o
outputs:
  logfile:
      type: File
      outputBinding:
          glob: $(inputs.logfile_output)
  o:
      type: File
      outputBinding:
          glob: $(inputs.o_output)
          
