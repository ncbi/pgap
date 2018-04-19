cwlVersion: v1.0
label: "Cache Entrez Gene"
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/dbcallers:pgap4.4

requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.seq_cache)
        writable: True
      - entry: $(inputs.unicoll_cache)
        writable: False

#cache_entrez_gene -asn-cache sequence_cache,uniColl/ver-3.2/cache -egene-ini gene_master.ini -input-manifest annotation.mft -prok-entrez-gene-stuff prok_entrez_gene_stuff.xml
#/panfs/pan1.be-md.ncbi.nlm.nih.gov/refgene/LOCUS/bin/genes/inifiles/gene_master.ini
baseCommand: cache_entrez_gene
inputs:
  seq_cache:
    type: Directory
  unicoll_cache:
    type: Directory
  asn_cache:
    type: Directory[]
    inputBinding:
      prefix: -asn-cache
      itemSeparator: ","
  egene_ini:
    type: File
    inputBinding:
      prefix: -egene-ini
  input:
    type: File
    inputBinding:
      prefix: -input
  outfile:
    type: string?
    default: prok_entrez_gene_stuff.xml
    inputBinding:
      prefix: -prok-entrez-gene-stuff

outputs:
  asncache:
    type: Directory
    outputBinding:
      glob: $(inputs.seq_cache.basename)
  prok_entrez_gene_stuff:
    type: File
    outputBinding:
      glob: $(inputs.outfile)

   
