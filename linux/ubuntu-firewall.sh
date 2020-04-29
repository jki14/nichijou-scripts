apt-get install ufw

ufw default deny incoming
ufw default allow outgoing

ufw allow 3122/tcp
ufw allow 4861:4863/tcp
ufw allow 4861:4863/udp
ufw allow from 27.0.3.0/24 to any port 22 proto tcp
ufw allow from 27.0.3.0/24 to any port 22 proto udp

ufw delete 16

ufw status numbered

ufw enable

# cheatsheet
ufw allow from 115.165.95.0/24 to any port 22 proto tcp
ufw allow from 115.165.95.0/24 to any port 22 proto udp
ufw allow from 115.165.95.0/24 to any port 21 proto tcp
ufw allow from 115.165.95.0/24 to any port 21 proto udp

# ts3server
ufw allow 9987/udp
ufw allow 30033/tcp
ufw allow 10011/tcp
ufw allow 10022/tcp
