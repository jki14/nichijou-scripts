#! /bin/bash

rsync -chrvz -e 'ssh -p 3122' jki14@kaguya:~/archives/wow/bcc/WTF .
rsync -chrvz -e 'ssh -p 3122' jki14@kaguya:~/archives/wow/bcc/Interface .
rsync -chrvz -e 'ssh -p 3122' jki14@kaguya:~/archives/wow/bcc/CustomMedias  .
