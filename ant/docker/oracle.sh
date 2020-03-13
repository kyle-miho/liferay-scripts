echo "Initializing Database"

docker exec oracle /bin/bash -c "source /home/oracle/.bashrc; echo -e 'connect sys/Oradoc_db1 as sysdba; \n alter session set \"_ORACLE_SCRIPT\"=true; \n create user lportal identified by lportal; \n grant all privileges to lportal;' | sqlplus /nolog"