cwlVersion: v1.0 
label: "prime_cache"

class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest
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

baseCommand: prime_cache
requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.cache)
        writable: True

# this is only one example
# 
# 
# 
# /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/bin/prime_cache \
#     -input-manifest \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/cache_fasta.455674882/inp/fasta.mft \
#     -oseq-ids \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/cache_fasta.455674882/out/sequences.seq_id \
#     -submit-block-template \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/const_submit_block_template.455674922/out/ASM2732v1.1.template \
#     -biosource \
#     genomic \
#     -cache \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/sequence_cache \
#     -ifmt \
#     fasta \
#     -inst-mol \
#     dna \
#     -molinfo \
#     genomic \
#     -taxid \
#     243273
# 
# 
# 

inputs:
  input:
    type: File
    inputBinding:
        prefix: -i
  biosource:
    type: string?
    inputBinding:
      prefix: -biosource
  cache:
    type: Directory
    inputBinding:
      prefix: -cache
  ifmt:
    type: string?
    default: fasta
    inputBinding:
      prefix: -ifmt
  inst_mol:
    type: string?
    inputBinding:
      prefix: -inst-mol
  molinfo:
    type: string?
    inputBinding:
      prefix: -molinfo
  taxid:
    type: int?
    inputBinding:
      prefix: -taxid
  seq_ids_name:
    type: string
    default: "oseq-ids.seqids"
    inputBinding:
        prefix: -oseq-ids
outputs:
  oseq_ids:
     type: File
     outputBinding: 
       glob: $(inputs.seq_ids_name)   
  asn_cache:
    type: Directory
    outputBinding:
        glob: $(inputs.cache.basename)
