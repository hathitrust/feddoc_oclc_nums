export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/bin:$PATH"

# export from the registry collection
mongoexport --quiet -d htgd -c registry -q '{deprecated_timestamp:{$exists:0}}' -f oclcnum_t --csv -o oclcnums.tmp

# split lines with multiple oclcs
sed -i 's/,/\n/g' oclcnums.tmp

# remove non-numbers
sed -i 's/[^0-9]//g' oclcnums.tmp

# sort / uniq them, remove empties and obvious stupidity
sort oclcnums.tmp | uniq | grep -v '^$' | grep -vP '^[0-1]0?$' > feddoc_oclc_nums.txt

git commit feddoc_oclc_nums.txt -m 'OCLC update' --author="Josh Steverman <jstever@umich.edu>"
git push
