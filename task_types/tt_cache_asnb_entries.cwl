cwlVersion: v1.0
label: "cache_asnb_entries"
class: Workflow # task type
inputs:
  rna: File
  cache: Directory
  ifmt: string
  taxid: int
outputs:
  ids_out:
    type: File
    outputSource: prime_cache/oseq_ids
  asncache:
    type: Directory
    outputSource: prime_cache/asn_cache
steps:
  prime_cache:
    run: ../progs/prime_cache.cwl
    in:
      input: rna
      cache: cache
      ifmt: ifmt
    out: [oseq_ids, asn_cache]
