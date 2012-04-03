unit server_midas_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : $Revision:   1.88.1.0.1.0  $
// File generated on 28.11.2001 17:10:09 from Type Library described below.

// ************************************************************************ //
// Type Lib: C:\FIBPlusDemoPack\MIDAS\server_midas.tlb (1)
// IID\LCID: {20911908-474D-4F14-92DA-80924FB24E4D}\0
// Helpfile: 
// DepndLst: 
//   (1) v1.0 Midas, (C:\WINNT\System32\midas.dll)
//   (2) v2.0 stdole, (C:\WINNT\System32\stdole2.tlb)
//   (3) v4.0 StdVCL, (C:\WINNT\System32\STDVCL40.DLL)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
interface

uses Windows, ActiveX, Classes, Graphics, OleServer, OleCtrls, StdVCL, 
  MIDAS;

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  server_midasMajorVersion = 1;
  server_midasMinorVersion = 0;

  LIBID_server_midas: TGUID = '{20911908-474D-4F14-92DA-80924FB24E4D}';

  IID_IFIBPlusDemoServer: TGUID = '{288532F6-B3AC-4D26-9133-53FAE292F51A}';
  CLASS_FIBPlusDemoServer: TGUID = '{D9EA72CA-E39E-492A-ABB3-C2F2A31F12C1}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IFIBPlusDemoServer = interface;
  IFIBPlusDemoServerDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  FIBPlusDemoServer = IFIBPlusDemoServer;


// *********************************************************************//
// Interface: IFIBPlusDemoServer
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {288532F6-B3AC-4D26-9133-53FAE292F51A}
// *********************************************************************//
  IFIBPlusDemoServer = interface(IAppServer)
    ['{288532F6-B3AC-4D26-9133-53FAE292F51A}']
  end;

// *********************************************************************//
// DispIntf:  IFIBPlusDemoServerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {288532F6-B3AC-4D26-9133-53FAE292F51A}
// *********************************************************************//
  IFIBPlusDemoServerDisp = dispinterface
    ['{288532F6-B3AC-4D26-9133-53FAE292F51A}']
    function  AS_ApplyUpdates(const ProviderName: WideString; Delta: OleVariant; 
                              MaxErrors: Integer; out ErrorCount: Integer; var OwnerData: OleVariant): OleVariant; dispid 20000000;
    function  AS_GetRecords(const ProviderName: WideString; Count: Integer; out RecsOut: Integer; 
                            Options: Integer; const CommandText: WideString; 
                            var Params: OleVariant; var OwnerData: OleVariant): OleVariant; dispid 20000001;
    function  AS_DataRequest(const ProviderName: WideString; Data: OleVariant): OleVariant; dispid 20000002;
    function  AS_GetProviderNames: OleVariant; dispid 20000003;
    function  AS_GetParams(const ProviderName: WideString; var OwnerData: OleVariant): OleVariant; dispid 20000004;
    function  AS_RowRequest(const ProviderName: WideString; Row: OleVariant; RequestType: Integer; 
                            var OwnerData: OleVariant): OleVariant; dispid 20000005;
    procedure AS_Execute(const ProviderName: WideString; const CommandText: WideString; 
                         var Params: OleVariant; var OwnerData: OleVariant); dispid 20000006;
  end;

// *********************************************************************//
// The Class CoFIBPlusDemoServer provides a Create and CreateRemote method to          
// create instances of the default interface IFIBPlusDemoServer exposed by              
// the CoClass FIBPlusDemoServer. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoFIBPlusDemoServer = class
    class function Create: IFIBPlusDemoServer;
    class function CreateRemote(const MachineName: string): IFIBPlusDemoServer;
  end;

implementation

uses ComObj;

class function CoFIBPlusDemoServer.Create: IFIBPlusDemoServer;
begin
  Result := CreateComObject(CLASS_FIBPlusDemoServer) as IFIBPlusDemoServer;
end;

class function CoFIBPlusDemoServer.CreateRemote(const MachineName: string): IFIBPlusDemoServer;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FIBPlusDemoServer) as IFIBPlusDemoServer;
end;

end.
