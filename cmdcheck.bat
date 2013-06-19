@echo off
setlocal
pushd %CD%
cd /d %~d0%~p0

if exist missing_commands ( del missing_commands )

for /f "usebackq" %%c in (`dir /b /s *.required`) do (
    call :checkcmd %%c
)
goto :EOB

:checkcmd
	if not exist %~d1%~p1%~n1 (
		echo [ERR ] missing command! %~d1%~p1%~n1
		echo %~d1%~p1%~n1 > missing_commands
	)
exit /b

:EOB

popd
endlocal
rem pause
goto :EOF
