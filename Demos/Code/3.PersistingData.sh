############################################################################
############################################################################
#
# Docker Deep Dive - Andrew Pruski
# @dbafromthecold
# dbafromthecold@gmail.com
# https://github.com/dbafromthecold/DockerDeepDive
# Persisting Data
#
############################################################################
############################################################################



# let's create a couple new named volumes
docker volume create mssqlsystem && docker volume create mssqluser



# confirm volumes are there
docker volume ls



# spin up a container with the volumes mapped
docker container run -d -p 16110:1433 \
--volume mssqlsystem:/var/opt/mssql \
--volume mssqluser:/var/opt/sqlserver \
--env ACCEPT_EULA=Y \
--env MSSQL_SA_PASSWORD=Testing1122 \
--env MSSQL_DATA_DIR=/var/opt/sqlserver \
--env MSSQL_LOG_DIR=/var/opt/sqlserver \
--name sqlcontainer3 \
mcr.microsoft.com/mssql/server:2019-CU5-ubuntu-18.04



# check the container is running
docker container ls -a --format "table {{.Names }}\t{{ .Image }}\t{{ .Status }}\t{{.Ports}}"



# change owner to mssql
docker exec -u 0 sqlcontainer3 chown -R mssql /var/opt/sqlserver



# create database
mssql-cli -S localhost,16110 -U sa -P Testing1122 -Q "CREATE DATABASE [testdatabase2];"



# confirm database is there
mssql-cli -S localhost,16110 -U sa -P Testing1122 -Q "SELECT [name] FROM sys.databases;"



# check the database file location
mssql-cli -S localhost,16110 -U sa -P Testing1122 -Q "USE [testdatabase2]; EXEC sp_helpfile;"



# View database files
docker exec -u 0 sqlcontainer3 bash -c "ls -al /var/opt/sqlserver"



# blow away container
docker container rm $(docker container ls -aq) -f



# confirm that container is gone
docker container ls -a --format "table {{.Names }}\t{{ .Image }}\t{{ .Status }}\t{{.Ports}}"



# confirm volumes are still there
docker volume ls



# spin up another container
docker container run -d -p 16120:1433 \
--volume mssqlsystem:/var/opt/mssql \
--volume mssqluser:/var/opt/sqlserver \
--env ACCEPT_EULA=Y \
--env SA_PASSWORD=Testing1122 \
--env MSSQL_DATA_DIR=/var/opt/sqlserver \
--env MSSQL_LOG_DIR=/var/opt/sqlserver \
--name sqlcontainer4 \
mcr.microsoft.com/mssql/server:2019-CU5-ubuntu-18.04



# confirm that container is running
docker container ls -a --format "table {{.Names }}\t{{ .Image }}\t{{ .Status }}\t{{.Ports}}"



# confirm database is there
mssql-cli -S localhost,16120 -U sa -P Testing1122 -Q "SELECT [name] FROM sys.databases;"



# clean up
docker container rm $(docker container ls -aq) -f
docker volume rm $(docker volume ls -q) -f