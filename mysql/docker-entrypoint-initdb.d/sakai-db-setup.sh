mysql -uroot -ppassword -h localhost -e "create database sakai default character set utf8;"
mysql -uroot -ppassword -h localhost -e "create user 'sakai'@'%' identified by 'ironchef';"
mysql -uroot -ppassword -h localhost -e "grant all privileges on sakai.* to 'sakai'@'%';"
mysql -uroot -ppassword -h localhost -e "FLUSH PRIVILEGES;"
