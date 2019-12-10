cwlVersion: v1.0
label: "gp_makeblastdb"

class: Workflow
requirements:
- class: StepInputExpressionRequirement
    
inputs:
  asn_cache: Directory[]
  asnb: File?
  asnt: File?
  dbtype: string
  fasta: File?
  hardmask: File?
  softmask: File?
  title: string
  ids:  File?

steps:
    actual:
        run:
            class: CommandLineTool
            baseCommand: gp_makeblastdb
            arguments: [ -nogenbank  ]
            inputs:
              asn_cache:
                type: Directory[]
                inputBinding:
                  prefix: -asn-cache
                  itemSeparator: ","
              asnb:
                type: File?
                inputBinding:
                    prefix: -asnb
              asnt:
                type: File?
                inputBinding:
                    prefix: -asnt
              dbtype:
                type: string
                inputBinding:
                    prefix: -dbtype
              fasta:
                type: File?
                inputBinding:
                    prefix: -fasta
              found_ids_output_file:  #    -found-ids-output  out/found_ids.txt \
                type: string
                default: found_ids.txt
                inputBinding:
                    prefix: -found-ids-output
              found_ids_output_manifest:  #    -found-ids-output-manifest  out/found_ids.mft \
                type: string
                default: found_ids.mft
                inputBinding:
                   prefix: -found-ids-output-manifest
              hardmask: #    -hardmask-manifest  inp/hardmask_data.mft 
                type: File?
                inputBinding:
                   prefix: -hardmask
              output_db_file:
                type: string
                default: blastdb
                inputBinding:
                    prefix: -db
              output_db_manifest:
                type: string
                default: blastdb.mft
                inputBinding:
                    prefix: -output-manifest
              softmask: #    -softmask-manifest  inp/softmask_data.mft \
                type: File?
                inputBinding:
                    prefix: -softmask
              title:  #    -title  'BLASTdb  created by GPipe'
                type: string
                inputBinding:
                    prefix: -title
              ids:
                type: File?
                inputBinding:
                    prefix: -ids
            outputs:
                  dbname: 
                    type: string
                    outputBinding: 
                        outputEval: $(inputs.output_db_file)
                  found_ids:
                    type: File
                    outputBinding:
                        glob: $(inputs.found_ids_output_file)
                  
                  blastfiles:
                    type: File[]
                    outputBinding:
                        glob: "blastdb.*"  #  string literal here must match ${output_db_file}             
        in:
              asn_cache: asn_cache
              asnb: asnb
              asnt: asnt
              dbtype: dbtype
              fasta: fasta
              hardmask: hardmask #    -hardmask-manifest  inp/hardmask_data.mft 
              softmask: softmask #    -softmask-manifest  inp/softmask_data.mft \
              title:  title #    -title  'BLASTdb  created by GPipe'
              ids: ids
        out: [blastfiles]
    mkdir:
        run:
          class: CommandLineTool
          requirements:
            - class: ShellCommandRequirement
          arguments:
            - shellQuote: false
              valueFrom: >-
                mkdir $(inputs.blastdir) && cp
          inputs:
            blastfiles:
              type: File[]
              inputBinding:
                position: 1
            blastdir:
              type: string
              inputBinding:
                position: 2

          outputs:
            blastdb:
              type: Directory
              outputBinding:
                glob: $(inputs.blastdir)
        in:
          blastfiles: actual/blastfiles
          blastdir: 
            default: blastdir
        out: [blastdb]    
    
outputs:
  blastdb:
    type: Directory
    outputSource: mkdir/blastdb

    
