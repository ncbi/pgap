cwlVersion: v1.0
label: "gp_makeblastdb"
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest

#gp_makeblastdb \
#    -asn-cache \
#    sequence_cache \
#    -asnb-manifest  inp/asnb.mft \
#    -asnt-manifest  inp/asnt.mft \
#    -db  out/blastdb \
#    -dbtype nucl \
#    -fasta-manifest  inp/fasta.mft \
#    -found-ids-output  out/found_ids.txt \
#    -found-ids-output-manifest  out/found_ids.mft \
#    -hardmask-manifest  inp/hardmask_data.mft \
#    -ids-manifest  inp/ids.mft \
#    -output-manifest  out/blastdb.mft \
#    -softmask-manifest  inp/softmask_data.mft \
#    -title  'BLASTdb  created by GPipe'


baseCommand: gp_makeblastdb
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
  # output blastdb role (blastdb) is implemented in CWL
  # as combination of Directory/string
  dbdir:
    type: Directory
    outputBinding:
        glob: ${outdir} ?????
  dbname: 
    type: string
    outputBinding: 
        outputEval: $(inputs.output_db_file)
  found_ids:
    type: File
    outputBinding:
        glob: ${inputs.found_ids_output_file}