cwlVersion: v1.0 
label: "taxonomy_check_16S"
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/taxonomy_check_16S:pgap4.5
#
# You might need something like this:
#
# requirements:
#  - class: InitialWorkDirRequirement
#    listing:
#      - entry: $(inputs.asn_cache)
#        writable: True
#      - entry: $(inputs.blastdb_dir)
#        writable: False

baseCommand: taxonomy_check_16S
# this is only one example
# 
# 
# 
# /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/bin/taxonomy_check_16S \
#     -blastdb \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/ThirdParty/ExternalData/BacterialPipeline/16S_rRNA/2018-03-09/blastdb \
#     -asn-cache \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/sequence_cache,/panfs/pan1/gpipe_id_cache/full_id_cache/ \
#     -ifmt \
#     seq-align \
#     -input-manifest \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/taxonomy_check_16S.455675132/inp/aligns.mft \
#     -oval \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/taxonomy_check_16S.455675132/out/taxonomy_check_16S.xml \
#     -report \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/taxonomy_check_16S.455675132/out/16S-tax-report.xml \
#     -top \
#     10
# 
# 
# 
inputs:
  asn_cache:
    type: Directory
    inputBinding:
      prefix: -asn-cache
      valueFrom: 
  ifmt:
    type: string?
    inputBinding:
      prefix: -ifmt
      valueFrom: 
  input_manifest:
    type: File?
    inputBinding:
      prefix: -input-manifest
      valueFrom: 
  input:
    type: File?
    inputBinding:
      prefix: -input
      valueFrom: 
  top:
    type: string?
    inputBinding:
      prefix: -top
      valueFrom: 
  report_name:
    type: string
    default: taxonomy_check_16S.xml
    inputBinding:
        prefix: -report
outputs:
    report:
        type: File
        outputBinding:
            glob: $(inputs.report_name)