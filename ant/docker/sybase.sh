echo "Initializing Database"

docker cp /home/kyle/Liferay/scripts/ant/docker/sybase-commands sybase:/sybase-commands.sql
docker exec sybase /bin/bash -c "source /opt/sybase/SYBASE.sh; isql -U sa -P myPassword -S MYSYBASE -i /sybase-commands.sql"