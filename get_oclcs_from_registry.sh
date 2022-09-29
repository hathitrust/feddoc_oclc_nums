export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/bin:$PATH"

# export from the registry collection
mongoexport --quiet -d htgd -c registry -q '{deprecated_timestamp:{$exists:0}}' -f oclc --csv -o oclcnums.tmp

# split lines with multiple oclcs
sed -i 's/,/\n/g' oclcnums.tmp

# remove non-numbers
sed -i 's/[^0-9]//g' oclcnums.tmp

# sort / uniq them, remove empties and obvious stupidity
sort oclcnums.tmp | uniq | grep -v '^$' | grep -vP '^[0-1]0?$' > feddoc_oclc_nums.txt



# and from the source files
mongoexport --quiet -d htgd -c source_records -q '{deprecated_timestamp:{$exists:0}, in_registry:true}' -f oclc_alleged,oclc_resolved --csv -o oclcnums_raw.tmp

# split lines
sed -i 's/,/\n/g' oclcnums_raw.tmp
sed -i 's/[]["]//g' oclcnums_raw.tmp

# sort / uniq them, remove empties and obvious stupidity
sort oclcnums_raw.tmp | uniq | grep -v '^$' | grep -v 'numberLong' | grep -v 'oclc_' | grep -v 'e' | grep -vP '^[0-1]0?$' > feddoc_oclc_nums_raw.txt




git commit feddoc_oclc_nums.txt feddoc_oclc_nums_raw.txt -m 'OCLC update' --author="HathiTrust System <hathitrust-system@umich.edu>"
git push
