@echo off

:loopstart

    if "%~1"=="" (
		goto loopend
	)

    set V=%~x1%~a1

	if /i "%V:~0,-10%"==".zip-" (
		if not exist "%~dpn1" (
			call "C:\Program Files\7-Zip\7z.exe" x "%~f1" -o*
		) else (
			echo "%~dpn1" already exists.
			pause
			exit
		)
	) else (
		echo "%~f1" is not ZIP file.
		pause
		exit
	)
	call :err "%~f1"
	shift
    goto loopstart

:loopend
exit

:err
if %errorlevel% equ 0 (
	del "%~f1"
	exit /b
) else (
	echo:
	echo ErrorLevel = %errorlevel%
	pause
	exit
)