cwlVersion: v1.0
label: "Cache FASTA Sequences"
class: CommandLineTool

#baseCommand: /usr/bin/strace 
#arguments: [ -ostrace.txt, /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/home/slottad/gpipe-devel/CMake-DebugDLL/bin/prime_cache, -biosource, genomic, -ifmt, fasta, -inst-mol, dna, -molinfo, genomic ]
baseCommand: prime_cache
arguments: [ -biosource, genomic, -ifmt, fasta, -inst-mol, dna, -molinfo, genomic ]
inputs:
  taxon_db:
    type: File
    inputBinding:
      prefix: -taxon-db
  fasta:
    type: File
    inputBinding:
      prefix: -i
  submit_block_template:
    type: File
    inputBinding:
      prefix: -submit-block-template
  cache:
    type: string?
    default: sequence_cache
    inputBinding:
      prefix: -cache
  taxid:
    type: int
    inputBinding:
      prefix: -taxid
  seq_ids:
    type: string?
    default: "sequences.seq_id"
    inputBinding:
      prefix: -oseq-ids    
      
outputs:
  ids_out:
    type: File
    outputBinding:
      glob: $(inputs.seq_ids)
  asncache:
    type: Directory
    outputBinding:
      glob: $(inputs.cache)
