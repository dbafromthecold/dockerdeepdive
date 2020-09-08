############################################################################
############################################################################
#
# Docker Deep Dive - Andrew Pruski
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
--name testcontainer1 \
dbafromthecold/dockerdeepdive:customsql2019-tools

docker container run -d \
--env ACCEPT_EULA=Y \
--env MSSQL_SA_PASSWORD=Testing1122 \
--name testcontainer2 \
dbafromthecold/dockerdeepdive:customsql2019-tools



# confirm containers are running
docker container ls -a --format "table {{.Names }}\t{{ .Image }}\t{{ .Status }}\t{{.Ports}}"



# inspect the default bridge network
docker network inspect bridge



# grab the IP addresses of the containers
IPADDR1=$(docker inspect testcontainer1 --format '{{ .NetworkSettings.IPAddress }}') && echo $IPADDR1
IPADDR2=$(docker inspect testcontainer2 --format '{{ .NetworkSettings.IPAddress }}') && echo $IPADDR2 



# ping one of the containers using the container name
docker exec testcontainer1 ping testcontainer2 -c 4



# ping one of the containers using the ip address
docker exec testcontainer1 ping $IPADDR2 -c 4



# now connect to SQL in a container from the host
mssql-cli -S $IPADDR1 -U sa -P Testing1122 -Q "SELECT @@VERSION AS [Version];"



# let's blow the containers away
docker rm $(docker ps -aq) -f



# and spin them up again, this time adding entries for each in the hosts file
docker container run -d \
--env ACCEPT_EULA=Y \
--env MSSQL_SA_PASSWORD=Testing1122 \
--add-host=testcontainer2:172.17.0.3 \
--name testcontainer1 \
dbafromthecold/dockerdeepdive:customsql2019-tools

docker container run -d \
--env ACCEPT_EULA=Y \
--env MSSQL_SA_PASSWORD=Testing1122 \
--add-host=testcontainer1:172.17.0.2 \
--name testcontainer2 \
dbafromthecold/dockerdeepdive:customsql2019-tools



# ping one of the containers using the container name
docker exec testcontainer1 ping testcontainer2 -c 4



# let's run two more containers on the default bridge network with ports mapped
docker container run -d \
--publish 15789:1433 \
--env ACCEPT_EULA=Y \
--env MSSQL_SA_PASSWORD=Testing1122 \
--name testcontainer3 \
dbafromthecold/dockerdeepdive:customsql2019-tools

docker container run -d \
--publish 15799:1433 \
--env ACCEPT_EULA=Y \
--env MSSQL_SA_PASSWORD=Testing1122 \
--name testcontainer4 \
dbafromthecold/dockerdeepdive:customsql2019-tools



# view port mapping
docker port testcontainer3
docker port testcontainer4


# now connect to SQL in a container from the host
mssql-cli -S localhost,15789 -U sa -P Testing1122 -Q "SELECT @@VERSION AS [Version];"



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
--name testcontainer5 \
dbafromthecold/dockerdeepdive:customsql2019-tools

docker container run -d \
--network=sqlserver \
--publish 15699:1433 \
--env ACCEPT_EULA=Y \
--env MSSQL_SA_PASSWORD=Testing1122 \
--name testcontainer6 \
dbafromthecold/dockerdeepdive:customsql2019-tools



# ping containers by name
docker exec testcontainer5 ping testcontainer6 -c 4



# view dns settings
docker exec testcontainer5 cat /etc/resolv.conf



# clean up
docker rm $(docker ps -aq) -f