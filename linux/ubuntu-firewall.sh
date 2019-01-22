apt-get install ufw

ufw default deny incoming
ufw default allow outgoing

ufw allow 3122/tcp
ufw allow 4861:4863/tcp
ufw allow 4861:4863/udp
ufw allow from 27.0.3.0/24 to any port 22 proto tcp
ufw allow from 27.0.3.0/24 to any port 22 proto udp

ufw status numbered

ufw enable
