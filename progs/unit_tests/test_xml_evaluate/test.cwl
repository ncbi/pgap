#!/usr/bin/env cwl-runner
cwlVersion: v1.2
label: "xml_evaluate"

class: Workflow
inputs:
    initial_disc_file:
        type: File
    initial_val_file:
        type: File
    final_disc_file:
        type: File
    final_val_file:
        type: File
steps:
    initial_disc:
        run: ../../xml_evaluate.cwl
        in:
            input: initial_disc_file
            xpath_fail: {default: '//*[@severity="FATAL"]' }
        out: [success] 
    initial_val:    
        run: ../../xml_evaluate.cwl
        in:
            input: initial_val_file
            xpath_fail: {default: '//*[
                ( @severity="ERROR" or @severity="REJECT" )
                and not(contains(@code, "SEQ_PKG_NucProtProblem")) 
                and not(contains(@code, "SEQ_INST_InternalNsInSeqRaw")) 
                and not(contains(@code, "GENERIC_MissingPubRequirement")) 
            ]' }
        out: [success] 
    final_disc:        
        run: ../../xml_evaluate.cwl
        in:
            input: final_disc_file
            xpath_fail: {default: '//*[@severity="FATAL"]' }
        out: [] 
    final_val:            
        run: ../../xml_evaluate.cwl
        in:
            input: final_val_file
            xpath_fail: {default: '//*[
                ( @severity="ERROR" or @severity="REJECT" )
                and not(contains(@code, "SEQ_PKG_NucProtProblem")) 
                and not(contains(@code, "SEQ_INST_InternalNsInSeqRaw")) 
                and not(contains(@code, "GENERIC_MissingPubRequirement")) 
            ]' }
        out: [] 
outputs: []