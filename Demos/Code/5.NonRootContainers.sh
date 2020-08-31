



cat /etc/group | grep sudo



docker run -d -p 15789:1433 \
--volume /etc:/etc \
--env SA_PASSWORD=Testing1122 \
--env ACCEPT_EULA=Y \
--name testcontainer \
mcr.microsoft.com/mssql/server:2019-RC1-ubuntu


docker container ls -a



docker exec -it testcontainer bash



useradd testuser
passwd testuser
adduser testuser sudo



cat /etc/group | grep sudo



su testuser


sudo .....
