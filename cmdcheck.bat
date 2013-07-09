@echo off
setlocal
pushd %CD%
cd /d %~d0%~p0

set cmdsspec=conf\cmds_spec

set PATH=%PATH%;%~d0%~p0\bin

if exist cmd_missing ( del cmd_missing )
if exist %cmdsspec% ( del %cmdsspec% )

if exist conf\selection.txt (
    if exist conf\required_commands (
		for /f "usebackq" %%i in (`type conf\selection.txt`) do (
			if exist conf\required_commands\%%i.txt (
				echo [INFO] selected '%%i'
			) else (
				echo [ERR ] selected '%%i', but missing configuration 'conf\required_commands\%%i.txt'
				pause
				goto :EOB
			)
		)
	) else (
		echo [ERR ] missing 'conf\required_commands', cannot run with your selection.
		pause
		goto :EOB
	)
)

if exist conf\required_commands.txt (
	for /f "usebackq tokens=*" %%c in (`type conf\required_commands.txt`) do (
		for %%b in (%%c) do (
			if exist %%~$path:b (
				echo %%b	%%~$path:b >> %cmdsspec%
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

if exist conf\required_commands (
	for /f "usebackq" %%s in (`dir /b /s conf\required_commands`) do (
		for /f "usebackq tokens=*" %%c in (`type %%s`) do (
			for %%b in (%%c) do (
				if exist %%~$path:b (
					echo %%b	%%~$path:b >> %cmdsspec%
				) else (
					echo [ERR ] missing '%%c'
					echo [INFO] search on google! "http://www.google.co.jp/search?q=%%c"
					echo 1 > cmd_missing
					pause
				)
			)
		)
	)
)

if exist cmd_missing (
	del conf\cmds_spec
)

if exist %cmdsspec% (
	echo [INFO] created '%cmdsspec%' 
) else (
	echo [ERR ] command check failed.
)

:EOB

popd
endlocal
rem pause
goto :EOF
