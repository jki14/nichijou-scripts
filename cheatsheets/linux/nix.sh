# batch gz decompress
for f in *.gz; do gunzip -c "$f" >"${f%.*}"; done

# Git Commit at -12H
DT="$(date -v-12H '+%Y-%m-%d %H:%M:%S %z')"; GIT_AUTHOR_DATE="${DT}" GIT_COMMITTER_DATE="${DT}" git commit
