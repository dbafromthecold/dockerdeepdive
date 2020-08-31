


ssh Linux1



# run a container
docker container run -d \
--publish 15789:1433 \
--env ACCEPT_EULA=Y \
--env MSSQL_SA_PASSWORD=Testing1122 \
--name testcontainer1 \
mcr.microsoft.com/mssql/server:2019-CU5-ubuntu-18.04



# grab container ID
CONTAINERID=$(docker ps -q) && echo $CONTAINERID



# view control groups created
find /sys/fs/cgroup/ -name *$CONTAINERID*



# get process IDs - TASKS
DIR=$(find /sys/fs/cgroup/ -name *$CONTAINERID* | head -1) && cat $DIR/tasks



# view namespaces associated with process
PROCESSID=$(tail -n 1 $DIR/tasks) && sudo ls -Lil /proc/$PROCESSID/ns





# https://docs.docker.com/storage/storagedriver/overlayfs-driver/

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