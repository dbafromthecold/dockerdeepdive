


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



# change owner to mssql
docker exec -u 0 testcontainer1 bash -c "chown mssql /var/opt/sqlserver"



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
# docker exec -u 0 testcontainer2 bash -c "chown -R mssql /var/opt/sqlserver"



# check database files are there
docker container exec -it testcontainer2 bash -c "ls /var/opt/sqlserver"



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
docker exec -u 0 testcontainer3 bash -c "chown -R mssql /var/opt/sqlserver"



# create database
mssql-cli -S localhost,16110 -U sa -P Testing1122 -Q "CREATE DATABASE [testdatabase2];"



# confirm database is there
mssql-cli -S localhost,16110 -U sa -P Testing1122 -Q "SELECT [name] FROM sys.databases;"



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
