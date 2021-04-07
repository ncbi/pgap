cwlVersion: v1.2
label: "bact_get_kmer_reference"

class: CommandLineTool
baseCommand: bact_get_kmer_reference
inputs:
    o:
        type: string
        inputBinding:
            prefix: -o
    prokrs_db_url:
        type: string
        # temporary setting, we need to get data from sqlite
        default: dbapi://anyone:allowed@GPIPE_BCT/ProkRefseqTracking
        inputBinding:
            prefix: -prokrs-db-url
    gencoll_db_url:
        type: string
        # temporary setting, we need to get data from sqlite
        default: dbapi://anyone:allowed@GPIPE_BCT/GenomeColl_Master
        inputBinding:
            prefix: -gencoll-db-url
outputs:
    gc_id_list:
        type: File
        outputBinding:
            glob: $(inputs.o)
            
