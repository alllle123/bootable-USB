CREATE USER <user>@localhost IDENTIFIED BY "<password>";
create database <website>;
GRANT ALL ON <website>.* TO <user>@localhost;
FLUSH PRIVILEGES;
