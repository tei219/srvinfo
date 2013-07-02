
--version
print '--version'+replicate('=',80)
select @@version as '@@version'
go

--traceflag status
print '--traceflag status'+replicate('=',80)
dbcc tracestatus(-1)
GO

--sp_configure
print '--sp_configure'+replicate('=',80)
exec sp_configure 'show advanced options', 1
go
reconfigure
go
exec sp_configure 
go
exec sp_configure 'show advanced options', 0
go
reconfigure
go

--sp_helpdb
print '--sp_helpdb'+replicate('=',80)
exec sp_helpdb

--file spec
print '--file spec'+replicate('=',80)
exec sp_MSforeachdb @command1 = '
    use ?
	select ''?'' as dbname,* from sysfiles
'

--xp_msver
print '--xp_msver'+replicate('=',80)
exec master.dbo.xp_msver

--syslogins
print '--syslogins'+replicate('=',80)
select * from master.dbo.syslogins

--exec msdb.dbo.sp_help_job
print '--sp_help_job'+replicate('=',80)
exec msdb.dbo.sp_help_job

--sysservers
print '--sysservers'+replicate('=',80)
select * from sysservers where dataaccess = 1

--sysalerts
print '--sysalerts'+replicate('=',80)
select * from msdb.dbo.sysalerts

--sysmessages
--print '--sysmessages'+replicate('=',80)
--select * from sysmessages where msglangid = 1041

--user spec
print '--user spec'+replicate('=',80)
declare @@tabname varchar(32)
declare @@stmt varchar(1024)

if (@@microsoftversion) > 150000000
begin
create table ##tab1(
	UserName 	sysname NULL,
	GroupName 	sysname NULL,
	LoginName 	sysname NULL,
	DefDBName 	sysname NULL,
	DefSchemaName 	sysname NULL,
	UserID	smallint,
	SID	smallint
)
set @@tabname = '##tab1'
end
else
begin
create table ##tab2(
	UserName 	sysname NULL,
	GroupName 	sysname NULL,
	LoginName 	sysname NULL,
	DefDBName 	sysname NULL,
	UserID	smallint,
	SID	smallint
)
set @@tabname = '##tab2'
end

set @@stmt = '
	use [?]
	insert '+@@tabname+' exec sp_helpuser
	--for diff
	select @@servername as InstanceName,db_name()as DatabaseName,UserName,GroupName,LoginName,DefDBName,UserID,SID from '+@@tabname+'
	truncate table '+@@tabname+'
'
exec sp_MSforeachdb @command1 = @@stmt


exec('drop table '+@@tabname)