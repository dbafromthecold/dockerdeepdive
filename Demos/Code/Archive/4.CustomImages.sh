############################################################################
############################################################################
#
# Docker Deep Dive - Andrew Pruski
# @dbafromthecold
# dbafromthecold@gmail.com
# https://github.com/dbafromthecold/DockerDeepDive
# Custom Images
#
############################################################################
############################################################################



# navigate to dockerfile location
cd ~/git/dockerdeepdive/Demos/CustomImages/Image1



# view the dockerfile
cat dockerfile



# build the image
docker build -t customimage1 .



# confirm image
docker image ls | grep customimage1



# create named volumes
docker volume create sqlsystem
docker volume create sqldata 
docker volume create sqllog 
docker volume create sqlbackups



# confirm volumes
docker volume ls



# run a container from custom image
docker container run -d \
--publish 15789:1433 \
--volume sqlsystem:/var/opt/mssql \
--volume sqldata:/var/opt/sqlserver/sqldata \
--volume sqllog:/var/opt/sqlserver/sqllog \
--volume sqlbackups:/var/opt/sqlserver/sqlbackups \
--env ACCEPT_EULA=Y \
--env MSSQL_DATA_DIR=/var/opt/sqlserver/sqldata \
--env MSSQL_LOG_DIR=/var/opt/sqlserver/sqllog \
--env MSSQL_BACKUP_DIR=/var/opt/sqlserver/sqlbackups \
--env MSSQL_SA_PASSWORD=Testing1122 \
--name sqlcontainer1 \
customimage1



# check the container is running
docker container ls -a --format "table {{.Names }}\t{{ .Image }}\t{{ .Status }}\t{{.Ports}}"



# check permissions on folders
docker container exec sqlcontainer1 ls -al /var/opt/sqlserver



# create a database
mssql-cli -S localhost,15789 -U sa -P Testing1122 -Q "CREATE DATABASE [testdatabase];"



# confirm database is there
mssql-cli -S localhost,15789 -U sa -P Testing1122 -Q "SELECT [name] FROM sys.databases;"



# confirm location of database files
mssql-cli -S localhost,15789 -U sa -P Testing1122 -Q "USE [testdatabase]; EXEC sp_helpfile;"



# delete container
docker rm sqlcontainer1 -f



# check the container is gone
docker container ls -a --format "table {{.Names }}\t{{ .Image }}\t{{ .Status }}\t{{.Ports}}"



# spin up another container
docker container run -d \
--publish 15799:1433 \
--volume sqlsystem:/var/opt/mssql \
--volume sqldata:/var/opt/sqlserver/sqldata \
--volume sqllog:/var/opt/sqlserver/sqllog \
--volume sqlbackups:/var/opt/sqlserver/sqlbackups \
--env ACCEPT_EULA=Y \
--env MSSQL_DATA_DIR=/var/opt/sqlserver/sqldata \
--env MSSQL_LOG_DIR=/var/opt/sqlserver/sqllog \
--env MSSQL_BACKUP_DIR=/var/opt/sqlserver/sqlbackups \
--env SA_PASSWORD=Testing1122 \
--name sqlcontainer2 \
customimage1



# check the container is running
docker container ls -a --format "table {{.Names }}\t{{ .Image }}\t{{ .Status }}\t{{.Ports}}"



# confirm database is there
mssql-cli -S localhost,15799 -U sa -P Testing1122 -Q "SELECT [name] FROM sys.databases;"



# clean up
docker rm $(docker container ls -aq) -f
docker volume prune -f
docker image rm customimage1



# ok, let's build a SQL image from scratch!
# let's build another image
cd ~/git/dockerdeepdive/Demos/CustomImages/Image2



# list files in directory
ls -al



# have a look at the dockerfile
cat dockerfile



# have a look at the attach-db.sh script
cat attach-db.sh



# build the image
docker build -t customimage2 .



# list images
docker image ls



# inspect the image
docker image inspect customimage2




# view the history of the image
docker history customimage2 --format {{.CreatedBy}} --no-trunc



# run container from custom image
docker container run -d \
--publish 15802:1433 \
--env MSSQL_SA_PASSWORD=Testing1122 \
--name sqlcontainer5 \
customimage2



# check the container is running
docker container ls -a --format "table {{.Names }}\t{{ .Image }}\t{{ .Status }}\t{{.Ports}}"



# confirm database is there
mssql-cli -S localhost,15802 -U sa -P Testing1122 -Q "SELECT [name] FROM sys.databases;"



# clean up
docker rm $(docker container ls -aq) -f
#docker image rm customimage2
