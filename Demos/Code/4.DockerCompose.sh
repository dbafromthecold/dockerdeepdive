


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



docker network ls



docker volume ls



docker image ls



docker container ls -a



mssql-cli -S localhost,15789 -U sa -P Testing1122 -Q "CREATE DATABASE [testdatabase];"



mssql-cli -S localhost,15789 -U sa -P Testing1122 -Q "SELECT [name] FROM sys.databases;"



docker-compose down



docker network ls



docker container ls -a



docker volume ls



docker-compose up -d




docker run -it \
--network compose_default \
--name testcontainer2 \
dbafromthecold/dockerdeepdive:networking-tools \
bash



ping compose_sqlserver1_1


