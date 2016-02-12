
grep -c '^+$' BC* | tr ':' '_' | cut -f2,4 -d'_' | tr '_' '\t' | sort | uniq > sequence-list.txt
paste <(cut -f1,3 user-sample-list.txt | tr '\t' '-') <(cut -f5 user-sample-list.txt) | sort > sample-list.txt
join -t '	' sample-list.txt sequence-list.txt | sort -g -k3 -t'	' > sample-counts.txt
