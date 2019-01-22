git filter-branch -f --env-filter \
    'if [ $GIT_COMMIT = 119f9ecf58069b265ab22f1f97d2b648faf932e0 ]
    then
        export GIT_AUTHOR_DATE="Sat May 19 01:01:01 2007 -0700"
        export GIT_COMMITTER_DATE="Sat May 19 01:01:01 2007 -0700"
    fi'
