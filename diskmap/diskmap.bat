@echo off
if "%~d0"=="\\" (
  echo.
	echo [ERR ] - not support UNC
	pause
	goto :EOF
)

if "%1"=="" (
	echo "[ERR ] - missing target"
) else (
	cscript diskmap.wsf /target:%1
)

:EOB
goto :EOF
