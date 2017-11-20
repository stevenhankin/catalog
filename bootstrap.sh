#
# Steve Hankin 20th Nov 2017
#

# Configure Firewall
sudo ufw disable
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 2200/tcp
sudo ufw allow www
sudo ufw allow ntp
sudo ufw allow 443/tcp
sudo ufw enable

# Install packages
sudo apt-get install python-pip -y
sudo apt-get install libcurl4-openssl-dev -y
sudo apt-get install python-dev -y
sudo apt-get install postgresql -y
sudo apt-get install postgresql-server-dev-all -y
sudo apt-get install gunicorn -y
sudo pip install -r /vagrant/requirements.txt

# Create the unix account for the same name as the database schema
sudo useradd catalog -m -s /bin/bash 

# Create database called itemcatalogdb
sudo -u postgres createdb itemcatalogdb
sudo -u postgres createuser catalog

# Set the catalog user to have catalog2017 password by default
sudo -u catalog -i <<EOF
psql itemcatalogdb catalog -c "ALTER USER catalog WITH ENCRYPTED PASSWORD 'catalog2017';"
EOF

sudo bash -c 'echo "local   itemcatalogdb   catalog                                 trust" >> /etc/postgresql/*/main/pg_hba.conf'
sudo service postgresql restart

