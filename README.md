# PGAP
NCBI Prokaryotic Genome Annotation Pipeline

The NCBI Prokaryotic Genome Annotation Pipeline is designed to annotate
bacterial and archaeal genomes (chromosomes and plasmids).

Genome annotation is a multi-level process that includes prediction of
protein-coding genes, as well as other functional genome units such as
structural RNAs, tRNAs, small RNAs and pseudogenes.

NCBI has developed an automatic prokaryotic genome annotation pipeline
that combines ab initio gene prediction algorithms with homology based
methods. The first version of NCBI Prokaryotic Genome Pipeline was developed 
in 2001 and is regularly upgraded to improve structural and functional 
annotation quality ([Li W, O'Neill KR et al 2021](https://www.ncbi.nlm.nih.gov/pubmed/33270901)). Recent 
improvements include utilization of curated protein profile hidden Markov models (HMMs), 
and curated complex domain architectures for functional annotation of proteins and 
annotation of Enzyme Commission numbers and Gene Ontology terms. Post-annotation, the 
completeness of the annotated gene set is estimated with 
[CheckM](https://pubmed.ncbi.nlm.nih.gov/25977477/).

The workflow provided here also offers the option to confirm or correct the organism
associated with the genome assembly prior to starting the annotation, using the 
[Average Nucleotide Identity tool](https://pubmed.ncbi.nlm.nih.gov/29792589/).

Get started by watching this [webinar](https://www.youtube.com/watch?v=pNn_-_46lpI)!

| Need to assemble the genome too? Use [RAPT](https://github.com/ncbi/rapt) for producing an annotated genome starting from short reads|
| --- |

## Instructions

To run the PGAP pipeline you will need Linux, or some compatible container technology, CWL (Common
Workflow Language), and about 30GB of supplemental data. We provide
instructions here for running under the CWL reference implementation,
cwltool. Full instructions for installing, running, and interpreting
the results may be found in our [wiki](https://github.com/ncbi/pgap/wiki).

## References

### NCBI

[Expanding the Prokaryotic Genome Annotation Pipeline reach with protein family model curation.](https://www.ncbi.nlm.nih.gov/pubmed/33270901)\
Li W, O'Neill KR, Haft DH, DiCuccio M, Chetvernin V, Badretdin A, Coulouris G, Chitsaz F, Derbyshire MK, Durkin AS, Gonzales NR, Gwadz M, Lanczycki CJ, Song JS, Thanki N, Wang J, Yamashita RA, Yang M, Zheng C, Marchler-Bauer A, Thibaud-Nissen F. RefSeq:  Nucleic Acids Res. 2021 Jan 8;49(D1):D1020-D1028.

[RefSeq: an update on prokaryotic genome annotation and curation.](https://www.ncbi.nlm.nih.gov/pubmed/29112715)\
Haft DH, DiCuccio M, Badretdin A, Brover V, Chetvernin V, O'Neill K, Li W, Chitsaz F, Derbyshire MK, Gonzales NR, Gwadz M, Lu F, Marchler GH, Song JS, Thanki N, Yamashita RA, Zheng C, Thibaud-Nissen F, Geer LY, Marchler-Bauer A, Pruitt KD.\
Nucleic Acids Res. 2018 Jan 4;46(D1):D851-D860.

[NCBI prokaryotic genome annotation pipeline.](https://www.ncbi.nlm.nih.gov/pubmed/27342282)\
Tatusova T, DiCuccio M, Badretdin A, Chetvernin V, Nawrocki EP, Zaslavsky L, Lomsadze A, Pruitt KD, Borodovsky M, Ostell J.\
Nucleic Acids Res. 2016 Aug 19;44(14):6614-24. Epub 2016 Jun 24.

[Using average nucleotide identity to improve taxonomic assignments in prokaryotic genomes at the NCBI.](https://www.ncbi.nlm.nih.gov/pubmed/29792589)\
Ciufo S, Kannan S, Sharma S, Badretdin A, Clark K, Turner S, Brover S, Schoch 
CL, Kimchi A, DiCuccio M.\
Int J Syst Evol Microbiol. 2018 Jul;68(7):2386-2392.

### GeneMarkS-2+

[Modeling leaderless transcription and atypical genes results in more accurate gene prediction in prokaryotes](https://www.ncbi.nlm.nih.gov/pubmed/29773659/)\
Lomsadze A, Gemayel K, Tang S, Borodovsky M.\
Genome Research. 2018; 28(7):1079-1089.

### CheckM
[CheckM: assessing the quality of microbial genomes recovered from isolates, single cells, and metagenomes](https://pubmed.ncbi.nlm.nih.gov/25977477/)\
Parks DH, Imelfort M, Skennerton CT, Hugenholtz P, Tyson GW.\
Genome Research. 2015; 25(7):1043-1055.


### TIGRFAMs

[TIGRFAMs: a protein family resource for the functional identification of proteins.](https://www.ncbi.nlm.nih.gov/pubmed/11125044)\
Haft DH, Loftus BJ, Richardson DL, Yang F, Eisen JA, Paulsen IT, White O.\
Nucleic Acids Res. 2001 Jan 1;29(1):41-3.

[The TIGRFAMs database of protein families.](https://www.ncbi.nlm.nih.gov/pubmed/12520025)\
Haft DH, Selengut JD, White O.\
Nucleic Acids Res. 2003 Jan 1;31(1):371-3.

[TIGRFAMs and Genome Properties: tools for the assignment of molecular function and biological process in prokaryotic genomes.](https://www.ncbi.nlm.nih.gov/pubmed/17151080)\
Selengut JD, Haft DH, Davidsen T, Ganapathy A, Gwinn-Giglio M, Nelson WC, Richter AR, White O.\
Nucleic Acids Res. 2007 Jan;35(Database issue):D260-4. Epub 2006 Dec 6.

[TIGRFAMs and Genome Properties in 2013.](https://www.ncbi.nlm.nih.gov/pubmed/23197656)\
Haft DH, Selengut JD, Richter RA, Harkins D, Basu MK, Beck E.\
Nucleic Acids Res. 2013 Jan;41(Database issue):D387-95. doi: 10.1093/nar/gks1234. Epub 2012 Nov 28.

## LICENSING TERMS

### NCBI PGAP CWL

The NCBI PGAP CWL and other code authored by NCBI is a "United States
Government Work" under the terms of the United States Copyright
Act. It was written as part of the authors' official duties as United
States Government employees and thus cannot be copyrighted. This
software is freely available to the public for use. The National
Library of Medicine and the U.S. Government have not placed any
restriction on its use or reproduction.

Although all reasonable efforts have been taken to ensure the accuracy
and reliability of the software and data, the NLM and the
U.S. Government do not and cannot warrant the performance or results
that may be obtained by using this software or data. The NLM and the
U.S. Government disclaim all warranties, express or implied, including
warranties of performance, merchantability or fitness for any
particular purpose.

Please cite NCBI in any work or product based on this material.

### Third-party tools

The Docker image contains third-party tools distributed under the
licensing terms of the respective license holders.

### GeneMarkS-2+

GeneMarkS-2+ is distributed as part of PGAP with limited rights of use
and redistribution from the Georgia Tech Research Corporation. See the
[full text of the license](GeneMarkS_Software_License.txt).

### CheckM

GNU General Public License v3.0

Permissions of this strong copyleft license are conditioned on making available complete source code of licensed works and modifications, which include larger works using a licensed work, under the same license. Copyright and license notices must be preserved. Contributors provide an express grant of patent rights. See the [full text of the license](Check-M-license.txt).

### TIGRFAMs

The original TIGRFAMs database was a research project of the J. Craig
Venter Institute \(JCVI\) . TIGRFAMs, short for The Institute for
Genomic Research's database of protein families, is a collection of
manually curated protein families focusing primarily on prokaryotic
sequences. It consists of hidden Markov models \(HMMs\), multiple
sequence alignments, Gene Ontology \(GO\) terminology, Enzyme Commission
\(EC\) numbers, gene symbols, protein family names, descriptive text,
cross-references to related models in TIGRFAMs and other databases,
and pointers to the literature. The work has been described in the
articles listed in the References section above and use of the
TIGRFAMs database must grant proper attribution by citing those four
articles.

As of April 2018, rights were transferred to the National Center for
Biotechnology Information \(NCBI\), National Library of Medicine, NIH,
for the data to be made available for distribution under a Creative
Commons Attribution-ShareAlike 4.0 license.  Please see
(https://creativecommons.org/licenses/by-sa/4.0/) for a brief summary
of the license and
(https://creativecommons.org/licenses/by-sa/4.0/legalcode) to see the
full text.
