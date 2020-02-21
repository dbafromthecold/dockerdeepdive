# https://dbafromthecold.com/2017/06/28/persisting-data-in-docker-containers-part-two/
## Named Volumes



# remove unused volumes
docker volume prune -f



# create the named volume
docker volume create sqlserver



# verify named volume is there
docker volume ls



# spin up a container with named volume mapped
docker container run -d -p 15999:1433 \
--volume sqlserver:/var/opt/sqlserver \
--env ACCEPT_EULA=Y \
--env SA_PASSWORD=Testing1122 \
--name testcontainer9 \
mcr.microsoft.com/mssql/server:2019-GDR1-ubuntu-16.04



# check the container is running
docker container ls -a



########################################################################
#
# Create database in Azure Data Studio
#
########################################################################



# blow away container
docker container kill testcontainer9
docker container rm testcontainer9



# check that named volume is still there
docker volume ls



# spin up another container
docker container run -d -p 16100:1433 \
--volume sqlserver:/var/opt/sqlserver \
--env ACCEPT_EULA=Y \
--env SA_PASSWORD=Testing1122 \
--name testcontainer10 \
mcr.microsoft.com/mssql/server:2019-GDR1-ubuntu-16.04



# verify container is running
docker container ls -a



# exec into container
docker container exec -it testcontainer10 bash



# confirm files are there
ls /var/opt/sqlserver



# exit container
exit



########################################################################
#
# Re-create database in Azure Data Studio
#
########################################################################



# clean up
docker container kill testcontainer10
docker container rm testcontainer10
docker volume rm sqlserver
docker volume prune -f



########################################################################
########################################################################



# all a bit manual though...
# let's create a couple of named volumes
docker volume create mssqlsystem
docker volume create mssqluser



# confirm volumes are there
docker volume ls



# spin up a container with the volumes mapped
docker container run -d -p 16110:1433 \
--volume mssqlsystem:/var/opt/mssql \
--volume mssqluser:/var/opt/sqlserver \
--env ACCEPT_EULA=Y \
--env SA_PASSWORD=Testing1122 \
--name testcontainer11 \
mcr.microsoft.com/mssql/server:2019-GDR1-ubuntu-16.04



# check the container is running
docker container ls -a



########################################################################
#
# Create database in Azure Data Studio
#
########################################################################



# blow away container
docker kill testcontainer11
docker rm testcontainer11



# confirm that container is gone
docker container ls -a



# confirm volumes are still there
docker volume ls



# spin up another container
docker container run -d -p 16120:1433 \
--volume mssqlsystem:/var/opt/mssql \
--volume mssqluser:/var/opt/sqlserver \
--env ACCEPT_EULA=Y \
--env SA_PASSWORD=Testing1122 \
--name testcontainer12 \
mcr.microsoft.com/mssql/server:2019-GDR1-ubuntu-16.04



########################################################################
#
# Confirm database is there in Azure Data Studio
#
########################################################################



# clean up
docker container kill testcontainer12
docker container rm testcontainer12
docker volume rm mssqlsystem
docker volume rm mssqluser
