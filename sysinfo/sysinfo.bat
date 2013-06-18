@echo off

for %%b in (systeminfo.exe) do (
  if exist %%~$path:b (
		echo %%~$path:b 
	) else (
		echo [ERR ] missing 'systeminfo.exe'
		pause
		goto :EOB
	)
)

if "%1"=="" (
	echo "[ERR ] - missing target"
) else (
	systeminfo /s %1 > %1.txt
)

:EOB
goto :EOF
