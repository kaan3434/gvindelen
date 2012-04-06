echo off
rem Path to DCC32.exe
SET DCCPATH=D:\Program Files\CodeGear\RAD Studio\5.0\bin\
rem Path to project Dir
rem SET PROJECTPATH=D:\Program Files\Devart\IbDac for RAD Studio 2007\Demos\Win32\ThirdParty\FastReport\FR4\Delphi11\
SET PROJECTPATH=D:\Projects\Delphi\IbDac\Demos\Win32\ThirdParty\FastReport\FR4\Delphi11\
rem FastReport 4 LibD11 Path
SET FRLIBDLLPATH=D:\Program Files\FastReports\FastReport 4\LibD11


echo on
rem -----------------------BEGIN------------------------------------------
echo off
cd "%PROJECTPATH%"

rem FastReport
"%DCCPATH%DCC32.EXE" -LE. -B -JL frxDAC11.dpk -N0. -NO. -NH. -NB. -U"..\;%FRLIBDLLPATH%" -I"..\;%FRLIBDLLPATH%" -LU"dac105;fs11;fsDB11"
"%DCCPATH%DCC32.EXE" -LE. -B -JL frxIBDAC11.dpk -N0. -NO. -NH. -NB. -U"..\;%FRLIBDLLPATH%" -I"..\;%FRLIBDLLPATH%" -LU"dac105;fs11;fsDB11"
"%DCCPATH%DCC32.EXE" -LE. -B -JL dclfrxIBDAC11.dpk -N0. -NO. -NH. -NB. -U"..\;%FRLIBDLLPATH%" -I"..\;%FRLIBDLLPATH%" -LU"dac105;fs11;fsDB11"
rem FastScript
"%DCCPATH%DCC32.EXE" -LE. -B -JL fsDAC11.dpk -N0. -NO. -NH. -NB. -U"..\;%FRLIBDLLPATH%" -I"..\;%FRLIBDLLPATH%" -LU"dac105;fs11;fsDB11"
"%DCCPATH%DCC32.EXE" -LE. -B -JL fsIBDAC11.dpk -N0. -NO. -NH. -NB. -U"..\;%FRLIBDLLPATH%" -I"..\;%FRLIBDLLPATH%" -LU"dac105;fs11;fsDB11"
"%DCCPATH%DCC32.EXE" -LE. -B -JL dclfsIBDAC11.dpk -N0. -NO. -NH. -NB. -U"..\;%FRLIBDLLPATH%" -I"..\;%FRLIBDLLPATH%" -LU"dac105;fs11;fsDB11"