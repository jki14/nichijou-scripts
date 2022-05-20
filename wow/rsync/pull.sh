#! /bin/bash

rsync -Rchrvz -e 'ssh -p 3122' jki14@kaguya:~/archives/wow/bcc/WTF .
rsync -Rchrvz -e 'ssh -p 3122' jki14@kaguya:~/archives/wow/bcc/Interface .
rsync -Rchrvz -e 'ssh -p 3122' jki14@kaguya:~/archives/wow/bcc/CustomMedias  .
