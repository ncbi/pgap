cwlVersion: v1.0 
label: "submit_kmer_extract"
doc: > 
    We need $(inputs.seq_entry) to be a local file to the current subdirectory since the file name goes to
    output.xml, a notorious file with files.

class: CommandLineTool
requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entry:  $(inputs.seq_entry)
        writable: False

baseCommand: submit_kmer_extract
inputs:
  gc_id_list:
    type: File?
    inputBinding:
        prefix: -gc-id-list
  seq_entry:
    type: File?
    inputBinding:
        prefix: -seq-entry
  kmer_output_dir:
    type: string?
    inputBinding:
        prefix: -kmer-output-dir
  expected_output:
    type: string?
    default: expected_kmer_files
    inputBinding:
      prefix: -expected-output
  output:
    type: string
    default: output.xml
    inputBinding:
      prefix: -output
outputs:
    jobs:
        type: File
        outputBinding:
            glob: $(inputs.output)
