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

set domainstr=CN=Computers,DC=%userdnsdomain:.=,DC=%

for %%c in (dsquery.exe) do (
	if exist %%~$path:c (
		echo %%~$path:c 
	) else (
		echo [ERR ] missing 'dsquery.exe'
		echo [INFO] search on google! "http://www.google.co.jp/search?q=dsquery.exe"
		pause
		goto :EOB
	)
)

echo dsquery computer %domainstr% -limit 10000 -scope onelevel
dsquery computer %domainstr% -limit 10000 -scope onelevel > list
for /f "usebackq delims=," %%a in (list) do (
	for /f "usebackq delims== tokens=2" %%c in (`echo %%a`) do (
		echo %%c
		echo %%c >> listall.txt
	)
)

for /f %%s in (listall.txt) do (
	ping >nul -a -n 1 -w 1 -4 %%s && echo %%s >> list.txt || echo [ERR ] ping-test %%s failed.
)

if exist list ( del list )

:EOB
popd
endlocal
rem pause
goto :EOF
