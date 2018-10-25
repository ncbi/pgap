cwlVersion: v1.0 
label: "trnascan_wnode"

class: Workflow
hints:
inputs:
    jobs: File
    asn_cache: Directory
    taxon_db: File
steps:
    test: 
        run: ../../../bacterial_trna/trnascan_wnode.cwl
        in:
          asn_cache: asn_cache
          input_jobs: jobs
          taxon_db: taxon_db
          gcode_othmito:    
            default: ./gcode.othmito
          taxid: 
            default: 243273 # MG37
          superkingdom: 
            default: 2 # MG37
          # cove_flag_bacteria:
            # default: false
          # cove_flag_archaea:
            # default: false
        out: [outdir]
outputs:
    outdir: 
        type: Directory
        outputSource: test/outdir
    