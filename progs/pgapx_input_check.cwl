#!/usr/bin/env cwl-runner

cwlVersion: v1.0
label: pgapx_input_check
class: CommandLineTool
baseCommand: pgapx_input_check
inputs:            
  input:
     type: File
     inputBinding:
        prefix: -input
  ignore_all_errors:
        type: boolean?
        inputBinding:
            prefix: -ignore-all-errors    
  max_size:
     type: long
     inputBinding:
        prefix: -max-size
  min_size:
     type: long
     inputBinding:
        prefix: -min-size
  species_genome_size:
     type: File
     inputBinding:
        prefix: -species-genome-size
  taxon_db:
     type: File?
     inputBinding:
        prefix: -taxon-db
  logfile_output:
     type: string?
     inputBinding:
        prefix: -logfile
        
  conffile:
     type: File?
     inputBinding:
        prefix: -conffile
outputs:
       
  logfile:
      type: File?
      outputBinding:
          glob: $(inputs.logfile_output)
