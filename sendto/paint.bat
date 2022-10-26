@echo off
:LOOPSTART

    if "%~1" == "" goto LOOPEND
	start "" "mspaint" "%~f1"
    shift
    goto LOOPSTART

:LOOPEND