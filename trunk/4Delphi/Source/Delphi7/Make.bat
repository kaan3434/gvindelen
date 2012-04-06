@echo off
rem **********************************************************************
rem *
rem * IBDAC for Delphi 7
rem *
rem **********************************************************************

rem --- Win64 compatibility ---
if "%ProgramFiles(x86)%"=="" goto DoWin32
set PROGRAMFILES=%ProgramFiles(x86)%
:DoWin32

set IdeDir="%PROGRAMFILES%\Borland\Delphi7
del /Q/S IBDAC\*.*
call ..\Make.bat Delphi 7
