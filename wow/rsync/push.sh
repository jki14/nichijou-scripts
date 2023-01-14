#! /bin/bash

dir=${PWD##*/}
dir=${dir:-/}

if [ "${dir}" = "_classic_era_" ]; then
    dir='classic'
elif [ "${dir}" = "_classic_" ]; then
    dir='wotlkc'
elif [ "${dir}" = "_retail_" ]; then
    dir='retail'
elif [ "${dir}" = "WotlkUS" ]; then
    dir='wotlkus'
else
    echo "unknow directory ${dir}."
    exit 1
fi

rsync -Rchrvz --exclude '*.bak' --delete -e 'ssh -p 3122' WTF jki14@kaguya:~/archives/wow/${dir}
rsync -Rchrvz --delete -e 'ssh -p 3122' Interface jki14@kaguya:~/archives/wow/${dir}
rsync -Rchrvz --delete -e 'ssh -p 3122' CustomMedias jki14@kaguya:~/archives/wow/${dir}
rsync -Rchrvz --delete -e 'ssh -p 3122' Fonts jki14@kaguya:~/archives/wow/${dir}
