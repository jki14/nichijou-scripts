hostname eton
vi /etc/hostname 
hostname
useradd -m -s /bin/bash jki14
passwd jki14
passwd
vi /etc/ssh/sshd_config
yum update
systemctl start firewalld
firewall-cmd --zone=public --list-all
firewall-cmd --zone=public --remove-service=dhcpv6-client --permanent
firewall-cmd --zone=public --add-port=4862/tcp --permanent
firewall-cmd --zone=public --add-port=4862/udp --permanent
firewall-cmd --reload
firewall-cmd --zone=public --list-all
chkconfig firewalld on
reboot
sh shadowsocks-all.sh 2>&1 | tee shadowsocks-all.log
vi /etc/shadowsocks-libev/config.json
reboot
