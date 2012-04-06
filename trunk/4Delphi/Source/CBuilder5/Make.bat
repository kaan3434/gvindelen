@echo off
rem **********************************************************************
rem *
rem * IBDAC for CBuilder 5
rem *
rem **********************************************************************

rem --- Win64 compatibility ---
if "%ProgramFiles(x86)%"=="" goto DoWin32
set PROGRAMFILES=%ProgramFiles(x86)%
:DoWin32

set IdeDir="%PROGRAMFILES%\Borland\CBuilder5
del /Q/S IBDAC\*.*
call ..\Make.bat CBuilder 5
