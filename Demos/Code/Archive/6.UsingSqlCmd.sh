############################################################################
############################################################################
#
# Docker Deep Dive - Andrew Pruski
# @dbafromthecold
# dbafromthecold@gmail.com
# https://github.com/dbafromthecold/DockerDeepDive
# Running SQL containers with sqlcmd
#
############################################################################
############################################################################



# installation - https://learn.microsoft.com/en-us/sql/tools/sqlcmd/go-sqlcmd-utility?view=sql-server-ver16#download-and-install-go-sqlcmd
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
sudo add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/20.04/prod.list)"
sudo apt update && sudo apt install -y sqlcmd



# run a container
sqlcmd create mssql --accept-eula




# confirm container running
docker container ls -a --format "table {{.Names }}\t{{ .Image }}\t{{ .Status }}\t{{.Ports}}"



# find available images
sqlcmd create mssql get-tags



# set environment variable
export SQLCMD_ACCEPT_EULA=YES



# confirm
printenv | less




# run a container from another image
sqlcmd create mssql --tag 2019-CU5-ubuntu-18.04



# query sql in the container
sqlcmd query "SELECT @@VERSION"



# view the config file
cat /home/apruski/.sqlcmd/sqlconfig



# switch context
sqlcmd config use-context mssql



# confirm version
sqlcmd query "SELECT @@VERSION"



# view available options
sqlcmd create mssql --help



# run a container with AdventureWorks database
sqlcmd create mssql --accept-eula --using https://aka.ms/AdventureWorksLT.bak



# confirm database
sqlcmd query "SELECT [name] FROM sys.databases;"



# run another container with databases downloaded from Github
sqlcmd create mssql --using https://raw.githubusercontent.com/dbafromthecold/testrepository/main/testdatabase.bak



# confirm database
sqlcmd query "SELECT [name] FROM sys.databases;"



# clean up
sqlcmd config use-context mssql
sqlcmd delete --force --yes
sqlcmd config use-context mssql2
sqlcmd delete --force --yes
sqlcmd config use-context mssql3
sqlcmd delete --force --yes
sqlcmd config use-context mssql4
sqlcmd delete --force --yes
