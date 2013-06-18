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

set domainstr=DC=%userdnsdomain:.=,DC=%

for %%b in (dsquery.exe) do (
	if exist %%~$path:b (
		echo %%~$path:b 
	) else (
		echo [ERR ] missing 'dsquery.exe'
		echo [INFO] search on google! "http://www.google.co.jp/search?q=dsquery.exe"
		pause
		goto :EOB
	)
)

for %%b in (dsget.exe) do (
	if exist %%~$path:b (
		echo %%~$path:b 
	) else (
		echo [ERR ] missing 'dsget.exe'
		echo [INFO] search on google! "http://www.google.co.jp/search?q=dsget.exe"
		pause
		goto :EOB
	)
)

echo dsquery user %domainstr% -samid "%username%"
dsquery user %domainstr% -samid "%username%" > dn
for /f "eol=; usebackq tokens=*" %%a in (`type dn`) do (
	echo dsget user %%a -memberof
	(dsget user %%a -memberof | findstr /C:"Domain Admins" && goto :usercheck_ok) || goto :usercheck_fail
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
	echo [INFO] make list.txt ...
	pause
	call makelist.bat
)

goto :EOB

:do_collect
set target=%1
for /f "usebackq" %%c in (`dir /b /a:d`) do (
	if exist %%c\%%c.bat (
		echo [INFO] entering %%c\ ...
		cd /d %%c\
		echo [INFO] do %%c\%%c.bat %target%
		call %%c.bat %target%
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
