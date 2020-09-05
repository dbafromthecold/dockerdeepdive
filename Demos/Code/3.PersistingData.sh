############################################################################
############################################################################
#
# Docker Deep Dive - Andrew Pruski
# https://github.com/dbafromthecold/DockerDeepDive
# Persisting Data
#
############################################################################
############################################################################



# remove unused volumes
docker volume prune -f



# create the named volume
docker volume create sqlserver



# verify named volume is there
docker volume ls



# spin up a container with named volume mapped
docker container run -d \
--publish 15999:1433 \
--volume sqlserver:/var/opt/sqlserver \
--env ACCEPT_EULA=Y \
--env SA_PASSWORD=Testing1122 \
--name testcontainer1 \
mcr.microsoft.com/mssql/server:2019-CU5-ubuntu-18.04



# check the container is running
docker container ls -a --format "table {{.Names }}\t{{ .Image }}\t{{ .Status }}\t{{.Ports}}"



# create database
mssql-cli -S localhost,15999 -U sa -P Testing1122 \
-Q "CREATE DATABASE [testdatabase] 
    ON PRIMARY 
    (NAME='testdatabase',FILENAME='/var/opt/sqlserver/testdatabase.mdf') 
    LOG ON 
    (NAME='testdatabase_log',FILENAME='/var/opt/sqlserver/testdatabase_log.ldf');"


# view the directory in the container
docker exec -u 0 testcontainer1 ls -al /var/opt/



# change owner to mssql
docker exec -u 0 testcontainer1 chown mssql /var/opt/sqlserver



# try creating the database again
mssql-cli -S localhost,15999 -U sa -P Testing1122 \
-Q "CREATE DATABASE [testdatabase] 
    ON PRIMARY 
    (NAME='testdatabase',FILENAME='/var/opt/sqlserver/testdatabase.mdf') 
    LOG ON 
    (NAME='testdatabase_log',FILENAME='/var/opt/sqlserver/testdatabase_log.ldf');"



# confirm database is there
mssql-cli -S localhost,15999 -U sa -P Testing1122 -Q "SELECT [name] FROM sys.databases;"



# blow away container
docker container rm $(docker ps -aq) -f



# confirm container is gone
docker container ls -a --format "table {{.Names }}\t{{ .Image }}\t{{ .Status }}\t{{.Ports}}"



# check that named volume is still there
docker volume ls



# spin up another container
docker container run -d -p 16100:1433 \
--volume sqlserver:/var/opt/sqlserver \
--env ACCEPT_EULA=Y \
--env SA_PASSWORD=Testing1122 \
--name testcontainer2 \
mcr.microsoft.com/mssql/server:2019-CU5-ubuntu-18.04



# check the container is running
docker container ls -a --format "table {{.Names }}\t{{ .Image }}\t{{ .Status }}\t{{.Ports}}"



# change owner to mssql - NOT NEEDED!
# docker exec -u 0 testcontainer2 chown -R mssql /var/opt/sqlserver



# check database files are there
docker container exec -it testcontainer2 ls -al /var/opt/sqlserver



# re-create database
mssql-cli -S localhost,16100 -U sa -P Testing1122 \
-Q "CREATE DATABASE [testdatabase]
    ON PRIMARY
    (NAME='testdatabase',FILENAME='/var/opt/sqlserver/testdatabase.mdf')
    LOG ON
    (NAME='testdatabase_log',FILENAME='/var/opt/sqlserver/testdatabase_log.ldf')
    FOR ATTACH;"



# confirm database is there
mssql-cli -S localhost,16100 -U sa -P Testing1122 -Q "SELECT [name] FROM sys.databases;"



# clean up
docker container rm $(docker container ls -aq) -f && docker volume prune -f



# all a bit manual though...
# let's create a couple new named volumes
docker volume create mssqlsystem && docker volume create mssqluser



# confirm volumes are there
docker volume ls



# spin up a container with the volumes mapped
docker container run -d -p 16110:1433 \
--volume mssqlsystem:/var/opt/mssql \
--volume mssqluser:/var/opt/sqlserver \
--env ACCEPT_EULA=Y \
--env SA_PASSWORD=Testing1122 \
--env MSSQL_DATA_DIR=/var/opt/sqlserver \
--env MSSQL_LOG_DIR=/var/opt/sqlserver \
--name testcontainer3 \
mcr.microsoft.com/mssql/server:2019-CU5-ubuntu-18.04



# check the container is running
docker container ls -a --format "table {{.Names }}\t{{ .Image }}\t{{ .Status }}\t{{.Ports}}"



# change owner to mssql
docker exec -u 0 testcontainer3 chown -R mssql /var/opt/sqlserver



# create database
mssql-cli -S localhost,16110 -U sa -P Testing1122 -Q "CREATE DATABASE [testdatabase2];"



# confirm database is there
mssql-cli -S localhost,16110 -U sa -P Testing1122 -Q "SELECT [name] FROM sys.databases;"



# check the database file location
mssql-cli -S localhost,16110 -U sa -P Testing1122 -Q "USE [testdatabase2]; EXEC sp_helpfile;"



# View database files
docker exec -u 0 testcontainer3 bash -c "ls -al /var/opt/sqlserver"



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
--name testcontainer4 \
mcr.microsoft.com/mssql/server:2019-CU5-ubuntu-18.04



# confirm database is there
mssql-cli -S localhost,16120 -U sa -P Testing1122 -Q "SELECT [name] FROM sys.databases;"



# clean up
docker container rm $(docker container ls -aq) -f && docker volume prune -f



# spin up a data volume container
docker container create --name datastore \
--volume /var/opt/sqlserver/data \
--volume /var/opt/sqlserver/log \
--volume /var/opt/sqlserver/backups \
ubuntu:18.04



# verify container
docker container ls -a --format "table {{.Names }}\t{{ .Image }}\t{{ .Status }}\t{{.Ports}}"



# view named volumes
docker volume ls



# spin up a sql container with volume mapped from data container
docker container run -d \
--publish 15789:1433 \
--volumes-from datastore \
--env ACCEPT_EULA=Y \
--env SA_PASSWORD=Testing1122 \
--env MSSQL_DATA_DIR=/var/opt/sqlserver/data \
--env MSSQL_LOG_DIR=/var/opt/sqlserver/log \
--env MSSQL_BACKUP_DIR=/var/opt/sqlserver/backup \
--name testcontainer5 \
mcr.microsoft.com/mssql/server:2019-CU5-ubuntu-18.04



# confirm container is running
docker container ls -a --format "table {{.Names }}\t{{ .Image }}\t{{ .Status }}\t{{.Ports}}"



# change the owner of the sqlserver directory
docker exec -u 0 testcontainer5 chown -R mssql /var/opt/sqlserver



# create a database
mssql-cli -S localhost,15789 -U sa -P Testing1122 -Q "CREATE DATABASE [testdatabase3];"



# view the database files
mssql-cli -S localhost,15789 -U sa -P Testing1122 -Q "USE [testdatabase3]; EXEC sp_helpfile;"



# clean up
docker container rm $(docker container ls -aq) -f && docker volume prune -f