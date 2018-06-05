cwlVersion: v1.0 
label: "kmer_top_identification"

# file: progs/kmer_top_identification.cwl

class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest

baseCommand: kmer_top_identification
# this is only one example
# 
# 
# 
# /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/2018-03-13.build2663/bin/kmer_top_identification \
#     -N \
#     20 \
#     -distances-manifest \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/kmer_top_n.455674842/inp/distances.mft \
#     -omatches \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/kmer_top_n.455674842/tmp/matches \
#     -oxml \
#     /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/data56/Mycoplasma_genitalium_G37/Mycoplasma_genitalium_External_PGAP.4585524/4829637/kmer_top_n.455674842/out/top_distances.xml \
#     -threshold \
#     0.8
# 
# 
# 
inputs:
  N:
    type: int?
    inputBinding:
      prefix: -N
  distances:
    type: File?
    inputBinding:
      prefix: -distances
  omatches:
    type: string
    default: matches.mft
    inputBinding:
      prefix: -omatches
  oxml:
    type: string
    default: top_distances.xml
    inputBinding:
      prefix: -oxml
  threshold:
    type: int
    inputBinding:
      prefix: -threshold
outputs:
    matches:
        type: File[]
        outputBinding:
            glob: |
                ${
                    List<File> fileList new ArrayList<>();
                    File manifests = new File(inputs.omatches);
                    manifests.open("r");
                    while (!manifests.eof) {
                        // read each line of text
                        var str;
                        str = file.readln();
                        if ( str[0] == '#' ) continue; 
                        fileList.add(new File(str));
                    }
                    file.close();
                    return fileList;
                }
    top_distances:
        type: File
        outputBinding:
            glob: $(inputs.oxml)
