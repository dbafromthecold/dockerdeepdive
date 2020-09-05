docker run -d
--publish 15789:1433
--env SA_PASSWORD=Testing1122
--env ACCEPT_EULA=Y
--env MSSQL_AGENT_ENABLED=True
--env MSSQL_DATA_DIR=/var/opt/sqlserver/data
--env MSSQL_LOG_DIR=/var/opt/sqlserver/log
--env MSSQL_BACKUP_DIR=/var/opt/sqlserver/backup
--network sqlserver
--volume sqlsystem:/var/opt/mssql
--volume sqldata:/var/opt/sqlserver/data
--volume sqllog:/var/opt/sqlserver/log
--volume sqlbackup:/var/opt/sqlserver/backup
--name testcontainer1
mcr.microsoft.com/mssql/server:2019-CU5-ubuntu-18.04