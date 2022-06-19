#! /bin/bash

dir=${PWD##*/}
dir=${dir:-/}

if [ "${dir}" = "_classic_era_" ]; then
    dir='classic'
elif [ "${dir}" = "_classic_" ]; then
    dir='bcc'
elif [ "${dir}" = "_retail_" ]; then
    dir='retail'
else
    dir='unknown'
fi

rsync -chrvz -e 'ssh -p 3122' jki14@kaguya:~/archives/wow/${dir}/WTF .
rsync -chrvz -e 'ssh -p 3122' jki14@kaguya:~/archives/wow/${dir}/Interface .
rsync -chrvz -e 'ssh -p 3122' jki14@kaguya:~/archives/wow/${dir}/CustomMedias  .
