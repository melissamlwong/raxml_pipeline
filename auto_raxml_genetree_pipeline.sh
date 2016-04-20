#!/bin/sh

#This pipeline is created by Melissa M.L. Wong (Melissa.Wong@unil.ch). Last modified on 19 April 2016

###------specify executables and parameters here---------###
mafft=/home/melissamlwong/data/polygenetree_2/checkprot/mafft
omega=/home/melissamlwong/data/polygenetree_2/checkprot/clustalo-1.2.0-Ubuntu-x86_64
convertphy=/home/melissamlwong/data/polygenetree_2/checkprot/ElConcatenero.py
#protmodel=/home/melissamlwong/scripts/raxml_pipeline/proteinmodelselection.pl
raxml=/home/melissamlwong/scripts/raxml_pipeline/standard-RAxML-master/raxmlHPC-AVX
thread=1 #-T not required for AVX version
proteinmodel="-m PROTGAMMAJTTF"
nucleotidemodel="-m GTRGAMMA"
outgroup="" #-o option, multiple outgroups need to be separated by comma
bootstrap="-# 100"

if [ $# -eq 0 ]
then
    echo "\n USAGE\n   ./auto_raxml_genetree_pipeline.sh [input_1.fa .. input_N.fa | input_list.txt]\n"
    exit 0
elif [ $(echo $1 | awk '{l=split($0,a,"."); if (a[l]=="txt") print "true"}') = "true" ] #Need to replace code
then
    files=$(awk '{printf "%s ",$0}' $1)
else
    files=$@
fi
count=$(echo $files | wc -w)
echo "\nReading "$count" files in total\n"
COUNTER=0

for i in $files; do
    COUNTER=$((COUNTER+1))
    name=$(basename $i .fa)
    echo "Analyzing "$COUNTER "out of "$count" : "$i
    START=$(date +%s)
    type=$(awk 'BEGIN{RS=">";FS="\n";IGNORECASE = 1}NR==2{if ($2~/F|L|I|V|S|P|Y|H|Q|K|D|E|W|R|M/) type="prot"; else type="nuc"}END{print type}' $i)
    mkdir -p $name
    [ "$type" = "nuc" ] && ($mafft --quiet $i > $name/$name".aligned.fa") || ($omega -i $i -o $name/$name".aligned.fa" --threads $thread)
    cd $name
    $convertphy -c -if fasta -of phylip -in $name".aligned.fa"
    rm $name".aligned.fa"
    length=$(awk 'NR==1{print $2}' $name."phy")
    [ "$type" = "nuc" ] && partition="-q partitions.txt" && awk -v len="$length" 'BEGIN{print "DNA, codon1 = 1-"len"\\3\nDNA, codon2 = 2-"len"\\3\nDNA, codon3 = 3-"len"\\3"}' > partitions.txt
    rm *.tre
    [ "$type" = "nuc" ] && ($raxml -f a $nucleotidemodel -p 12345 -x 12345 $bootstrap -s $name".phy" -n T20 -n $name".tre" $outgroup $partition >> raxml.out 2>> raxml.err) || ($raxml -f a $proteinmodel -p 12345 -x 12345 $bootstrap -s $name".phy" -n T20 -n $name".tre" $outgroup >> raxml.out 2>> raxml.err)
    END=$(date +%s)
    echo $((END-START)) | awk '{if ($1>=60) printf "%s minutes...\n", int($1/60); else printf "Finishing '"$COUNTER"' out of '"$count"' : '"$i"' in %s seconds\n\n", $1}'
    cd ..
    awk -v name="$name" '{print ">"name"\n"$0"\n"}' $name/RAxML_bipartitions.$name.tre >> all.tre
done

