cwlVersion: v1.2
label: "Run genomic CMsearch, execution"
class: CommandLineTool

requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.asn_cache)
        writable: False
  - class: ResourceRequirement
    ramMax: 3000

#cmsearch_wnode -asn-cache sequence_cache -cmsearch-cpu 0 -input-jobs jobs.xml\
# -cmsearch-path /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/third-party/infernal/arch/x86_64/bin/ \
# -model-path /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/third-party/data/Rfam/pgap-3.1/CMs/RF00001.cm \
# -rfam-amendments /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/etc/bacterial_pipeline/rfam-amendments.xml \
# -rfam-stockholm /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/third-party/data/Rfam/pgap-3.1/Rfam.seed 
baseCommand: cmsearch_wnode
#arguments: [ -cmsearch-cpu "0" ]
arguments: [ -nogenbank, -use-alignment-output ]
inputs:
  asn_cache:
    type: Directory
    inputBinding:
      prefix: -asn-cache
  input_jobs:
    type: File
    inputBinding:
      prefix: -input-jobs
  cmsearch_path:
    type: string?
    default: /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/third-party/bin
    inputBinding:
      prefix: -cmsearch-path
  model_path:
    type: File
    inputBinding:
      prefix: -model-path
  rfam_amendments:
    type: File
    inputBinding:
      prefix: -rfam-amendments
  rfam_stockholm:
    type: File
    inputBinding:
      prefix: -rfam-stockholm      
  cmsearch_cpu:
    type: int?
    default: 0
    inputBinding:
      prefix: -cmsearch-cpu 
  output_dir:
    type: string?
    default: output
    inputBinding:
      prefix: -O
  taxon_db:
    type: File
    inputBinding:
        prefix: -taxon-db
outputs:
  asncache:
    type: Directory
    outputBinding:
      glob: $(inputs.asn_cache.basename)
  outdir:
    type: Directory
    outputBinding:
      glob: $(inputs.output_dir)
  
  
