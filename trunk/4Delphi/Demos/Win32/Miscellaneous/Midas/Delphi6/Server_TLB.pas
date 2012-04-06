unit Server_TLB;

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

// PASTLWTR : $Revision:   1.88  $
// File generated on 10.01.2007 12:00:34 from Type Library described below.

// *************************************************************************//
// NOTE:                                                                      
// Items guarded by $IFDEF_LIVE_SERVER_AT_DESIGN_TIME are used by properties  
// which return objects that may need to be explicitly created via a function 
// call prior to any access via the property. These items have been disabled  
// in order to prevent accidental use from within the object inspector. You   
// may enable them by defining LIVE_SERVER_AT_DESIGN_TIME or by selectively   
// removing them from the $IFDEF blocks. However, such items must still be    
// programmatically created via a method of the appropriate CoClass before    
// they can be used.                                                          
// ************************************************************************ //
// Type Lib: D:\Projects\Delphi\IbDac\Demos\Win32\Miscellaneous\Midas\Delphi5\Server.tlb (1)
// IID\LCID: {AA203823-0608-4FEA-B897-A88963E7F913}\0
// Helpfile: 
// DepndLst: 
//   (1) v1.0 Midas, (D:\WINDOWS\system32\midas.dll)
//   (2) v2.0 stdole, (D:\WINDOWS\system32\stdole2.tlb)
//   (3) v4.0 StdVCL, (D:\WINDOWS\system32\stdvcl40.dll)
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
  ServerMajorVersion = 1;
  ServerMinorVersion = 0;

  LIBID_Server: TGUID = '{AA203823-0608-4FEA-B897-A88963E7F913}';

  IID_IDatas: TGUID = '{76B7913C-0CF5-4865-8022-06B30D278DA6}';
  CLASS_Datas: TGUID = '{279E503A-FC3A-4B37-9575-5075F6ACC76C}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IDatas = interface;
  IDatasDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  Datas = IDatas;


// *********************************************************************//
// Interface: IDatas
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {76B7913C-0CF5-4865-8022-06B30D278DA6}
// *********************************************************************//
  IDatas = interface(IAppServer)
    ['{76B7913C-0CF5-4865-8022-06B30D278DA6}']
  end;

// *********************************************************************//
// DispIntf:  IDatasDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {76B7913C-0CF5-4865-8022-06B30D278DA6}
// *********************************************************************//
  IDatasDisp = dispinterface
    ['{76B7913C-0CF5-4865-8022-06B30D278DA6}']
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
// The Class CoDatas provides a Create and CreateRemote method to          
// create instances of the default interface IDatas exposed by              
// the CoClass Datas. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDatas = class
    class function Create: IDatas;
    class function CreateRemote(const MachineName: string): IDatas;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TDatas
// Help String      : Datas Object
// Default Interface: IDatas
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TDatasProperties= class;
{$ENDIF}
  TDatas = class(TOleServer)
  private
    FIntf:        IDatas;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TDatasProperties;
    function      GetServerProperties: TDatasProperties;
{$ENDIF}
    function      GetDefaultInterface: IDatas;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IDatas);
    procedure Disconnect; override;
    function  AS_ApplyUpdates(const ProviderName: WideString; Delta: OleVariant; 
                              MaxErrors: Integer; out ErrorCount: Integer; var OwnerData: OleVariant): OleVariant;
    function  AS_GetRecords(const ProviderName: WideString; Count: Integer; out RecsOut: Integer; 
                            Options: Integer; const CommandText: WideString; 
                            var Params: OleVariant; var OwnerData: OleVariant): OleVariant;
    function  AS_DataRequest(const ProviderName: WideString; Data: OleVariant): OleVariant;
    function  AS_GetProviderNames: OleVariant;
    function  AS_GetParams(const ProviderName: WideString; var OwnerData: OleVariant): OleVariant;
    function  AS_RowRequest(const ProviderName: WideString; Row: OleVariant; RequestType: Integer; 
                            var OwnerData: OleVariant): OleVariant;
    procedure AS_Execute(const ProviderName: WideString; const CommandText: WideString; 
                         var Params: OleVariant; var OwnerData: OleVariant);
    property  DefaultInterface: IDatas read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TDatasProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TDatas
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TDatasProperties = class(TPersistent)
  private
    FServer:    TDatas;
    function    GetDefaultInterface: IDatas;
    constructor Create(AServer: TDatas);
  protected
  public
    property DefaultInterface: IDatas read GetDefaultInterface;
  published
  end;
{$ENDIF}


procedure Register;

implementation

uses ComObj;

class function CoDatas.Create: IDatas;
begin
  Result := CreateComObject(CLASS_Datas) as IDatas;
end;

class function CoDatas.CreateRemote(const MachineName: string): IDatas;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Datas) as IDatas;
end;

procedure TDatas.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{279E503A-FC3A-4B37-9575-5075F6ACC76C}';
    IntfIID:   '{76B7913C-0CF5-4865-8022-06B30D278DA6}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TDatas.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IDatas;
  end;
end;

procedure TDatas.ConnectTo(svrIntf: IDatas);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TDatas.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TDatas.GetDefaultInterface: IDatas;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TDatas.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TDatasProperties.Create(Self);
{$ENDIF}
end;

destructor TDatas.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TDatas.GetServerProperties: TDatasProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function  TDatas.AS_ApplyUpdates(const ProviderName: WideString; Delta: OleVariant; 
                                 MaxErrors: Integer; out ErrorCount: Integer; 
                                 var OwnerData: OleVariant): OleVariant;
begin
  Result := DefaultInterface.AS_ApplyUpdates(ProviderName, Delta, MaxErrors, ErrorCount, OwnerData);
end;

function  TDatas.AS_GetRecords(const ProviderName: WideString; Count: Integer; 
                               out RecsOut: Integer; Options: Integer; 
                               const CommandText: WideString; var Params: OleVariant; 
                               var OwnerData: OleVariant): OleVariant;
begin
  Result := DefaultInterface.AS_GetRecords(ProviderName, Count, RecsOut, Options, CommandText, 
                                           Params, OwnerData);
end;

function  TDatas.AS_DataRequest(const ProviderName: WideString; Data: OleVariant): OleVariant;
begin
  Result := DefaultInterface.AS_DataRequest(ProviderName, Data);
end;

function  TDatas.AS_GetProviderNames: OleVariant;
begin
  Result := DefaultInterface.AS_GetProviderNames;
end;

function  TDatas.AS_GetParams(const ProviderName: WideString; var OwnerData: OleVariant): OleVariant;
begin
  Result := DefaultInterface.AS_GetParams(ProviderName, OwnerData);
end;

function  TDatas.AS_RowRequest(const ProviderName: WideString; Row: OleVariant; 
                               RequestType: Integer; var OwnerData: OleVariant): OleVariant;
begin
  Result := DefaultInterface.AS_RowRequest(ProviderName, Row, RequestType, OwnerData);
end;

procedure TDatas.AS_Execute(const ProviderName: WideString; const CommandText: WideString; 
                            var Params: OleVariant; var OwnerData: OleVariant);
begin
  DefaultInterface.AS_Execute(ProviderName, CommandText, Params, OwnerData);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TDatasProperties.Create(AServer: TDatas);
begin
  inherited Create;
  FServer := AServer;
end;

function TDatasProperties.GetDefaultInterface: IDatas;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents('Servers',[TDatas]);
end;

end.
