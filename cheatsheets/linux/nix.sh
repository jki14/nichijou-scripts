# batch gz decompress
for f in *.gz; do gunzip -c "$f" >"${f%.*}"; done
