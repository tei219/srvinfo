@echo off

set cmdsspec=..\conf\cmds_spec
set reqcmd1=psexec.exe
set cmd1=

if not exist %cmdsspec% (
    echo [ERR ] missing '%cmdsspec%'
	echo [INFO] do 'cmdcheck.bat' first.
	goto :EOB
) else (
	for /f "usebackq tokens=1,2 delims=	" %%x in (%cmdsspec%) do (
		if "%%x"=="%reqcmd1%" ( set cmd1=%%y )
	)
)

if "%cmd1%"=="" (
	echo [ERR ] missing commands '%reqcmd1%' on '%cmdsspec%'
	pause
	goto :EOB
)

:do_batch
if "%1"=="" (
	echo "[ERR ] missing target"
) else (
	echo [INFO] "%cmd1% \\%1 -s ipconfig.exe /all > %1.txt"
	%cmd1% \\%1 -s ipconfig.exe /all > %1.txt
)

:EOB
goto :EOF