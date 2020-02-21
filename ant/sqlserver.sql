create database lportal;
go
alter database lportal set allow_snapshot_isolation on;
go
alter database lportal set read_committed_snapshot on;
go