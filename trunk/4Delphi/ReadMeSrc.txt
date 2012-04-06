InterBase Data Access Components Source Code
Copyright 1997-2011, Devart. All Rights Reserved

There are two ways to compile and install IBDAC for Windows manually.

I. Using IDE

Delphi and C++ Builder for Win32
--------------------------------

Run your IDE and walk through folowing steps:
  1) Compile DAC run-time package (dacXX.dpk)
  2) For Delphi 6 and higher compile DAC GUI related package (dacvclXX.dpk)
  3) Compile DAC design-time package (dcldacXX.dpk)
  4) Compile IBDAC run-time package (ibdacXX.dpk)
  5) For Delphi 6 and higher compile IBDAC GUI related package (ibdacvclXX.dpk)
     If you are going to create CLX applications compile IbDacClx.pas unit separately.
  6) Compile and install IBDAC design-time package (dclibdacXX.dpk)

You can find these packages in 
  Source\Delphi5\*.dpk - for Delphi 5 
  Source\CBuilder5\*.bpk - for C++ Builder 5
  Source\Delphi6\*.dpk - for Delphi 6 
  Source\CBuilder6\*.bpk - for C++ Builder 6
  Source\Delphi7\*.dpk - for Delphi 7 
  Source\Delphi9\*.dpk - for Delphi 2005
  Source\Delphi10\*.dpk - for BDS 2006
  Source\Delphi11\*.dpk - for RAD Studio 2007
  Source\Delphi12\*.dpk - for RAD Studio 2009
  Source\Delphi14\*.dpk - for RAD Studio 2010
  Source\Delphi15\*.dpk - for RAD Studio XE
  Source\Delphi16\*.dpk - for RAD Studio XE2

To compile IBDAC based application add IBDAC Source directory path 
to the "Library Path".

Delphi for .NET
-----------------

Run your IDE and walk through folowing steps:
  1) Compile DAC run-time package (Devart.Dac.dpk)
  2) Compile DAC design-time package (Devart.Dac.Design.dpk)
  3) Compile IBDAC run-time package (Devart.IbDac.dpk)
  4) Compile IBDAC run-time package (Devart.IbDac.AdoNet.dpk)
  5) Compile and install IBDAC design-time package (Devart.IbDac.Design.dpk)
  6) Specify the path to compiled assembles in "Assembly Search Paths"

You can find these packages in 
  Source\Delphi9\*.dpk - for Delphi 2005
  Source\Delphi10\*.dpk - for BDS 2006
  Source\Delphi11\*.dpk - for RAD Studio 2007

To compile IBDAC based application add Devart.Dac and Devart.IbDac to 
Namespace prefixes, add IBDAC Source directory path to the "Library Path" list.

II. Using make-files

Delphi and C++ Builder for Win32
--------------------------------

  1) Go to one of the following folders (let's denote this folder %MakePath%):
     Source\Delphi5\*.dpk - for Delphi 5 
     Source\CBuilder5\*.bpk - for C++ Builder 5
     Source\Delphi6\*.dpk - for Delphi 6 
     Source\CBuilder6\*.bpk - for C++ Builder 6
     Source\Delphi7\*.dpk - for Delphi 7 
     Source\Delphi9\*.dpk - for Delphi 2005
     Source\Delphi10\*.dpk - for BDS 2006
     Source\Delphi11\*.dpk - for RAD Studio 2007
     Source\Delphi12\*.dpk - for RAD Studio 2009
     Source\Delphi14\*.dpk - for RAD Studio 2010
     Source\Delphi15\*.dpk - for RAD Studio XE
     Source\Delphi16\*.dpk - for RAD Studio XE2

  2) Find in the 'Make.bat' line containing 

     set IdeDir="D:\Program Files\Borland\Delphi7

     and make sure that correct path to IDE is set (always include forward
     quote and do not include ending quote)

  3) Run 'Make.bat'. Binaries will be copied to %MakePath%\IbDac subfolder
  4) Copy %MakePath%\IbDac\*.bpl files to a folder that is included in the
     PATH environment variable
  5) Run IDE and add dclibdacXX.bpl via Component->Install Packages... menu 
  6) To compile IBDAC based application add IBDAC Source directory path 
     to the "Library Path" list

Delphi for .NET
-----------------

  1) Go to the following folders (let's denote this folder %MakePath%):
     Source\Delphi9\*.dpk - for Delphi 2005
     Source\Delphi10\*.dpk - for BDS 2006
     Source\Delphi11\*.dpk - for RAD Studio 2007

  2) Find in the 'Make.bat' line containing 

     set IdeDir="D:\Program Files\Borland\BDS\4.0

     and make sure that correct path to IDE is set (always include forward
     quote and do not include ending quote)

  3) Run 'Make.bat'. Binaries will be copied to %MakePath%\IbDac subfolder
  4) Run IDE and add Devart.IbDac.Design.dll via Component->Installed 
     .NET Components->.NET VCL Components->Add... menu. Specify the path to compiled assembles 
     in Component->Assembly Search Paths->Add... menu

  6) To compile IBDAC based application add Devart.Dac and Devart.IbDac to 
     Tools->Options->Environment Options->Delphi Options->Library->
     Namespace prefixes