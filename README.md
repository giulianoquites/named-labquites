# Named-LabQuites
# Create named in CentOS 7
# Update System
yum update -y
 
reboot

# Install DNS and Git 
yum install wget

wget http://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm

rpm -ivh epel-release-7-11.noarch.rpm

yum install net-tools.x86_64

yum install bind-utils.x86_64 bind.x86_64 -y

yum install git -y

# Clone repo and config in DNS
git clone git@github.com:giulianoquites/named-labquites.git

cd named-labquites

cp labquites.local.db  /var/named/

cp named.conf  /var/named/

chown named:named /var/named/labquites.local.db

named-checkzone /var/named/labquites.local.db

# Enable and Start named
systemctl enable named

systemctl start named

# Test DNS
nslookup google.com.br  127.0.0.1

dig www.google.com.br @127.0.0.1

