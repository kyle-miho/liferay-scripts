echo "Initializing Database"
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Liferay123 -Q 'CREATE DATABASE lportal'
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Liferay123 -Q 'alter database lportal set allow_snapshot_isolation on;'
docker exec sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Liferay123 -Q 'alter database lportal set read_committed_snapshot on;'