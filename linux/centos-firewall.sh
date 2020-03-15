systemctl start firewalld
firewall-cmd --zone=public --list-all
firewall-cmd --zone=public --remove-service=dhcpv6-client --permanent
firewall-cmd --zone=public --add-port=4862/tcp --permanent
firewall-cmd --zone=public --add-port=4862/udp --permanent
firewall-cmd --reload
firewall-cmd --zone=public --list-all
firewall-cmd --new-zone=sisters --permanent
firewall-cmd --zone=sisters --add-source=47.52.165.199 --permanent
firewall-cmd --zone=sisters --remove-source=47.52.165.199 --permanent
firewall-cmd --zone=sisters --add-source=3.114.17.227 --permanent
firewall-cmd --zone=sisters --add-source=27.0.3.0/24 --permanent
firewall-cmd --zone=sisters --add-source=115.165.95.0/24 --permanent
firewall-cmd --zone=sisters --add-port=21/tcp --permanent
firewall-cmd --zone=sisters --add-port=21/udp --permanent
firewall-cmd --reload
firewall-cmd --zone=sisters --list-all
chkconfig firewalld on
