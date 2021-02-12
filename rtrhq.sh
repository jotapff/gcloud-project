#! /bin/bash
FIRST=$(ls -la /etc/ | grep firstexe)

if [ "${FIRST}" = "" ]
        then

sudo sh -c 'echo root:Passw0rd | chpasswd'
sudo sh -c 'echo josepedroferreirafranco:Passw0rd | chpasswd'
sudo apt -y update && apt -y upgrade  

sudo apt-get install bash-completion -y
sudo -u root -s sh -c 'echo "if [ -f /etc/bash_completion ]; then" >> /root/.bash_profile'
sudo -u root -s sh -c 'echo "  . /etc/bash_completion" >> /root/.bash_profile'
sudo -u root -s sh -c 'echo "fi" >> /root/.bash_profile'

sudo -u root -s sh -c 'ssh-keygen -q -N ""  -f /root/.ssh/id_rsa'
sudo -u root -s sh -c 'sudo echo "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAkz2xT7guXfjyBEsYR+gNVgDaf3H6U/X+1F+X0+DIPqX4LStA7RClzpxlxzJQ4pXxLccu11WeRwXkYYKEi1sn4icHyAL4U3pzV1Mw1Q6LlXLczUrBhOIuVcNxSUpHiwSiFjUClDYUu2t68gUwiHyFRPt6BaurzjNUf5JrQoNlJbZSmzquVaNkp4KjJ9Hn5YaV2TgQaZ4tCej9Vggv0om8inoKyJ38cCIeDsNeU7/WUXnPIKPnO7/gzXmZ5hwzBxnP6awFWeOzIfCMmFC1ttEOGhz/eWin1tjNLxkadWE+PFwGmKB5wBMWrmQu6PctlbJaKN56pY52U+PHONlFd2FkXw== rsa-key-20200303" > /root/.ssh/authorized_keys'
sudo -u root -s sh -c 'echo "PermitRootLogin yes" >> /etc/ssh/sshd_config'
sudo -u root -s sh -c 'systemctl restart sshd.service' 
 
sudo DEBIAN_FRONTEND=noninteractive  apt -y install resolvconf dnsutils net-tools tcpdump easy-rsa openvpn bind9* netfilter-persistent iptables-persistent

sudo -u root -s sh -c 'echo "net.ipv4.ip_forward=1"  >> /etc/sysctl.conf'
sudo sysctl -p

sudo iptables -t nat -A POSTROUTING -o ens4 -j MASQUERADE
sudo iptables -t nat -A PREROUTING -i ens4 -p tcp -m tcp --dport 2222 -j DNAT --to-destination 192.168.0.3:22
sudo iptables -t nat -A PREROUTING -i ens4 -p tcp -m tcp --dport 80 -j DNAT --to-destination 172.16.0.3
sudo iptables -t nat -A PREROUTING -i ens4 -p tcp -m tcp --dport 443 -j DNAT --to-destination 172.16.0.3
sudo iptables -t nat -A PREROUTING -i ens4 -p tcp -m tcp --dport 222 -j DNAT --to-destination 172.16.0.3:22
sudo iptables -t nat -A PREROUTING -i ens4 -p tcp -m tcp --dport 5901 -j DNAT --to-destination 192.168.0.3
sudo netfilter-persistent save

sudo mv /usr/share/easy-rsa/ /etc/ 
sudo -u root -s sh -c 'echo "set_var EASYRSA_DN     "org"" >> /etc/easy-rsa/vars'
sudo -u root -s sh -c 'echo "set_var EASYRSA_REQ_COUNTRY    "PT" " >> /etc/easy-rsa/vars'
sudo -u root -s sh -c 'echo "set_var EASYRSA_REQ_PROVINCE   "Azores"" >> /etc/easy-rsa/vars'
sudo -u root -s sh -c 'echo "set_var EASYRSA_REQ_CITY       "Ponta Delgada"" >> /etc/easy-rsa/vars'
sudo -u root -s sh -c 'echo "set_var EASYRSA_REQ_ORG        "SKILLS"" >> /etc/easy-rsa/vars'
sudo -u root -s sh -c 'echo "set_var EASYRSA_REQ_EMAIL      "me@skills.pt"" >> /etc/easy-rsa/vars'
sudo -u root -s sh -c 'echo "set_var EASYRSA_REQ_OU         "SKILLS"" >> /etc/easy-rsa/vars'
sudo -u root -s sh -c 'echo "set_var EASYRSA_PKI            "/etc/easy-rsa/pki"" >> /etc/easy-rsa/vars'
sudo -u root -s sh -c 'echo "alias easyrsa=/etc/easy-rsa/easyrsa" >> ~/.bashrc'

sudo -u root -s sh -c 'echo "prepend domain-name-servers 127.0.0.1;"  >>  /etc/dhcp/dhclient.conf'

echo "" > /etc/firstexe
sudo reboot

fi