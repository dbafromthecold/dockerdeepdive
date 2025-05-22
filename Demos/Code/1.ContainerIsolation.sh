############################################################################
############################################################################
#
# Docker Deep Dive - Andrew Pruski
# @dbafromthecold
# dbafromthecold@gmail.com
# https://github.com/dbafromthecold/DockerDeepDive
# Container Isolation
#
############################################################################
############################################################################



# run a container - limiting the memory available to it
docker container run -d \
--publish 15789:1433 \
--memory 2048M \
--env ACCEPT_EULA=Y \
--env MSSQL_SA_PASSWORD=Testing1122 \
--name sqlcontainer1 \
mcr.microsoft.com/mssql/server:2019-CU5-ubuntu-18.04



# confirm container is running
docker container ls -a



# list containers again using --format
docker container ls -a --format "table {{.Names }}\t{{ .Image }}\t{{ .Status }}\t{{.Ports}}"



# grab the container ID
CONTAINERID=$(docker ps -aq) && echo $CONTAINERID



# view control groups created
find /sys/fs/cgroup/ -name *$CONTAINERID*



# get memory and cpu control groups
MEMORYCGROUP=$(find /sys/fs/cgroup/ -name *$CONTAINERID* | grep memory) && echo $MEMORYCGROUP
CPUCGROUP=$(find /sys/fs/cgroup/ -name *$CONTAINERID* | grep cpu,cpuacct) && echo $CPUCGROUP



# get memory limit
MEMORYLIMIT=$(cat $MEMORYCGROUP/memory.limit_in_bytes)



# show memory limit of container in MB
expr $MEMORYLIMIT / 1024 / 1024



# show unrestricted CPU limit
cat $CPUCGROUP/cpu.cfs_quota_us



# set CPU limit on the fly
docker update sqlcontainer1 --cpus 2



# show restricted CPU limit
cat $CPUCGROUP/cpu.cfs_quota_us



# view namespaces created
sudo lsns | grep mssql



# view hostname of Docker host
hostname



# view the hostname within the container
docker exec sqlcontainer1 hostname



# list processes within the container
docker exec sqlcontainer1 ps aux



# view mssql processes on host
ps aux | grep mssql



# grab the pid
pid=$(sudo lsns | grep mssql | awk '!visited[$4]++ {print $4}') && echo $pid



# enter the namespaces
sudo nsenter -t $pid --pid --uts --mount --net --ipc /bin/bash



# check the hostname
hostname



# check the processes running
ps aux



# exit namespaces
exit



# let's run another container from a custom image which runs SQL as root
docker container run -d \
--publish 15799:1433 \
--env ACCEPT_EULA=Y \
--env MSSQL_SA_PASSWORD=Testing1122 \
--name sqlcontainer2 \
ghcr.io/dbafromthecold/dockerdeepdive:customsql2019-root



# view mssql processes on host again
ps aux | grep mssql



# create a database in the SQL instance in the container
mssql-cli -S localhost,15789 -U sa -P Testing1122 -Q "CREATE DATABASE [testdatabase]"



# list the database files within the container
docker exec sqlcontainer1 ls -al /var/opt/mssql/data



# list those files on the host
ls -al /var/opt/mssql/data



# get container root location



# view root directory of the container on the host
sudo ls -al $FILES



# view the database files on the host
sudo ls -al $FILES/var/opt/mssql/data



# clean up
docker rm $(docker ps -aq) -f
