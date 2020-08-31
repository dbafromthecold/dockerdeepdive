


# run a container - limiting the memory available to it
docker container run -d \
--publish 15789:1433 \
--memory 2048M \
--env ACCEPT_EULA=Y \
--env MSSQL_SA_PASSWORD=Testing1122 \
--name testcontainer1 \
mcr.microsoft.com/mssql/server:2019-CU5-ubuntu-18.04



# grab container ID
CONTAINERID=$(docker ps -q) && echo $CONTAINERID



# jump into the container
docker exec -it testcontainer1 bash


# get user details
id



# list processes
ps aux



# exit container
exit



# view mssql processes on host
ps aux | grep mssql



# let's run another container from a custom image
docker container run -d \
--publish 15799:1433 \
--env ACCEPT_EULA=Y \
--env MSSQL_SA_PASSWORD=Testing1122 \
--name testcontainer2 \
testimage



# have a look at the dockerfile (copied from the CustomImage directory in the github repo)
cat ~/git/DockerDeepDive/Demos/CustomImage/dockerfile



# view mssql processes on host again
ps aux | grep mssql



# view control groups created
find /sys/fs/cgroup/ -name *$CONTAINERID*



# get memory control group
MEMORYCGROUP=$(find /sys/fs/cgroup/ -name *$CONTAINERID* | grep memory) && echo $MEMORYCGROUP



# get memory limit
MEMORYLIMIT=$(cat $MEMORYCGROUP/memory.limit_in_bytes)



# show memory limit of container
expr $MEMORYLIMIT / 1024 / 1024



# create a database in the SQL instance in the container
mssql-cli -S localhost,15789 -U sa -P Testing1122 -Q "CREATE DATABASE [testdatabase]"



# inspect the container
docker inspect testcontainer1



# get container file location
LOWER=$(docker inspect testcontainer1 --format '{{ .GraphDriver.Data.LowerDir }}') && echo $LOWER
DIFF=$(docker inspect testcontainer1 --format '{{ .GraphDriver.Data.UpperDir }}') && echo $DIFF
MERGED=$(docker inspect testcontainer1 --format '{{ .GraphDriver.Data.MergedDir }}') && echo $MERGED



# view files on host
sudo ls $DIFF
sudo ls $MERGED

sudo ls $DIFF/var/opt/mssql/data
sudo ls $MERGED/var/opt/mssql/data



# clean up
docker rm $(docker ps -aq) -f