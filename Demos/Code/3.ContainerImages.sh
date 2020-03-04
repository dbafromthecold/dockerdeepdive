


# list images
docker image ls



# search the dockerhub
docker search dbafromthecold



# get tags
GET https://registry.hub.docker.com/v2/repositories/dbafromthecold/dockerdeepdive/



# inspect dockerfile
cd ~/git/DockerDeepDive/Demos/CustomImage && cat dockerfile



# inspect custom image
docker image history IMAGENAME



# inspect microsoft image
docker image history mcr.microsoft.com/mssql/server:2019-CU2-ubuntu-16.04



# make it readable
docker image history mcr.microsoft.com/mssql/server:2019-CU2-ubuntu-16.04 \
--human --no-trunc