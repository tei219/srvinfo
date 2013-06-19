@echo off

if not exist bin\1st_launch (
  bin\psexec.exe /? >nul
	echo 1 > bin\1st_launch
)

if "%1"=="" (
	echo "[ERR ] - missing target"
) else (
	bin\psexec.exe \\%1 -s cmd /C set > %1.txt
)

:EOB
goto :EOF
