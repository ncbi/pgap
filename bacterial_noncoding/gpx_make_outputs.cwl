cwlVersion: v1.0
label: "BLAST against rRNA db, gather"
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/bacterial_noncoding:pgap4.4
    
#gpx_make_outputs -output 'blast.#.asn' -output-manifest blast_align.mft -unzip '*' -S GPIPE_SCHED1 -D GPipeSched_Prod1 -U gpipe_prod -P gpipe2007 -queue GPIPE_BCT.blastn_wnode.455674932.1521225902 -num-partitions 1
baseCommand: gpx_make_outputs
arguments: [ -unzip, '*', -num-partitions, "1" ]
inputs:
  input_path:
    type: Directory
    inputBinding:
      prefix: -input-path
  output_name:
    type: string?
    default: "blast.#.asn"
    inputBinding:
      prefix: -output

outputs:
  blast_align:
    type: File
    outputBinding:
      #glob: $(inputs.output_name)
      glob: blast.*.asn
