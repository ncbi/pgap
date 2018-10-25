label: "val_format"
class: CommandLineTool
    # these guys were not tested yet:
    # ncbi/gpdev                         2018-06-07.prod.build138     9c0cc08e797d        42 hours ago        1.25GB
    # ncbi/gpdev                         2018-06-06.prod.build136     2fcb57b2c754        2 days ago          1.16GB
    # ncbi/gpdev                         2018-06-06.prod.build135     8ff49a8e016b        2 days ago          1.47GB
    # ncbi/gpdev                         2018-06-05.prod.build13408   aefc19e11a58        3 days ago          1.33GB
    # ncbi/gpdev                         2018-06-01.prod.build13394   f7ccda0d6207        6 days ago          1.34GB
    # ncbi/gpdev                         2018-05-31.prod.build13377   b09ce0e324f8        8 days ago          1.34GB
    # ncbi/gpdev                         2018-05-29.prod.build13363   2644192c12eb        10 days ago         1.34GB
    # ncbi/gpdev                         2018-05-25.prod.build13356   1716691c935e        13 days ago         1.34GB
    # ncbi/gpdev                         2018-05-17.prod.build13293   2dea0c3eaeef        3 weeks ago         1.33GB
    # ncbi/gpdev                         2018-05-13.prod.build13267   60d988b3f9b0        3 weeks ago         1.33GB
    # ncbi/gpdev                         2018-05-10.prod.build13249   7cb57ee5dd57        4 weeks ago         1.33GB
    # ncbi/gpdev                         2018-05-10.prod.build13242   c28715a0dafa        4 weeks ago         1.33GB
    # ncbi/gpdev                         2018-05-08.prod.build13227   67a69b4b16ca        4 weeks ago         1.37GB
    # ncbi/gpdev                         2018-05-08.prod.build13226   46be2f12b356        4 weeks ago         1.37GB
    # ncbi/gpdev                         2018-05-07.prod.build13224   814dd61e3df0        4 weeks ago         1.38GB
    
baseCommand: val_format    
arguments: ['-ifmt', 'discrepancy', '-ofmt', 'xml']
inputs:
    input:
        type: File
        inputBinding:
            prefix: -i
    output_name:
        type: string
        default: annot.disc.xml
        inputBinding:
            prefix: -o
outputs:
    output:
        type: File
        outputBinding:
            glob: $(inputs.output_name)
