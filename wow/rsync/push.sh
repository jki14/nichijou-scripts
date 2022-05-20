#! /bin/bash

rsync -Rchrvz -e 'ssh -p 3122' WTF jki14@kaguya:~/archives/wow/bcc
rsync -Rchrvz -e 'ssh -p 3122' Interface jki14@kaguya:~/archives/wow/bcc
rsync -Rchrvz -e 'ssh -p 3122' CustomMedias jki14@kaguya:~/archives/wow/bcc
