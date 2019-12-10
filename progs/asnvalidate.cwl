#!/usr/bin/env cwl-runner
cwlVersion: v1.0
label: "asnvalidate"

class: CommandLineTool

baseCommand: asnvalidate
inputs:            
  A:
     type: boolean?
     inputBinding:
        prefix: -A
  U:
     type: boolean?
     inputBinding:
        prefix: -U
  z:
     type: boolean?
     inputBinding:
        prefix: -z
  b:
     type: boolean?
     inputBinding:
        prefix: -b
  y:
     type: boolean?
     inputBinding:
        prefix: -y
  E:
     type: string?
     inputBinding:
        prefix: -E
  N:
     type: int?
     inputBinding:
        prefix: -N
  
  P:
     type: int?
     inputBinding:
        prefix: -P
  
  Q:
     type: int?
     inputBinding:
        prefix: -Q
  
  R:
     type: int?
     inputBinding:
        prefix: -R
  
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
  
  i:
     type: File?
     inputBinding:
        prefix: -i
  
  lds2:
     type: string?
     inputBinding:
        prefix: -lds2
  
  p:
     type: File?
     inputBinding:
        prefix: -p
  
  sra_acc:
     type: string?
     inputBinding:
        prefix: -sra-acc
  
  sra_file:
     type: string?
     inputBinding:
        prefix: -sra-file
  
  v:
     type: int?
     inputBinding:
        prefix: -v
  
  vdb-path:
     type: string?
     inputBinding:
        prefix: -vdb-path
  
  x:
     type: string?
     inputBinding:
        prefix: -x
  
  L_output:
     type: string?
     inputBinding:
        prefix: -L
  
  f_output:
     type: string?
     inputBinding:
        prefix: -f
  
  logfile_output:
     type: string?
     inputBinding:
        prefix: -logfile
  
  o_output:
     type: string?
     default: asnvalidate.xml
     inputBinding:
        prefix: -o
        
outputs:
       
  L:
      type: File?
      outputBinding:
          glob: $(inputs.L_output)
  
  f:
      type: File?
      outputBinding:
          glob: $(inputs.f_output)
  
  logfile:
      type: File?
      outputBinding:
          glob: $(inputs.logfile_output)
  
  o:
      type: File
      outputBinding:
          glob: $(inputs.o_output)
