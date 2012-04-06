
//////////////////////////////////////////////////
//  InterBase Data Access Components
//  Copyright © 1998-2011 Devart. All right reserved.
//  IBDAC Package for C++ Builder 5
//////////////////////////////////////////////////

//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USEUNIT("..\IBCParser.pas");
USEUNIT("..\IBCConsts.pas");
USEUNIT("..\IBCClasses.pas");
USEUNIT("..\IBCCall.pas");
USEUNIT("..\IBCSQLMonitor.pas");
USEUNIT("..\IBC.pas");
USEUNIT("..\IBCAlerter.pas");
USEUNIT("..\IBCScript.pas");
USEUNIT("..\IBCLoader.pas");
USEUNIT("..\IBCAdmin.pas");
USEUNIT("..\IBCError.pas");
USERES("ibdac50.res");
USEPACKAGE("vcl50.bpi");
USEPACKAGE("vcldb50.bpi");
USEPACKAGE("dnside50.bpi");
USEPACKAGE("dac50.bpi");
USEUNIT("..\IbDacVcl.pas");
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------
//   Package source.
//---------------------------------------------------------------------------
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
    return 1;
}
//---------------------------------------------------------------------------
