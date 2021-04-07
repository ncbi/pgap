cwlVersion: v1.2
label: "kmer_files2sqlite"

inputs:
    kmer_dir: Directory
class: Workflow
steps:
    step1: # this step does not exist in classic PGAP bacterial kmer graph
        run: ../../kmer_files2sqlite.cwl
        in:
            kmer_dir: kmer_dir
        out: [out_kmer_cache_sqlite]
outputs:
    out_kmer_cache_sqlite:
        type: File
        outputSource: step1/out_kmer_cache_sqlite