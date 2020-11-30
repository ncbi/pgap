#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool
label: "test 8 space problem"
baseCommand: cat
arguments: [ blastdbs.mft ]
requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.blastdb_dir)
        writable: False
      - entryname: blastdbs.mft
        # when both string[] arguments are used 8 space problem reproduces itself
        # when shortest string[] argument (two generic blast databases) is used 8 space problem reproduces itself
        # when 1 string used 8 space problem reproduces itself
        # when only header is printed 8 space problem reproduces itself
        # when empty blob 8 space problem reproduces itself
        #
        # this produces correct output:
        # entry: ${return '';}
        # this produces correct output:
        # entry: ${var blob = ''; return blob;}
        # this does not produce exact problem: 8 empty spaces, but it does produce some white space:
        # "\n "
        entry: |- 
          ${ 
            return ''; 
          }
           
        # entry: |-
          # ${
            # var blob = '';
            
            # /*
            # '# blastdbs.mft created for bacterial_prot_src from input "blastdb" Array of blastdbs' +
              # '\n' ; 
           
            # var i = 0;
            # for (i = 0; i < inputs.blastdb.length && i<1; i++) { 
              # blob += inputs.blastdb_dir.path + '/' + inputs.blastdb[i] + String.fromCharCode(10); 
            # } 
            # for (i = 0; i < inputs.blastdb.length; i++) { 
              # blob += inputs.blastdb_dir.path + '/' + inputs.blastdb[i] + String.fromCharCode(10); 
            # } 
            # for (i = 0; i < inputs.all_order_specific_blastdb.length; i++) { 
              # blob += inputs.blastdb_dir.path + '/' + inputs.all_order_specific_blastdb[i] + String.fromCharCode(10); 
            # } 
            # */
            # return blob; 
          # }        

inputs:
  blastdb_dir: Directory
  blastdb: string[]
  all_order_specific_blastdb: string[]

outputs: []

