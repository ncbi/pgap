#!/usr/bin/env cwl-runner
label: "Naming AMR Genes Plane"
cwlVersion: v1.2
class: Workflow
requirements:
    - class: SubworkflowFeatureRequirement
    - class: MultipleInputFeatureRequirement
    
inputs:
  annotation:
    type: File
  taxon_db:
    type: File
  taxid:
    type: int
  database:
    type: Directory
  tax_group_name:
    type: string
steps:
  Prepare_AMR_Annotation_Input:
    label: "Prepare AMR Annotation Input"
    run: ../progs/asn_translator.cwl
    in: 
      input: annotation
      output_output: {default: 'annotation.asn'}
    out: [output]    
  Remove_Extraneous_Protein_Ids:
    label: "Remove Extraneous Protein Ids"
    run: ../progs/asn_adjust.cwl
    # tasktype adjust_entries
    # action node class: CAdjustActionNode
    # action node an_adjust_node
    # action node complication: pass input if prog generates no output
    # asn_adjust -input-manifest inp/entries.mft -output-path out -fix-prots-to-gnl-id -t
    # creates translated.asn if creates
    in:
      input: Prepare_AMR_Annotation_Input/output
    out: [entries]
  Get_Fasta:
    label: "Get Fasta"
    run: ../progs/asn2fasta.cwl
    in:
        i: Remove_Extraneous_Protein_Ids/entries
        type:
            default: seq-entry
        prot_fasta_name:
            default: proteins.fa
        nuc_fasta_name:
            default: nucs.fa
            
    out: [nuc_fasta, prot_fasta]
    # tasktype get_fasta_from_asn
    # action node class: CAsn2FastaActionNode
    # action node an_asn2fasta
    # application: asn2fasta -i translated.asn -op out/proteins.fa -on out/nucs.fa -serial text -type seq-entry
  Convert_Annotations_To_Gff:
    label: "Convert Annotations To Gff"
    run: ../progs/gp_annot_format.cwl
    in:
        input: Remove_Extraneous_Protein_Ids/entries
        ifmt:
            default: seq-entry
        t:
            default: true
        ofmt:
            default: gff3
        oname:
            default: 'annot.gff'
        exclude_external:
            default: true
    out: [output]
    
    # tasktype: annot_to_gff
    # action node class: CAnnotFormatActionNode
    # action node: an_annot_format
    # application: gp_annot_format -ifmt seq-entry -input-manifest inp/entries.mft -o out/annot.gff -ofmt gff3 -output-manifest out/gff.mft -exclude-external -t
  AMR_report:
    label: "AMR Report"
    run: ../task_types/tt_amr_finder_plus.cwl
    in:
      proteins: Get_Fasta/prot_fasta
      gff: Convert_Annotations_To_Gff/output
      nucleotides: Get_Fasta/nuc_fasta
      database: database
      taxon_db: taxon_db
      taxid: taxid
      organism: tax_group_name
    out: [report]
    # tasktype: amr_finder_plus
    # action node: an_amr_plus
    # action node class: CAmrPlusActionNode
    # application GPC: amr_finder_plus -executable ${GP_HOME}/third-party/AMRFinderPlus/amrfinder -database-location ${GP_HOME}/third-party/data/AMRFinderPlus -special-organisms Salmonella,Escherichia|Shigella,Campylobacter
    # not sure why '=' delimiters are applied below, according to --help, they 
    # are not needed.
    #
    # application: amrfinder '--protein=brd/get_fasta_from_asn.258858932/out/proteins.fa' '--gff=brd/annot_to_gff.258858942/out/annot.gff' '--nucleotide=brd/get_fasta_from_asn.258858932/out/nucs.fa' '--database=/netmnt/vast01/gp/ThirdParty/ExternalData/AMRFinderPlus/2023-04-17.1' --threads 1 '--output=brd/amr_finder_plus.258858952/out/output.tsv' --plus --gpipe_org --pgap
    # Complications:
    # - need to install new third party application amr_finder_plus (ticket opened)
    # - need to install new third party database amr_finder_plus (ticket opened)
    #   currently only dead symlinks to VAST gp/ThirdParty area
    # - uses PATH to pass some info to application
    # - action node specifies parameters conditional on "organism" parameter
    #   GPIPE_REGR_BCT does not have it set, but Pathogen production on the cloud
    #   will.
    # - action node will be implemented as a separate application (ticket opened)
    
    
  Map_Contig_and_Protein_Ids:
    label: "Map Contig and Protein Ids"
    run: ../progs/map_amr_ids.cwl
    # Task Type: map_amr_ids
    # GCP parameters: map_amr_ids -gencoll-id ${GP_gencoll_release} -id-mappings ${output}/id_mappings.tsv -input-manifest ${input.report} -o ${output}/report.tsv -dryrun -load-to-database
    # action node: CMapAmrIdsActionNode
    # application: map_amr_ids -gencoll-id 37054708 -id-mappings out/id_mappings.tsv -input-manifest inp/report.mft -o out/report.tsv -dryrun -load-to-database
    
    in:
      report: AMR_report/report
      gencoll_id:
      id_mappings_outname:
        default: 'id_mappings.tsv'
      report_outname:
        default: 'modified_report.tsv'
      dryrun: 
        default: true 
      load_to_database: 
        default: false
    out: [report]
      
      
outputs:
  amr_report:
    type: File
    outputSource:
      Map_Contig_and_Protein_Ids/report

