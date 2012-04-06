//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("dac50.res");
USEPACKAGE("vcl50.bpi");
USEUNIT("..\CRTypes.obj");
USEUNIT("..\CRFunctions.obj");
USEUNIT("..\DBAccess.pas");
USEUNIT("..\CRAccess.pas");
USEUNIT("..\DALoader.pas");
USEUNIT("..\DADump.pas");
USEUNIT("..\CRParser.pas");
USEUNIT("..\DAConsts.pas");
USEUNIT("..\DBMonitorMessages.pas");
USEUNIT("..\DBMonitorClient.pas");
USEUNIT("..\DASQLMonitor.pas");
USEUNIT("..\MemData.pas");
USEUNIT("..\MemDS.pas");
USEUNIT("..\VirtualTable.pas");
USEUNIT("..\DacVcl.pas");
USEUNIT("..\DAVersionInfo.pas");
USEUNIT("..\CLRClasses.pas");
USEUNIT("..\MemUtils.pas");
USEUNIT("..\DAScript.pas");
USEUNIT("..\CRBatchMove.pas");
USEUNIT("..\Win32Timer.pas");
USEUNIT("..\CRConnectionPool.pas");
USEUNIT("..\CRXml.pas");
USEUNIT("..\CRVio.pas");
USEUNIT("..\CRVioTcp.pas");
USEUNIT("..\CRBase64.pas");
USEUNIT("..\CRDataBuffer.pas");
USEUNIT("..\CRHttp.pas");
USEUNIT("..\CRVioHttp.pas");
USEUNIT("..\CRVioTcpSSL.pas");
USEUNIT("..\MTSCall.pas");
USEPACKAGE("Vcldb50.bpi");
USEPACKAGE("VCLBDE50.bpi");
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------

//   Package source.
//---------------------------------------------------------------------------

#pragma argsused
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
        return 1;
}
//---------------------------------------------------------------------------
