@echo off

set cmdsspec=..\conf\cmds_spec
set reqcmd1=sc.exe
set cmd1=
set reqcmd2=sqlcmd.exe
set cmd2=
set target=%1

if not exist %cmdsspec% (
    echo [ERR ] missing '%cmdsspec%'
	echo [INFO] do 'cmdcheck.bat' first.
	goto :EOB
) else (
	for /f "usebackq tokens=1,2 delims=	" %%x in (%cmdsspec%) do (
		if "%%x"=="%reqcmd1%" ( set cmd1=%%y )
		if "%%x"=="%reqcmd2%" ( set cmd2=%%y )
	)
)

if "%cmd1%"=="" (
	echo [ERR ] missing commands '%reqcmd1%' on '%cmdsspec%'
	pause
	goto :EOB
)

if "%cmd2%"=="" (
	echo [ERR ] missing commands '%reqcmd2%' on '%cmdsspec%'
	pause
	goto :EOB
)

if exist tmp ( del tmp )
if exist instances ( del instances )
if exist error ( del error )

:do_batch
if "%1"=="" (
	echo "[ERR ] missing target"
) else (
	echo [INFO] "%cmd1% \\%1 query | findstr /R /C:"^SERVICE_NAME" > tmp"
	%cmd1% \\%1 query | findstr /R /C:"^SERVICE_NAME" > tmp
	echo [INFO] "type tmp | findstr /R /C:"MSSQLSERVER" >> instances"
	type tmp | findstr /R /C:"MSSQLSERVER" >> instances
	echo [INFO] "type tmp | findstr /R /C:"MSSQL\$" >> instances"
	type tmp | findstr /R /C:"MSSQL\$" >> instances

	for /f "usebackq tokens=2 delims= " %%i in (`type instances`) do (
		echo [INFO] found SQLServer instance %%i on %1
		call :do_sqlversion %%i
	)
)
goto :EOB

:do_sqlversion
set instance_name=%1
set outputfilename=
if "%instance_name%"=="MSSQLSERVER" (
	set instance_name=%target%
	set outputfilename=%target%.txt
) else (
	set instance_name=%target%\%instance_name:MSSQL$=%
	set outputfilename=%target%_%instance_name:MSSQL$=%.txt
)

echo %instance_name% >> error
echo [INFO] ""%cmd2%" -E -S %instance_name% -Q "set nocount on; select @@version" > %outputfilename%"
"%cmd2%" -E -S %instance_name% -Q "set nocount on; select @@version" 1> %outputfilename% 2>> error
echo. >> error

exit /b


:EOB
if exist tmp ( del tmp )
if exist instances ( del instances )

goto :EOF