


# run a container
docker container run -it \
--publish 15789:1433 \
--env ACCEPT_EULA=Y \
--env MSSQL_SA_PASSWORD=Testing1122 \
--name testcontainer1 \
mcr.microsoft.com/mssql/rhel/server:2019-CU1-rhel-8 \
/bin/bash



# grab container ID
CONTAINERID=$(docker ps -q) && echo $CONTAINERID



# view control groups created
find /sys/fs/cgroup/ -name *$CONTAINERID*



# get process ID
DIR=$(find /sys/fs/cgroup/ -name *$CONTAINERID* | head -1) && cat $DIR/tasks



# view namespaces associated with process
PROCESSID=$(cat $DIR/tasks) && sudo ls -Lil /proc/$PROCESSID/ns






# get process ID
ps -axf | grep $CONTAINERID -A1