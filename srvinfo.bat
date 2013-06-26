@echo off
if "%~d0"=="\\" (
    echo.
	echo [ERR ] - not support UNC
	pause
	goto :EOF
)
setlocal
pushd %CD%
cd /d %~d0%~p0

if "%userdnsdomain%"=="" (
	echo "[ERR ] empty domain string '%userdnsdomain%'"
	pause
	goto :EOB
)

set cmdsspec=conf\cmds_spec
set domainstr=DC=%userdnsdomain:.=,DC=%
set reqcmd1=dsquery.exe
set reqcmd2=dsget.exe
set cmd1=
set cmd2=
set PATH=%PATH%;%~d0%~p0\bin

echo [INFO] call 'cmdcheck.bat'
call cmdcheck.bat

if not exist %cmdsspec% (
	echo [ERR ] missing '%cmdsspec%'
	pause
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

echo %cmd1% user %domainstr% -samid "%username%"
%cmd1% user %domainstr% -samid "%username%" > dn
for /f "eol=; usebackq tokens=*" %%a in (`type dn`) do (
	echo %cmd2% user %%a -memberof
	(%cmd2% user %%a -memberof | findstr /C:"Domain Admins" && goto :usercheck_ok) || goto :usercheck_fail
)

:usercheck_fail
echo [ERR ] you're not member of "Domain Admins" ('%userdomain%\%username%')
pause
goto :EOB

:usercheck_ok
if exist list.txt (
	for /f %%d in (list.txt) do (
		call :do_collect %%d
	)
) else (
	echo [ERR ] missing list.txt
	echo [INFO] do 'makelist.bat' ...
	call makelist.bat
)

goto :EOB

:do_collect
set target=%1
for /f "usebackq" %%c in (`dir /b /a:d`) do (
	if exist %%c\%%c.bat (
		echo [INFO] entering %%c\ ...
		cd /d %%c\
		if exist ..\conf\selection.txt (
			type ..\conf\selection.txt | findstr >nul /R /C:"^%%c$"  && echo 1 > selected
			if exist selected (
				echo [INFO] do %%c\%%c.bat %target%
				call %%c.bat %target%
				del selected
			) else (
				echo [INFO] nothing to do.
			)
		) else (
			echo [INFO] do %%c\%%c.bat %target%
			call %%c.bat %target%
		)
		echo [INFO] exiting %%c\ ...
		cd ..
		echo -----------------------
	)
)
exit /b


:EOB
if exist dn ( del dn )

popd
endlocal
rem pause
goto :EOF