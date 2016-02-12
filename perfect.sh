FBC=`cut -f1 user-sample-list.txt | sort | uniq | tr '[BDEFHIJKLMNOPQRSUVWXYZbdefhijklmnopqrsuvwxyz]' '.'`
FPR=`cut -f2 user-sample-list.txt | sort | uniq | tr '[BDEFHIJKLMNOPQRSUVWXYZbdefhijklmnopqrsuvwxyz]' '.'`
RBC=`cut -f3 user-sample-list.txt | sort | uniq | tr '[BDEFHIJKLMNOPQRSUVWXYZbdefhijklmnopqrsuvwxyz]' '.'`
RPR=`cut -f4 user-sample-list.txt | sort | uniq | tr '[BDEFHIJKLMNOPQRSUVWXYZbdefhijklmnopqrsuvwxyz]' '.'`

while { read -r FLINE1; read -r FLINE2; read -r FLINE3; read -r FLINE4; } do
	FOUTPUT=$FLINE1"~"$FLINE2"~"$FLINE3"~"$FLINE4;
echo "$FOUTPUT" >> input-test-f-sl.fq
done < input-test-f.fq


for BC in $FBC; do
	echo "^$BC$FPR" > patterns.txt
	grep -i -e ^$BC$FPR input-test-f-sl.fq | sed '/^--$/d' | tr '~' '\n' > FBC_$BC.fq &
done


while { read -r FLINE1; read -r FLINE2; read -r FLINE3; read -r FLINE4; } do
	FOUTPUT=$FLINE1"~"$FLINE2"~"$FLINE3"~"$FLINE4;
echo "$FOUTPUT" >> input-test-r-sl.fq
done < input-test-r.fq

for BC in $RBC; do
	echo "^$BC$RPR" >> patterns.txt
	grep -i -e ^$BC$RPR input-test-r-sl.fq | sed '/^--$/d' | tr '~' '\n' > RBC_$BC.fq &
done

grep -i -v -f patterns.txt input-test-f.fq | sed '/^--$/d' > FBC_un.fq &
grep -i -v -f patterns.txt input-test-r.fq | sed '/^--$/d' > RBC_un.fq &

rm input-test-*-sl.fq


#FILES2CAT=`ls */BC*fq | cut -f2 -d'/' | sort | uniq`
#for FILE in $FILES2CAT; do
#	cat */$FILE > all-$FILE
#	tar cvzf all-$FILE.tgz all-$FILE
#	rm all-$FILE	
#done;
