@echo off
setlocal
pushd %CD%
cd /d %~d0%~p0

if exist listall.txt ( del listall.txt )
if exist list.txt ( del list.txt )
if exist list ( del list )

if "%userdnsdomain%"=="" (
    echo "[ERR ] empty domain string '%userdnsdomain%'"
	pause
	goto :EOB
)

set domainstr=DC=%userdnsdomain:.=,DC=%
set reqcmd1=dsquery.exe
set cmd1=

if not exist conf\cmds_spec (
	echo [ERR ] missing 'conf\cmds_spec'
	echo [INFO] do 'cmdcheck.bat' first.
	goto :EOB
) else (
	for /f "usebackq tokens=1,2 delims=	" %%x in (conf\cmds_spec) do (
		if "%%x"=="%reqcmd1%" ( set cmd1=%%y )
	)
)

if "%cmd1%"=="" (
	echo [ERR ] missing commands '%reqcmd1%' on 'conf\cmds_spec'
	pause
	goto :EOB
)

echo [INFO] %cmd1% computer %domainstr% -limit 10000
%cmd1% computer %domainstr% -limit 10000 > list

if exist conf\ignore_dn.txt (
	for /f "usebackq tokens=* " %%s in (conf\ignore_dn.txt) do (
		call :do_filter %%s
	)
)

for /f "usebackq delims=," %%a in (list) do (
	for /f "usebackq delims== tokens=2" %%c in (`echo %%a`) do (
		echo %%c
		echo %%c >> listall.txt
	)
)

for /f %%s in (listall.txt) do (
	(ping >nul -a -n 1 -w 1 -4 %%s && echo %%s >> list.txt) || echo [ERR ] ping-test %%s failed.
)
goto :EOB

:do_filter
	set filter_string=%*
	if not ^%filter_string:~0,1%==^# (
		echo [INFO] filtered by '%filter_string%'
		type list | findstr /V /C:%filter_string% > tmp
		move >nul /y tmp list
		del tmp
	)
exit /b


:EOB
if exist list ( del list )

popd
endlocal
rem pause
goto :EOF
