# Automated RAxML pipeline version 1.0

##### Automatically create phylogenetic trees for a set of nucleotide/protein sequences using RAXML with the following steps:
  1) Reads input files and determines if each file contains nucleotide or protein sequences
  2) Aligns the sequences using MAFFT (nucleotide) or Clustal Omega (protein)
  3) Converts alignment to Phylip format
  4) Runs RAxML using the specified parameters

#### Getting Started
* #### Install the following dependencies:
  * Executable for [MAFFT](http://mafft.cbrc.jp/alignment/software/)
  * Executable for [Clustal Omega](http://www.clustal.org/omega/)
  * ElConcatenero.py and ElParsito.py available on [GitHub](https://github.com/ODiogoSilva/ElConcatenero)
  * Executable for [standard RAxML](https://github.com/stamatak/standard-RAxML)
  * Full paths to all dependencies must be specified in the program
  * NOTE: This program is tested on raxmlHPC-AVX and may require modification for other version)

* #### Specify RAxML parameters
  * Number of threads (Default: 1)
  * Number of bootstraps (Default: 100)
  * Default partition for nucleotide: 3 codon positions
  * Default partition for protein: unpartitioned
  * Protein model (Default: PROTGAMMAJTTF) 
  * Nucleotide model (Default: GTRGAMMA)
  * Outgroup (Default: None) *Can be specified using "-o" option

* #### Input files
  * Input files (.fa or .fasta extension) can be specified in the command line (separated by space). 
  * Alternatively, the program accepts a text file (.txt) containing the filenames (one line for each file)
  * The sequences must be formatted in FASTA format preferably with short names
  * NOTE: full paths must be provided if the files are not in the same directory

* #### Usage
   ```javascript
   ./auto_raxml_genetree_pipeline.sh [input_1.fa .. input_N.fa | input_list.txt]
   ```
* #### Testing sample data
   ```javascript
   ./auto_raxml_genetree_pipeline.sh input1.fa input2.fa

   Reading 2 files in total

   Analyzing 1 out of 2 : input1.fa
   Finishing 1 out of 2 : input1.fa in 28 seconds

   Analyzing 2 out of 2 : input2.fa
   Finishing 2 out of 2 : input2.fa in 50 seconds
   ```

* #### Output files

  * All gene trees (RAxML_biparitions*.tre) can be found in "all.tre" file in FASTA format (">"file_basename"\n"newick_format)
  * All other files (*.phy, raxml.out, raxml.err, RAxML_biparitions*.tre, RAxML_info*.tre and RAxML_bootstrap*.tre ) are stored in a folder labeled with the basename of the file. 

### Contact/Questions

Please email me at Melissa.Wong@unil.ch with the subject title "Automated raxml pipeline: ..."

