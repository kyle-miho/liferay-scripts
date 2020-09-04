echo "Initializing Database"

docker exec db2 bash -c "echo -e 'db2 drop database lportal' | su - db2inst1"
docker exec db2 bash -c "echo -e 'db2 create database lportal pagesize 32768 temporary tablespace managed by automatic storage' | su - db2inst1"