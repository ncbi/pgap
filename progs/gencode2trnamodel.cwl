#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: ExpressionTool

requirements: { InlineJavascriptRequirement: {} }

inputs:
  gencode: int
         # short gcode=nodeIt->GetNode()->GetGC();
         # if(gcode==6) {
             # genetic_codes = "cilnuc";
         # }
         # else if (gcode==9) {
             # genetic_codes = "echdmito";
         # }
         # else if (gcode==5) {
             # genetic_codes = "invmito";
         # }
         # else if (gcode==4) {
             # genetic_codes = "othmito";
         # }
         # else if (gcode==2) {
             # genetic_codes = "vertmito";
         # }
         # else if (gcode==3) {
             # genetic_codes = "ystmito";
         # }
expression: |
  ${ var gc = inputs.gencode; var gc2 = ""; if( gc == 4 ) { gc2="othmito"; } else if ( gc==6 ) { gc2="cilnuc"; } else if ( gc == 9) { gc2 = "echdmito" } else if ( gc == 5) { gc2 = "invmito"  } else if ( gc == 2) { gc2 = "vertmito"  } else if ( gc == 3) { gc2 = "ystmito"  } ; if ( gc2 != "" ) { return { "output": "/panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/ThirdParty/tRNAscan-SE/production/lib/tRNAscan-SE/gcode."+gc2 }; } else { return { "output": null }; } }

outputs:
  output: string?
