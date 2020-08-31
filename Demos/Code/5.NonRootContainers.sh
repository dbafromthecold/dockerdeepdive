

# try to switch to the root user
sudo -l -U andrew



# check the sudo group
cat /etc/group | grep sudo



# switch to another user
su andrew



# try switching to root
sudo su



# run a container mounting the /etc folder from the host
docker run -d -p 15789:1433 \
--volume /etc:/etc \
--env SA_PASSWORD=Testing1122 \
--env ACCEPT_EULA=Y \
--name testcontainer1 \
testimage



# look at the log
docker logs testcontainer1 | head -3



# jump into the container
docker exec -it testcontainer1 bash



# add user to sudo group
adduser andrew sudo



# exit container and user
exit



# recheck the sudo group
sudo -l -U andrew



# switch back to the user
su andrew



# now switch to root
sudo su



# remove user from sudo group
sudo deluser andrew sudo



# delete container
docker rm $(docker ps -aq) -f