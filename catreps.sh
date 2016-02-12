FILES2CAT=`ls */BC_*fq | cut -f2 -d'/' | sort | uniq`
for FILE in $FILES2CAT; do
	echo $FILE
	cat */$FILE > all-$FILE
#	tar cvzf all-$FILE.tgz all-$FILE
#	rm all-$FILE	
done;
