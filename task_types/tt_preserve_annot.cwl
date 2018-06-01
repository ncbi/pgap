cwlVersion: v1.0
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest

#  preserve_annot \
#    -asn-cache sequence_cache \
#    -gc-assembly-manifest inp/gencoll_asn.mft \
#    -input-manifest  inp/annotation.mft \
#    -o  out/annotation.asn \
#    -rfam-amendments  /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/home/badrazat/local-install/2018-05-17/etc/bacterial_pipeline/rfam-amendments.xml \
#    -no-ncRNA

    baseCommand: preserve_annot
inputs:
  asn_cache:
    type: Directory[]
    inputBinding:
      prefix: -asn-cache
      itemSeparator: ","
  gc_assembly:
    type: File?
    inputBinding:
        prefix: -gc-assembly
  input_annotation:
    type: File
    inputBinding:
        prefix: -input
  output_annotation:
    type: string
    default: annotation.asn
    inputBinding:
        prefix: -o
  rfam_amendments:
    type: File
    inputBinding:
        prefix: -rfam-amendments
  no_ncRNA:
    type: Boolean
    inputBinding:
        prefix: -no-ncRNA
outputs:
  annotations:
    type: File
    outputBinding:
      glob: $(inputs.output_annotation)

   
