


# run a container
docker container run -d \
--publish 15789:1433 \
--env ACCEPT_EULA=Y \
--env MSSQL_SA_PASSWORD=Testing1122 \
--name testcontainer1 \
mcr.microsoft.com/mssql/rhel/server:2019-CU1-rhel-8



# grab container ID
CONTAINERID=$(docker ps -q) && echo $CONTAINERID



# view control groups created
find /sys/fs/cgroup/ -name *$CONTAINERID*



# get process IDs - TASKS
DIR=$(find /sys/fs/cgroup/ -name *$CONTAINERID* | head -1) && cat $DIR/tasks



# view namespaces associated with process
PROCESSID=$(tail -n 1 $DIR/tasks) && sudo ls -Lil /proc/179/ns



# create a database in the SQL instance in the container
mssql-cli -S localhost,15789 -U sa -P Testing1122 -Q "CREATE DATABASE [testdatabase]"



# view files on host
DIR=$(docker inspect testcontainer1 --format '{{ .GraphDriver.Data.UpperDir }}')

# actual WSL files are here: - /mnt/wsl/docker-desktop-data/data/docker/overlay2

sudo ls $DIR/var/opt/mssql/data