# to be completed

sudo apt-get update
sudo apt-get install iputils-ping



docker run -d -p 15799:1433 \
--env ACCEPT_EULA=Y \
--env SA_PASSWORD=Testing1122 \
--name testcontainer1 \
mcr.microsoft.com/mssql/server:2019-RC1-ubuntu

docker run -d -P \
--env ACCEPT_EULA=Y \
--env SA_PASSWORD=Testing1122 \
--name testcontainer2 \
mcr.microsoft.com/mssql/server:2019-RC1-ubuntu

docker inspect testcontainer1 --format '{{ .NetworkSettings.IPAddress }}' 
docker inspect testcontainer2 --format '{{ .NetworkSettings.IPAddress }}' 

docker exec testcontainer1 /bin/sh ifconfig

docker inspect testcontainer2


docker inspect testcontainer --format='{{range $p, $conf := .NetworkSettings.Ports}} {{$p}} -> {{(index $conf 0).HostPort}} {{end}}'



docker network ls

docker network create sqlserver

docker run -d -p 15789:1433 \
--network sqlserver \
--env ACCEPT_EULA=Y \
--env SA_PASSWORD=Testing1122 \
--name testcontainer3 \
mcr.microsoft.com/mssql/server:2019-RC1-ubuntu



docker run -d -P \
--network sqlserver \
--env ACCEPT_EULA=Y \
--env SA_PASSWORD=Testing1122 \
--name testcontainer4 \
mcr.microsoft.com/mssql/server:2019-RC1-ubuntu

docker exec -it testcontainer3 bash

apt-get update
apt-get install iputils-ping

ping testcontainer4