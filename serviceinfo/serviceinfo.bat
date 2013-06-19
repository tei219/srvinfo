@echo off

if not exist bin\psservice.exe (
	echo [ERR ] missing 'bin\psservice.exe'
	echo [INFO] search on google! http://www.google.co.jp/search?q=psservice.exe
	pause
	goto :EOB
)

if not exist bin\1st_launch (
	bin\psexec.exe /? >nul
	echo 1 > bin\1st_launch
)

if "%1"=="" (
	echo "[ERR ] - missing target"
) else (
	bin\psservice.exe \\%1 query  > %1.txt
)

:EOB
goto :EOF
