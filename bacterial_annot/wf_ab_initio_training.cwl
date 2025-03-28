#!/usr/bin/env cwl-runner
label: "Bacterial Annotation, pass 1, genemark training, by HMMs (first pass)"
cwlVersion: v1.2
class: Workflow

requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement

inputs:
  # control flow:
  go: 
        type: boolean[]
        
  # refdata parameters:
  asn_cache: Directory
  uniColl_cache: Directory
  naming_sqlite: # /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/home/badrazat/local-install/2018-05-17/third-party/data/BacterialPipeline/uniColl/ver-3.2/naming.sqlite
        type: File
  thresholds: File
  genemark_path: string
  selenoproteins:  # /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/home/badrazat/local-install/2018-05-17/third-party/data/BacterialPipeline/Selenoproteins/selenoproteins
      type: Directory
  selenoproteins_db:
      type: string
      default: blastdb
  
  # inputs from other flows:
  inseq: File
  trna_annots: File
  ncrna_annots: File
  Execute_CRISPRs_annots: File
  Generate_16S_rRNA_Annotation_annotation: File
  Generate_23S_rRNA_Annotation_annotation: File
  Post_process_CMsearch_annotations_annots_5S: File
  
  # algorithmic parameters:
  nogenbank: boolean
  
outputs:
  protein_aligns: 
    type: File
    outputSource: Resolve_Annotation_Conflicts/protein_aligns
  annotation: 
    type: File
    outputSource: Resolve_Annotation_Conflicts/annotation
  out_hmm_params: 
    type: File?
    outputSource: Run_GeneMark_Training/out_hmm_params
  models1: 
    type: File
    outputSource: Run_GeneMark_Training_post/models
    
steps:

  Resolve_Annotation_Conflicts:
    label: "Resolve Annotation Conflicts"
    run: ../progs/bacterial_resolve_conflicts.cwl
    in:
        features: # all external to this node
            - Execute_CRISPRs_annots # Execute CRISPR/annots
            - ncrna_annots # Post-process CMsearch Rfam annotations/annots
            - Generate_16S_rRNA_Annotation_annotation # Generate 16S rRNA Annotation/annotation
            - Generate_23S_rRNA_Annotation_annotation # Generate 23S rRNA Annotation/annotation
            - Post_process_CMsearch_annotations_annots_5S # Post-process CMsearch annotations/annots
            - trna_annots # Run tRNAScan/annot
        # input_annotation: mft not used
        # prot: mft not used
        # mapped-regions: mft not used
        thr: thresholds
        asn_cache: 
            source: [asn_cache]
            linkMerge: merge_flattened
    out: 
        - protein_aligns
        - annotation

  Run_GeneMark_Training:
    label: "Run GeneMark Training, genemark"
    run: ../progs/genemark_training.cwl
    in:
        asn_cache: 
            source: [asn_cache, uniColl_cache]
            linkMerge: merge_flattened
        sequences: inseq
        annotation: Resolve_Annotation_Conflicts/annotation
        genemark_path: genemark_path # ${GP_HOME}/third-party/GeneMark 
        min_seq_len:
            default: 200
        preliminary_models_name: # -out
            default: preliminary-models.asn
        thr:  thresholds
        tmp_dir_name: 
            default: workdir  
            # type: Directory
        nogenbank: 
            default: true
    out: [out_hmm_params, preliminary_models] 
  Run_GeneMark_Training_post: 
        label: "Run GeneMark Training (genemark_post)"
        run: ../progs/genemark_post.cwl  
        in: 
            abs_short_model_limit:
                default: 60
            asn_cache: [uniColl_cache, asn_cache] 
                # ${GP_cache_dir},${GP_HOME}/third-party/data/BacterialPipeline/uniColl/ver-3.2/cache
                # type: Directory[]
            genemark_annot: Run_GeneMark_Training/preliminary_models
            max_overlap:
                default: 120
            max_unannotated_region:
                default: 5000
            models_name: # -out
                default: models_training.asn
            out_product_ids_name: 
                default: all-proteins.ids
            selenoproteins: selenoproteins
            selenoproteins_db: selenoproteins_db
            short_model_limit:
                default: 180
            unicoll_sqlite: naming_sqlite
            nogenbank: 
                default: true
        out: [models] 
  
