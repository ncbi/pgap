cwlVersion: v1.0
label: "kmer_seq_entry_extract_wnode"
# File: tt_kmer_seq_entry_extract_wnode.cwl
class: Workflow # task type
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest
inputs:
  entry: File
  kmer_file_list: File[]
  asn_cache: Directory
outputs:
  out_kmer_file_list:
    type: File[]
    outputSource: kmer_extract_wnode/output_files
steps:
  submit_kmer_extract:
    run: ../progs/submit_kmer_extract.cwl
    in:
      seq_entry: entry
      expected_output: 
        default: expected_kmer_files
    out: [jobs]
  kmer_extract_wnode:
    run: ../progs/kmer_extract_wnode.cwl
    in:
      input_jobs: submit_kmer_extract/jobs
      asn_cache: asn_cache
      input_type: 
        default: seq-entry
    out: [output_files]
  # gpx_make_outputs: # ????
  #  run: ../progs/gpx_make_outputs.cwl
  #  in:
  #    output: output
  #    output_manifest: output_manifest
  #    unzip: unzip
