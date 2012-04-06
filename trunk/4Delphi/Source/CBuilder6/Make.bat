@echo off
rem **********************************************************************
rem *
rem * IBDAC for CBuilder 6
rem *
rem **********************************************************************

rem --- Win64 compatibility ---
if "%ProgramFiles(x86)%"=="" goto DoWin32
set PROGRAMFILES=%ProgramFiles(x86)%
:DoWin32

set IdeDir="%PROGRAMFILES%\Borland\CBuilder6
del /Q/S IBDAC\*.*
call ..\Make.bat CBuilder 6
