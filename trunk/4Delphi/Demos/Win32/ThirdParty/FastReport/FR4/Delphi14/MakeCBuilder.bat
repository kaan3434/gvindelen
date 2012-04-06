echo off
rem Path to DCC32.exe
SET DCCPATH=D:\Program Files\Embarcadero\RAD Studio\7.0\bin\
rem Path to project Dir
rem SET PROJECTPATH=D:\Program Files\Devart\IbDac for RAD Studio 2010\Demos\Win32\ThirdParty\FastReport\FR4\Delphi14\
SET PROJECTPATH=D:\Projects\Delphi\IbDac\Demos\Win32\ThirdParty\FastReport\FR4\Delphi14\
rem FastReport 4 LibD14 Path
SET FRLIBDLLPATH=D:\Program Files\FastReports\FastReport 4\LibD14


echo on
rem -----------------------BEGIN------------------------------------------
echo off
cd "%PROJECTPATH%"

rem FastReport
"%DCCPATH%DCC32.EXE" -LE. -B -JL frxDAC14.dpk -N0. -NO. -NH. -NB. -U"..\;%FRLIBDLLPATH%" -I"..\;%FRLIBDLLPATH%" -LU"dac140;fs14;fsDB14"
"%DCCPATH%DCC32.EXE" -LE. -B -JL frxIBDAC14.dpk -N0. -NO. -NH. -NB. -U"..\;%FRLIBDLLPATH%" -I"..\;%FRLIBDLLPATH%" -LU"dac140;fs14;fsDB14"
"%DCCPATH%DCC32.EXE" -LE. -B -JL dclfrxIBDAC14.dpk -N0. -NO. -NH. -NB. -U"..\;%FRLIBDLLPATH%" -I"..\;%FRLIBDLLPATH%" -LU"dac140;fs14;fsDB14"
rem FastScript
"%DCCPATH%DCC32.EXE" -LE. -B -JL fsDAC14.dpk -N0. -NO. -NH. -NB. -U"..\;%FRLIBDLLPATH%" -I"..\;%FRLIBDLLPATH%" -LU"dac140;fs14;fsDB14"
"%DCCPATH%DCC32.EXE" -LE. -B -JL fsIBDAC14.dpk -N0. -NO. -NH. -NB. -U"..\;%FRLIBDLLPATH%" -I"..\;%FRLIBDLLPATH%" -LU"dac140;fs14;fsDB14"
"%DCCPATH%DCC32.EXE" -LE. -B -JL dclfsIBDAC14.dpk -N0. -NO. -NH. -NB. -U"..\;%FRLIBDLLPATH%" -I"..\;%FRLIBDLLPATH%" -LU"dac140;fs14;fsDB14"