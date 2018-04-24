cwlVersion: v1.0 
label: "format_rrnas"
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/pgap:latest
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

baseCommand: format_rrnas

# this is only one example
# 
# 
# 
# /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/bin/format_rrnas \
#     -ifmt \
#     seq-entry \
#     -input-manifest \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/format_rrnas_from_seq_entry.455675102/inp/annotation.mft \
#     -o \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/format_rrnas_from_seq_entry.455675102/out/rrna_16S.asn \
#     -rrna-class \
#     16S \
#     -tmpinput-manifest \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/format_rrnas_from_seq_entry.455675102/inp/annotation_text.mft
# 
# 
# 

inputs:
  ifmt:
    type: string?
    default: seq-entry
    inputBinding:
      prefix: -ifmt
  input_manifest:
    type: File?
    inputBinding:
      prefix: -input-manifest
  input:
    type: File?
    inputBinding:
      prefix: -input
  rrna_class:
    type: string?
    default: 16S
    inputBinding:
      prefix: -rrna-class
  tmpinput:
    type: File
    inputBinding:
      prefix: -tmpinput
  o_name:
    type: string
    default: rrna.asn
    inputBinding:
       prefix: -o
outputs:
    o:
      type: File
      outputBinding:
         glob: $(inputs.o_name)
            
