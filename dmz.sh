#! /bin/bash
FIRST=$(ls -la /etc/ | grep firstexe)

if [ "${FIRST}" = "" ]
        then
sudo sh -c 'echo root:Passw0rd | chpasswd'
sudo sh -c 'echo josepedroferreirafranco:Passw0rd | chpasswd'
sudo apt -y update && apt -y upgrade  

sudo export DEBIAN_FRONTEND=noninteractive
sudo apt-get install bash-completion -y
sudo -u root -s sh -c 'echo "if [ -f /etc/bash_completion ]; then" >> /root/.bash_profile'
sudo -u root -s sh -c 'echo "  . /etc/bash_completion" >> /root/.bash_profile'
sudo -u root -s sh -c 'echo "fi" >> /root/.bash_profile'

sudo -u root -s sh -c 'ssh-keygen -q -N ""  -f /root/.ssh/id_rsa'
sudo -u root -s sh -c 'sudo echo "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAkz2xT7guXfjyBEsYR+gNVgDaf3H6U/X+1F+X0+DIPqX4LStA7RClzpxlxzJQ4pXxLccu11WeRwXkYYKEi1sn4icHyAL4U3pzV1Mw1Q6LlXLczUrBhOIuVcNxSUpHiwSiFjUClDYUu2t68gUwiHyFRPt6BaurzjNUf5JrQoNlJbZSmzquVaNkp4KjJ9Hn5YaV2TgQaZ4tCej9Vggv0om8inoKyJ38cCIeDsNeU7/WUXnPIKPnO7/gzXmZ5hwzBxnP6awFWeOzIfCMmFC1ttEOGhz/eWin1tjNLxkadWE+PFwGmKB5wBMWrmQu6PctlbJaKN56pY52U+PHONlFd2FkXw== rsa-key-20200303" > /root/.ssh/authorized_keys'
sudo -u root -s sh -c 'echo "PermitRootLogin yes" >> /etc/ssh/sshd_config'
sudo -u root -s sh -c 'systemctl restart sshd.service' 

sudo DEBIAN_FRONTEND=noninteractive apt -y install resolvconf dnsutils net-tools tcpdump postfix postfix-doc dovecot-imapd dovecot-pop3d libsasl2-dev sasl2-bin  apache2* 
sudo echo "http://www.skills.pt/" > /var/www/html/index.html
sudo mkdir /var/www/htmls
sudo echo "https://www.skills.pt/" > /var/www/htmls/index.html
sudo a2enmod ssl 

sudo -u root -s sh -c 'echo "prepend domain-name-servers 172.16.0.2;"  >>  /etc/dhcp/dhclient.conf'

echo "" > /etc/firstexe
sudo reboot
fi