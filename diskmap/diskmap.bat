@echo off

if "%1"=="" (
	echo "[ERR ] - missing target"
) else (
	cscript diskmap.wsf /target:%1
)

:EOB
goto :EOF
