@echo off
chcp 65001 >nul
echo バックアップ中……
set FASTCOPY=""
set /p="Desktop..." <nul
call %FASTCOPY% /job=desktop /auto_close
call :done
set /p="Documents..." <nul
call %FASTCOPY% /job=documents /auto_close
call :done

timeout /t 1 /nobreak >nul

:done
if %errorlevel% equ 0 (
	echo done
	exit /b
) else (
	echo:
	echo:
	echo 中止しました
	pause
	exit
)