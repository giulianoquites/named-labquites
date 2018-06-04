#!/bin/bash
clear
Menu(){
   echo "------------------------------------------"
   echo "    LabQuites                             "
   echo "------------------------------------------"
   echo
   echo "[ 1 ] DNS Master"
   echo "[ 2 ] DNS Slave"
   echo
   echo -n "Number 1, 2 and 3 ? "
   read opcao
   case $opcao in
      1) Master ;;
      2) Slave ;;
      3) exit ;;
      *) "Not Option." ; echo ;;
   esac
}
Master() {
# Named-LabQuites
# Create named in CentOS 7
# System IP Address Static
echo "Update System";
yum update -y;
echo "Disabel NetworkManager";
systemctl stop NetworkManager;
systemctl disable NetworkManager;

# Install DNS and Git
echo "Install repositorio, Git and named";
yum install wget;
wget http://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm;
rpm -ivh epel-release-7-11.noarch.rpm;
yum install net-tools.x86_64;
yum install bind-utils.x86_64 bind.x86_64 -y;
yum install git -y;
echo "Clone Repo and config in DNS Master";
# Clone repo and config in DNS
git clone https://github.com/giulianoquites/named-labquites.git;
cd   named-labquites;
cat  master/resolv.conf > /etc/resolv.conf;
cat  master/named.conf > /etc/named.conf;
echo -n "Whatis IP for Named Slave ? "
   read IPSlave
IPHOST=$(ifconfig  | grep -i 192.168  | awk {' print $2'})
IPHOST2=$(ifconfig  | grep -i 192.168  | awk {' print $2'} | cut -d"." -f 4)
cp master/192.168.15.db /var/named/;
cp master/labquites.local.db /var/named/;
chown named:named /var/named/labquites.local.db /var/named/192.168.15.db;
echo "Config files for IP VM"
sed -i s/192.168.15.132/$IPHOST/g /var/named/labquites.local.db
sed -i s/132/$IPHOST2/g /var/named/192.168.15.db
sed -i s/192.168.15.133/$IPSlave/g /etc/named.conf

# Enable and Start named
systemctl enable named;
systemctl restart named;

# Test DNS
nslookup google.com.br  127.0.0.1;
nslookup labquites.local;
nslookup $IPHOST;
sleep 4
dig www.google.com.br @127.0.0.1;
sleep 4;
Menu
}

Slave() {
# Named-LabQuites
# Create named in CentOS 7
# System IP Address Static
echo "Update System";
yum update -y;
echo "Disabel NetworkManager";
systemctl stop NetworkManager;
systemctl disable NetworkManager;
echo -n "Whatis IP for Named Master ? "
   read IPMASTER

# Install DNS and Git
echo "Install repositorio, Git and named";
yum install wget;
wget http://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm;
rpm -ivh epel-release-7-11.noarch.rpm;
yum install net-tools.x86_64;
yum install bind-utils.x86_64 bind.x86_64 -y;
yum install git -y;
echo "Clone Repo and config in DNS Slave";
# Clone repo and config in DNS
git clone https://github.com/giulianoquites/named-labquites.git;
cd   /root/named-labquites;
cat  slave/resolv.conf > /etc/resolv.conf;
cat  slave/named.conf > /etc/named.conf;
sed -i s/192.168.15.132/$IPMASTER/g /etc/named.conf 

echo "Start Named";
# Enable and Start named
systemctl enable named;
systemctl restart named;

echo "Test DNS";
# Test DNS
nslookup google.com.br  127.0.0.1;
nslookup labquites.local;
nslookup $IPHOST;
sleep 4
dig www.google.com.br @127.0.0.1;
sleep 4;
Menu
}
Menu
