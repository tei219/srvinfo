@echo off
setlocal
pushd %CD%
cd /d %~d0%~p0

if exist cmd_missing ( del cmd_missing )
if exist conf\cmds_spec ( del conf\cmds_spec )

if exist conf\required_commands.txt (
    for /f "usebackq tokens=*" %%c in (`type conf\required_commands.txt`) do (
		for %%b in (%%c) do (
			if exist %%~$path:b (
				echo %%b	%%~$path:b >> conf\cmds_spec
			) else (
				echo [ERR ] missing '%%c'
				echo [INFO] search on google! "http://www.google.co.jp/search?q=%%c"
				echo 1 > cmd_missing
				pause
			)
		)
	)
) else (
	echo [ERR ] missing 'conf\required_commands.txt'
	goto :EOB
)

if exist cmd_missing (
	del conf\cmds_spec
)

if exist conf\cmds_spec (
	echo [INFO] created 'conf\cmds_spec' 
) else (
	echo [ERR ] command check failed.
)

:EOB

popd
endlocal
rem pause
goto :EOF
