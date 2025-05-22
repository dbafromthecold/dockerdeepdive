############################################################################
############################################################################
#
# Docker Deep Dive - Andrew Pruski
# @dbafromthecold
# dbafromthecold@gmail.com
# https://github.com/dbafromthecold/DockerDeepDive
# Container Networking
#
############################################################################
############################################################################



# list networks
docker network ls



# inspect the default bridge network
docker network inspect bridge



# let's run two sql containers on the default bridge network
docker container run -d \
--env ACCEPT_EULA=Y \
--env MSSQL_SA_PASSWORD=Testing1122 \
--name sqlcontainer1 \
ghcr.io/dbafromthecold/dockerdeepdive:customsql2019-tools

docker container run -d \
--env ACCEPT_EULA=Y \
--env MSSQL_SA_PASSWORD=Testing1122 \
--name sqlcontainer2 \
ghcr.io/dbafromthecold/dockerdeepdive:customsql2019-tools



# confirm containers are running
docker container ls -a --format "table {{.Names }}\t{{ .Image }}\t{{ .Status }}\t{{.Ports}}"



# inspect the default bridge network
docker network inspect bridge



# grab the IP addresses of the containers
IPADDR1=$(docker inspect sqlcontainer1 --format '{{ .NetworkSettings.IPAddress }}') && echo $IPADDR1
IPADDR2=$(docker inspect sqlcontainer2 --format '{{ .NetworkSettings.IPAddress }}') && echo $IPADDR2 



# ping one of the containers using the container name
docker exec sqlcontainer1 ping sqlcontainer2 -c 4



# ping one of the containers using the ip address
docker exec sqlcontainer1 ping $IPADDR2 -c 4



# let's blow the containers away
docker rm $(docker ps -aq) -f



# and spin them up again, this time adding entries for each in the hosts file
docker container run -d \
--env ACCEPT_EULA=Y \
--env MSSQL_SA_PASSWORD=Testing1122 \
--add-host=sqlcontainer2:172.17.0.3 \
--name sqlcontainer1 \
ghcr.io/dbafromthecold/dockerdeepdive:customsql2019-tools

docker container run -d \
--env ACCEPT_EULA=Y \
--env MSSQL_SA_PASSWORD=Testing1122 \
--add-host=sqlcontainer1:172.17.0.2 \
--name sqlcontainer2 \
ghcr.io/dbafromthecold/dockerdeepdive:customsql2019-tools



# ping one of the containers using the container name
docker exec sqlcontainer1 ping sqlcontainer2 -c 4



# and let's blow those containers away
docker rm $(docker ps -aq) -f



# create custom bridge network
docker network create sqlserver



# list networks
docker network ls



# create two new containers on the custom network
docker container run -d \
--network=sqlserver \
--publish 15689:1433 \
--env ACCEPT_EULA=Y \
--env MSSQL_SA_PASSWORD=Testing1122 \
--name sqlcontainer5 \
ghcr.io/dbafromthecold/dockerdeepdive:customsql2019-tools

docker container run -d \
--network=sqlserver \
--publish 15699:1433 \
--env ACCEPT_EULA=Y \
--env MSSQL_SA_PASSWORD=Testing1122 \
--name sqlcontainer6 \
ghcr.io/dbafromthecold/dockerdeepdive:customsql2019-tools



# ping containers by name
docker exec sqlcontainer5 ping sqlcontainer6 -c 4



# view dns settings
docker exec sqlcontainer5 cat /etc/resolv.conf



# clean up
docker rm $(docker ps -aq) -f
docker network rm sqlserver