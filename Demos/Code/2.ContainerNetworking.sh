


# list networks
docker network list



# inspect the default bridge network
docker network inspect bridge



# let's run two sql containers on the default bridge network
docker container run -d \
--env ACCEPT_EULA=Y \
--env MSSQL_SA_PASSWORD=Testing1122 \
--name testcontainer1 \
mcr.microsoft.com/mssql/rhel/server:2019-CU1-rhel-8

docker container run -d \
--env ACCEPT_EULA=Y \
--env MSSQL_SA_PASSWORD=Testing1122 \
--name testcontainer2 \
mcr.microsoft.com/mssql/rhel/server:2019-CU1-rhel-8



# confirm containers are running
docker container ls -a --format "table {{.Names }}\t{{ .Image }}\t{{ .Status }}\t{{.Ports}}"



# inspect the default bridge network
docker network inspect bridge



# grab the IP addresses of the containers
docker inspect testcontainer1 --format '{{ .NetworkSettings.IPAddress }}' 
docker inspect testcontainer2 --format '{{ .NetworkSettings.IPAddress }}' 



# run a container on the same network with tools installed
docker run -it dbafromthecold/dockerdeepdive:networking-tools bash



# ping one of the container
ping 172.17.0.2



# view container dns
cat /etc/resolv.conf



# connect to sql in another container
mssql-cli -S 172.17.0.2 -U sa -P Testing1122 -Q "SELECT @@VERSION AS [Version];"



# exit tools container
exit



# try and connect to SQL within one of the containers from the host
mssql-cli -S 172.17.0.2 -U sa -P Testing1122 -Q "SELECT @@VERSION AS [Version];"



# let's run two more containers on the default bridge network with ports mapped
docker container run -d \
--publish 15789:1433 \
--env ACCEPT_EULA=Y \
--env MSSQL_SA_PASSWORD=Testing1122 \
--name testcontainer3 \
mcr.microsoft.com/mssql/rhel/server:2019-CU1-rhel-8

docker container run -d \
--publish 15799:1433 \
--env ACCEPT_EULA=Y \
--env MSSQL_SA_PASSWORD=Testing1122 \
--name testcontainer4 \
mcr.microsoft.com/mssql/rhel/server:2019-CU1-rhel-8



# view port mapping
docker port testcontainer3



# now connect to SQL in a container from the host
mssql-cli -S localhost,15789 -U sa -P Testing1122 -Q "SELECT @@VERSION AS [Version];"



# create custom bridge network
docker network create sqlserver



# create two new containers on the custom network
docker container run -d \
--network=sqlserver
--publish 15689:1433 \
--env ACCEPT_EULA=Y \
--env MSSQL_SA_PASSWORD=Testing1122 \
--name testcontainer5 \
mcr.microsoft.com/mssql/rhel/server:2019-CU1-rhel-8

docker container run -d \
--network=sqlserver
--publish 15699:1433 \
--env ACCEPT_EULA=Y \
--env MSSQL_SA_PASSWORD=Testing1122 \
--name testcontainer6 \
mcr.microsoft.com/mssql/rhel/server:2019-CU1-rhel-8



# confirm containers are running
docker container ls -a --format "table {{.Names }}\t{{ .Image }}\t{{ .Status }}\t{{.Ports}}"



# spin up tools container on same network
docker run -it dbafromthecold/dockerdeepdive:networking-tools bash



# ping containers by name
ping testcontainer5



# view dns settings
cat /etc/resolv.conf



# pull out information from dns server
dig testcontainer5 @127.0.0.11



# exit container
exit



# clean up
docker rm $(docker ps -aq) -f