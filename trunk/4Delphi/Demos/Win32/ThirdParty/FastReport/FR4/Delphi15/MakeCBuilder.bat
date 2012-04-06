echo off
rem Path to DCC32.exe
SET DCCPATH=D:\Program Files\Embarcadero\RAD Studio\8.0\bin\
rem Path to project Dir
rem SET PROJECTPATH=D:\Program Files\Devart\IbDac for RAD Studio XE\Demos\Win32\ThirdParty\FastReport\FR4\Delphi15\
SET PROJECTPATH=D:\Projects\Delphi\IbDac\Demos\Win32\ThirdParty\FastReport\FR4\Delphi15\
rem FastReport 4 LibD15 Path
SET FRLIBDLLPATH=D:\Program Files\FastReports\FastReport 4\LibD15


echo on
rem -----------------------BEGIN------------------------------------------
echo off
cd "%PROJECTPATH%"

rem FastReport
"%DCCPATH%DCC32.EXE" -LE. -B -JL frxDAC15.dpk -N0. -NO. -NH. -NB. -U"..\;%FRLIBDLLPATH%" -I"..\;%FRLIBDLLPATH%" -LU"dac150;fs15;fsDB15"
"%DCCPATH%DCC32.EXE" -LE. -B -JL frxIBDAC15.dpk -N0. -NO. -NH. -NB. -U"..\;%FRLIBDLLPATH%" -I"..\;%FRLIBDLLPATH%" -LU"dac150;fs15;fsDB15"
"%DCCPATH%DCC32.EXE" -LE. -B -JL dclfrxIBDAC15.dpk -N0. -NO. -NH. -NB. -U"..\;%FRLIBDLLPATH%" -I"..\;%FRLIBDLLPATH%" -LU"dac150;fs15;fsDB15"
rem FastScript
"%DCCPATH%DCC32.EXE" -LE. -B -JL fsDAC15.dpk -N0. -NO. -NH. -NB. -U"..\;%FRLIBDLLPATH%" -I"..\;%FRLIBDLLPATH%" -LU"dac150;fs15;fsDB15"
"%DCCPATH%DCC32.EXE" -LE. -B -JL fsIBDAC15.dpk -N0. -NO. -NH. -NB. -U"..\;%FRLIBDLLPATH%" -I"..\;%FRLIBDLLPATH%" -LU"dac150;fs15;fsDB15"
"%DCCPATH%DCC32.EXE" -LE. -B -JL dclfsIBDAC15.dpk -N0. -NO. -NH. -NB. -U"..\;%FRLIBDLLPATH%" -I"..\;%FRLIBDLLPATH%" -LU"dac150;fs15;fsDB15"