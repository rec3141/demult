FOR1=`cut -f1 user-sample-list.txt | sort | uniq | tr -d ' '`
FORWARD1=`printf "${FOR1%?}"`
echo $FORWARD1

FOR2=`cut -f2 user-sample-list.txt | sort | uniq | tr -d ' ' | tr '\n' ','`
FORWARD2=`printf "${FOR2%?}"`
echo $FORWARD2

REV1=`cut -f3 user-sample-list.txt | sort | uniq | tr -d ' '`
REVERSE1=`printf "${REV1%?}"`
echo $REVERSE1

REV2=`cut -f4 user-sample-list.txt | sort | uniq | tr -d ' ' | tr '\n' ','`
REVERSE2=`printf "${REV2%?}"`
echo $REVERSE2

# size=${#myvar} #length of variable

#echo "-1 B:tcgGTCAA,tgaTTGAC -2 S:$FORWARD2 -3 R:N" >> arch-f.txt #with primer as in demultiplex-1
echo "-1 B:tcgGTCAA,tgaTTGAC -2 R:N" > arch-f.txt
echo "-1 B:atCGGTT,ctGGATG -2 R:N" >> arch-f.txt
echo "-1 B:cAACAC,gCCACA -2 R:N" >> arch-f.txt
echo "-1 B:AAGCG,GGTAC -2 R:N" >> arch-f.txt

#echo "-1 B:aatCCTAT,tctCAATC,ttcTCAGC -2 S:$REVERSE2 -3 R:N" >> arch-r.txt #with primer as in demultiplex-1
echo "-1 B:aatCCTAT,tctCAATC,ttcTCAGC -2 R:N" > arch-r.txt
echo "-1 B:ccACGTC,cgATTCC,gcGAAGT -2 R:N" >> arch-r.txt
echo "-1 B:gAGACT,gAGTGG,tGCTTA -2 R:N" >> arch-r.txt
echo "-1 B:AGGAA,ATCTG,CTAGG -2 R:N" >> arch-r.txt

gunzip *.gz

ln -s *R1*.fastq input-f.fq
ln -s *R2*.fastq input-r.fq


while read TAGLINE; do
	tagdust $TAGLINE input-f.fq -o BCF	
	mv BCF_un.fq input-f.fq
done < arch-f.txt

mv input-f.fq BCF_undecoded.fq

gzip *R1*.fastq &

while read TAGLINE; do
	tagdust $TAGLINE input-r.fq -o BCR	
	mv BCR_un.fq input-r.fq
done < arch-r.txt

mv input-r.fq BCR_undecoded.fq

gzip *R2*.fastq &
