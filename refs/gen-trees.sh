echo "Generating tree diagrams..."

pyang -p ../ -f tree --tree-line-length 69 --tree-print-groupings ../ietf-truststore@*.yang > ietf-truststore-tree.txt
pyang -p ../ -f tree --tree-line-length 69 --tree-print-groupings --tree-no-expand-uses ../ietf-truststore@*.yang > ietf-truststore-tree-no-expand.txt

pyang -p ../ -f tree --tree-line-length 69 --tree-print-groupings ../ex-truststore-usage@*.yang > ex-truststore-usage-tree.txt
pyang -p ../ -f tree --tree-line-length 69 --tree-print-groupings --tree-no-expand-uses  ../ex-truststore-usage@*.yang > ex-truststore-usage-tree-no-expand.txt


extract_grouping_with_params() {
  # $1 name of grouping
  # $2 addition CLI params
  # $3 output filename
  pyang -p ../ -f tree --tree-line-length 69 --tree-print-groupings $2 ../ietf-truststore@*.yang > ex-truststore-groupings-tree.txt
  cat ex-truststore-groupings-tree.txt | sed -n "/^  grouping $1/,/^  grouping/p" > tmp
  c=$(grep -c "^  grouping" tmp)
  if [ "$c" -ne "1" ]; then
    ghead -n -1 tmp > $3
    rm tmp
  else
    mv tmp $3
  fi
}

extract_grouping() {
  # $1 name of grouping
  #extract_grouping_with_params "$1" "" "tree-$1.expanded.txt"
  extract_grouping_with_params "$1" "--tree-no-expand-uses" "tree-$1.no-expand.txt"
}

extract_grouping local-or-truststore-certs-grouping
extract_grouping local-or-truststore-public-keys-grouping {
extract_grouping truststore-grouping


