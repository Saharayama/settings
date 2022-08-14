@echo off
:LOOPSTART

    if "%~1" == "" goto LOOPEND
	start "" "" "%~f1"
    shift
    goto LOOPSTART

:LOOPEND