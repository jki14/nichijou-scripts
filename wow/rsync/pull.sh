#! /bin/bash

dir=${PWD##*/}
dir=${dir:-/}

if [ "${dir}" = "_classic_era_" ]; then
    dir='classic'
elif [ "${dir}" = "_classic_" ]; then
    dir='wotlkc'
elif [ "${dir}" = "_retail_" ]; then
    dir='retail'
else
    echo "unknow directory ${dir}."
    exit 1
fi

rsync -chrvz --delete -e 'ssh -p 3122' jki14@kaguya:~/archives/wow/${dir}/WTF .
rsync -chrvz --delete -e 'ssh -p 3122' jki14@kaguya:~/archives/wow/${dir}/Interface .
rsync -chrvz --delete -e 'ssh -p 3122' jki14@kaguya:~/archives/wow/${dir}/CustomMedias  .
