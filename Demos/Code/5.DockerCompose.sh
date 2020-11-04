############################################################################
############################################################################
#
# Docker Deep Dive - Andrew Pruski
# https://github.com/dbafromthecold/DockerDeepDive
# Docker Compose
#
############################################################################
############################################################################



# navigate to the compose files
cd ~/git/DockerDeepDive/Demos/Compose



# have a look at the dockerfile
cat dockerfile



# have a look at the environment variable file
cat sqlserver.env



# have a look at the docker-compose file
cat docker-compose.yaml



# check the docker networks on the host
docker network ls



# check the named volumes on the host
docker volume ls



# check the images on the host
docker image ls



# spin up a container with docker compose
docker-compose up -d



# recheck the docker networks on the host
docker network ls



# recheck the named volumes
docker volume ls



# check the images
docker image ls



# check the containers running
docker container ls -a



# connect to the SQL instance and create a database
mssql-cli -S localhost,15789 -U sa -P Testing1122 -Q "CREATE DATABASE [testdatabase];"


# check the database files
docker exec compose_sqlserver1_1 bash -c "ls -al /var/opt/sqlserver"



# check the database has been created
mssql-cli -S localhost,15789 -U sa -P Testing1122 -Q "SELECT [name] FROM sys.databases;"



# spin down the container
docker-compose down



# check the networks again
docker network ls



# check the containers
docker container ls -a



# check the volumes
docker volume ls



# check the images
docker image ls



# clean up
docker volume prune -f
docker image rm compose_sqlserver1