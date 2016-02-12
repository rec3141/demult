pwd
#FORWARD_FILES=`ls output-f*.fq`
#REVERSE_FILES=`ls output-r*.fq`
FORWARD_FILES=`ls BCF_*.fq`
REVERSE_FILES=`ls BCR_*.fq`

#choice of tilde ~ should be safe for foreseeable future as it is out of the range of used quality scores
for FFILE in $FORWARD_FILES $REVERSE_FILES; do
	echo "$FFILE"
	FOUTPUT=''
	while { read -r FLINE1; read -r FLINE2; read -r FLINE3; read -r FLINE4; } do
		FOUTPUT=$FLINE1"~"$FLINE2"~"$FLINE3"~"$FLINE4;
	echo "$FOUTPUT" >> post.tmp.$FFILE
	done < $FFILE
	sort post.tmp.$FFILE > post.sort.$FFILE
	rm post.tmp.$FFILE
done

#some samples are not being cleanly mached (3/96)
#908378 1135473 144298323 all-BC_atCGGTT-tGCTTA_f.fq
#926096 1157620 143873465 all-BC_atCGGTT-tGCTTA_r.fq
#1021336 1276669 162242217 all-BC_ctGGATG-CTAGG_f.fq
#1054864 1318580 162292029 all-BC_ctGGATG-CTAGG_r.fq
#1279642 1599552 201360573 all-BC_gCCACA-ccACGTC_f.fq
#1296876 1621095 203426447 all-BC_gCCACA-ccACGTC_r.fq

for FFILE in $FORWARD_FILES; do
	for RFILE in $REVERSE_FILES; do
           echo $FFILE $RFILE
	   join -o 1.1,1.2 -o 2.1,2.2 post.sort.$FFILE post.sort.$RFILE > post.join.$FFILE.$RFILE
#	   F1=`echo $FFILE | cut -f2 -d'_' | cut -f1 -d'.'`
#	   R1=`echo $RFILE | cut -f2 -d'_' | cut -f1 -d'.'` 
	   F1=`echo $FFILE | cut -f3 -d'_' | cut -f1 -d'.'`
	   R1=`echo $RFILE | cut -f3 -d'_' | cut -f1 -d'.'` 
	   cut -f1-2 -d' ' post.join.$FFILE.$RFILE | tr '~' '\n' > "BC_"$F1"-"$R1"_f.fq"
	   cut -f3-4 -d' ' post.join.$FFILE.$RFILE | tr '~' '\n' > "BC_"$F1"-"$R1"_r.fq"	
	   rm post.join.$FFILE.$RFILE
	done
done

#rm post.*
