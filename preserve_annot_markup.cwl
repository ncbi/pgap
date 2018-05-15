cwlVersion: v1.0
label: "Preserve Product Accessions"
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest

#preserve_annot_markup -asn-cache sequence_cache,/panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/third-party/data/BacterialPipeline/uniColl/ver-3.2/cache,/panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe_id_cache/full_id_cache
#-bypass-annots-manifest bypass_annots.mft -comparisons-manifest comparisons.mft
#-egene-ini /panfs/pan1.be-md.ncbi.nlm.nih.gov/refgene/LOCUS/bin/genes/inifiles/gene_master.ini
#-gc-assembly-manifest gc_assembly.mft -input-manifest annotation.mft
#-locus-tag-prefix NoSubmit -ltp-table vLTPs -o annotation.asn -prok-entrez-gene-stuff-manifest prok_entrez_gene_stuff.mft -create-missing-LTPs -preserve-product-ID -submission-mode-genbank
baseCommand: cache_entrez_gene
arguments: [-locus-tag-prefix, NoSubmit, -ltp-table, vLTPs, -create-missing-LTPs, -preserve-product-ID, -submission-mode-genbank]
inputs:
  full_id_cache:
    type: Directory?
  asn_cache:
    type: Directory[]
    inputBinding:
      prefix: -asn-cache
      itemSeparator: ","
  egene_ini:
    type: File
    inputBinding:
      prefix: -egene-ini
  gc_assembly:
    type: File
    inputBinding:
      prefix: -gc_assembly
  input:
    type: File
    inputBinding:
      prefix: -input
  prok_entrez_gene_stuff:
    type: File
    inputBinding:
      prefix: -prok-entrez-gene-stuff
  outfile:
    type: string?
    default: annotation.asn
    inputBinding:
      prefix: -o

outputs:
  annotations:
    type: File
    outputBinding:
      glob: $(inputs.outfile)

   
