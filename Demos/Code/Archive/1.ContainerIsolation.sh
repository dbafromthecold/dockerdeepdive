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



# set CPU limit on the fly - thanks Anthony!
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
FILES=$(docker inspect sqlcontainer1 --format '{{ .GraphDriver.Data.MergedDir }}') && echo $FILES



# view root directory of the container on the host
sudo ls -al $FILES



# view the database files on the host



# clean up
docker rm $(docker ps -aq) -f



# ok, so if we know the constructs around a container...can we build one from scratch?
# yes! yes we can
# first, run a container with docker (yes, I know but just wait :-) )
docker container run -d \
--publish 15800:1433 \
--env ACCEPT_EULA=Y \
--env MSSQL_SA_PASSWORD=Testing1122 \
--name sqlcontainer3 \
mcr.microsoft.com/mssql/server:2019-CU5-ubuntu-18.04



# confirm the container is running
docker container ls -a --format "table {{.Names }}\t{{ .Image }}\t{{ .Status }}\t{{.Ports}}"



# let's have a look at the logs in the container as well (to make sure that SQL is running)
docker logs sqlcontainer3



# stop the container
docker stop sqlcontainer3



# export the container to a .tar file
docker export sqlcontainer3 -o ~/sqlserver.tar



# now extract the .tar file to a directory
mkdir ~/sqlserver
tar -xvf ~/sqlserver.tar -C ~/sqlserver



# list the contents of that directory
ls ~/sqlserver



# let's add a file to that root directoy
touch ~/sqlserver/HI_DBAFROMTHECOLD



# let's start up that container again
docker start sqlcontainer3



# list the root directory contents in the container
docker exec sqlcontainer3 ls /



# blow that container away (we don't need it anymore)
docker rm sqlcontainer3 -f



# navigate to some code
cd ~/git/dockerdeepdive/Demos/ContainerFromScratch/



# view the code
cat main.go



# open a tmux session and split the command prompt (ctrl+B then ")
tmux



# spin up the container using Liz Rice's containers from scratch code...
# https://www.youtube.com/watch?v=_TsSmSu57Zo
sudo go run main.go run /bin/bash



# check the root directory
ls /



# now check the hostname
hostname



# add the urandom file - thanks Mark!
mknod -m 444 /dev/urandom c 1 9



# confirm file is there
ls /dev



# spin up SQL Server in the background
/opt/mssql/bin/sqlservr&> /dev/null &



# check processes in the container
ps aux



# check process on the host
ps aux | grep mssql



# have a look at the memory and cpu control groups location (notice sqlserver folder)
ls /sys/fs/cgroup/memory
ls /sys/fs/cgroup/cpu,cpuacct



# get memory limit
MEMORYLIMIT=$(cat /sys/fs/cgroup/memory/sqlserver/memory.limit_in_bytes)



# show memory limit of container in MB
expr $MEMORYLIMIT / 1024 / 1024



# show CPU limit
cat /sys/fs/cgroup/cpu,cpuacct/sqlserver/cpu.cfs_quota_us



# exit out of tmux and container
exit