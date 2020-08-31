


cd ~/git/DockerDeepDive/Demos/Compose



cat dockerfile



cat sqlserver.env



cat docker-compose.yaml



docker network ls



docker volume ls



docker image ls



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


