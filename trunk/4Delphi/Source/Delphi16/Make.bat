@echo off
rem **********************************************************************
rem *
rem * IBDAC for Delphi XE2
rem *
rem **********************************************************************

rem --- Win64 compatibility ---
if "%ProgramFiles(x86)%"=="" goto DoWin32
set PROGRAMFILES=%ProgramFiles(x86)%
:DoWin32

set IdeDir="%PROGRAMFILES%\Embarcadero\RAD Studio\9.0
del /Q/S IBDAC\*.*
call ..\Make.bat Delphi 16 WIN32
call ..\Make.bat Delphi 16 WIN64
call ..\Make.bat Delphi 16 OSX32
