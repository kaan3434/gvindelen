
//////////////////////////////////////////////////
//  InterBase Data Access Components
//  Copyright © 1998-2011 Devart. All right reserved.
//  IBDAC Package for C++ Builder 5
//////////////////////////////////////////////////

//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USEUNIT("..\Design\IBCReg.pas");
USEUNIT("..\Design\IBCDesign.pas");
USERES("dclibdac50.res");
USEPACKAGE("ibdac50.bpi");
USEPACKAGE("dcldb50.bpi");
USEPACKAGE("vcl50.bpi");
USEPACKAGE("vcldb50.bpi");
USEPACKAGE("vclbde50.bpi");
USEPACKAGE("dcldac50.bpi");
USEPACKAGE("vcljpg50.bpi");
USEPACKAGE("dsnide50.bpi");
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
