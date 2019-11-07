#!/usr/bin/env cwl-runner

label: "Split input directory into subpath flows"
cwlVersion: v1.0
class: ExpressionTool
requirements:
  InlineJavascriptRequirement: {}
inputs:
  data:
    type: Directory
expression: |
  ${
    var r = {};
    var l = inputs.data.listing;
    var n = l.length;
    for (var i = 0; i < n; i++) {
      switch (l[i].basename) {
        case '16S_rRNA':
          r['16s_blastdb_dir'] = l[i];
          break;
        case '23S_rRNA':
          r['23s_blastdb_dir'] = l[i];
          break;
        case 'RF00001.cm':
          r['5s_model_path'] = l[i];
          break;
        case 'AntiFamLib':
          r['AntiFamLib'] = l[i];
          break;
        case 'asn2pas.xsl':
          r['asn2pas_xsl'] = l[i];
          break;
        case 'CDD2':
          r['CDDdata'] = l[i];
          break;
        case 'cdd_add':
          r['CDDdata2'] = l[i];
          break;
        case 'product_rules.prt':
          r['defline_cleanup_rules'] = l[i];
          break;
        case 'gene_master.ini':
          r['gene_master_ini'] = l[i];
          break;
        case 'GeneMark':
          r['genemark_path'] = l[i];
          break;
        case 'rfam-amendments.xml':
          r['rfam_amendments'] = l[i];
          break;
        case 'Rfam.selected1.cm':
          r['rfam_model_path'] = l[i];
          break;
        case 'Rfam.seed':
          r['rfam_stockholm'] = l[i];
          break;
        case 'selenoproteins':
          r['selenoproteins'] = l[i];
          break;
        case 'thresholds.xml':
          r['thresholds'] = l[i];
          break;
        case 'species_genome_size.txt':
          r['species_genome_size'] = l[i];
          break;
        case 'uniColl_path':
          var ul = l[i].listing;
          var un = ul.length;
          for (var j = 0; j < un; j++) {
            switch (ul[j].basename) {
              case 'blast_dir':
                r['blast_rules_db_dir'] = ul[j];
                r['naming_blast_db'] = ul[j];
                break;
              case 'real_hmms':
                r['hmm_path'] = ul[j];
                break;
              case 'real_hmms.tab':
                r['hmms_tab'] = ul[j];
                break;
              case 'naming_hmms':
                r['naming_hmms_combined'] = ul[j];
                break;
              case 'naming_hmms.tab':
                r['naming_hmms_tab'] = ul[j];
                break;
              case 'naming.sqlite':
                r['naming_sqlite'] = ul[j];
                break;
              case 'taxonomy.sqlite3':
                r['taxon_db'] = ul[j];
                break;
              case 'cache':
                r['uniColl_cache'] = ul[j];
                break;
              case 'universal.xml':
                r['univ_prot_xml'] = ul[j];
                break;
              case 'wp-hashes.sqlite':
                r['wp_hashes'] = ul[j];
                break;
            }
          }
          break;
        case 'validation-results.xml':
          r['val_res_den_xml'] = l[i];
          break;
        case 'TaxSynon.tsv':
          r['tax_synon'] = l[i];
          break;      }
    }
    return r;
  }
outputs:
  16s_blastdb_dir:
    type: Directory
  23s_blastdb_dir:
    type: Directory
  5s_model_path:
    type: File
  AntiFamLib:
    type: Directory
  asn2pas_xsl:
    type: File
  blast_rules_db_dir:
    type: Directory
  CDDdata:
    # ${GP_HOME}/third-party/data/CDD/cdd - this is rpsblastdb
    type: Directory
  CDDdata2:
    # ${GP_HOME}/third-party/data/cdd_add
    type: Directory
  defline_cleanup_rules:
    # defline_cleanup_rules # ${GP_HOME}/etc/product_rules.prt
    type: File
  gene_master_ini:
    type: File
  genemark_path:
    type: Directory
  hmm_path:
    type: Directory
  hmms_tab:
    type: File
  naming_blast_db: # NamingDatabase
    type: Directory
  naming_hmms_combined:
    # ${GP_HOME}/third-party/data/BacterialPipeline/uniColl/ver-3.2/naming_hmms_combined.mft
    type: Directory
  naming_hmms_tab:
    type: File
  naming_sqlite:
    # /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/home/badrazat/local-install/2018-05-17/third-party/data/BacterialPipeline/uniColl/ver-3.2/naming.sqlite
    type: File
  rfam_amendments:
    type: File
  rfam_model_path:
    type: File
  rfam_stockholm:
    type: File
  selenoproteins:
    # /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/home/badrazat/local-install/2018-05-17/third-party/data/BacterialPipeline/Selenoproteins/selenoproteins, it's blastdb
    type: Directory
  species_genome_size:
    type: File
  taxon_db:
    type: File
  tax_synon:
    type: File
  thresholds:
    type: File
  uniColl_cache:
    type: Directory
  univ_prot_xml:
    type: File
  val_res_den_xml:
    type: File
  wp_hashes:
    type: File
