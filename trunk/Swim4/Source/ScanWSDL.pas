// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : D:\Swim4\php\soap\Scan.wsdl
//  >Import : D:\Swim4\php\soap\Scan.wsdl>0
// Encoding : utf-8
// Version  : 1.0
// (03.05.2012 16:35:05 - - $Rev: 37707 $)
// ************************************************************************ //

unit ScanWSDL;

interface

uses InvokeRegistry, SOAPHTTPClient, Types, XSBuiltIns;

const
  IS_OPTN = $0001;
  IS_UNBD = $0002;
  IS_ATTR = $0010;
  IS_TEXT = $0020;


type

  // ************************************************************************ //
  // The following types, referred to in the WSDL document are not being represented
  // in this file. They are either aliases[@] of other types represented or were referred
  // to but never[!] declared in the document. The types from the latter category
  // typically map to predefined/known XML or Embarcadero types; however, they could also 
  // indicate incorrect WSDL documents that failed to declare or import a schema type.
  // ************************************************************************ //
  // !:anySimpleType   - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:float           - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:dateTime        - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:anyURI          - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:integer         - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:string          - "http://www.w3.org/2001/XMLSchema"[Lit][Gbl]

  TTournirsResponse    = class;                 { "http://example.com/"[Lit][GblCplx] }
  TEventsResponse      = class;                 { "http://example.com/"[Lit][GblCplx] }
  TBooker              = class;                 { "http://example.com/"[GblCplx] }
  TEvent               = class;                 { "http://example.com/"[GblCplx] }
  TBet                 = class;                 { "http://example.com/"[GblCplx] }
  TTournir             = class;                 { "http://example.com/"[GblCplx] }
  TSportsResponse      = class;                 { "http://example.com/"[Lit][GblCplx] }
  TBookersResponse     = class;                 { "http://example.com/"[Lit][GblCplx] }
  TSport               = class;                 { "http://example.com/"[GblCplx] }

  TTournirs  = array of TTournir;               { "http://example.com/"[GblCplx] }


  // ************************************************************************ //
  // XML       : TTournirsResponse, global, <complexType>
  // Namespace : http://example.com/
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  TTournirsResponse = class(TRemotable)
  private
    FTournirs: TTournirs;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property Tournirs: TTournirs  read FTournirs write FTournirs;
  end;

  Array_Of_TBet = array of TBet;                { "http://example.com/"[GblUbnd] }
  TEvents    = array of TEvent;                 { "http://example.com/"[GblCplx] }


  // ************************************************************************ //
  // XML       : TEventsResponse, global, <complexType>
  // Namespace : http://example.com/
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  TEventsResponse = class(TRemotable)
  private
    FEvents: TEvents;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property Events: TEvents  read FEvents write FEvents;
  end;

  TBookers   = array of TBooker;                { "http://example.com/"[GblCplx] }


  // ************************************************************************ //
  // XML       : TBooker, global, <complexType>
  // Namespace : http://example.com/
  // ************************************************************************ //
  TBooker = class(TRemotable)
  private
    FText: string;
    FId: Int64;
    FSign: string;
    FTitle: string;
    FUrl: string;
    FUrl_Specified: boolean;
    procedure SetUrl(Index: Integer; const Astring: string);
    function  Url_Specified(Index: Integer): boolean;
  published
    property Text:  string  Index (IS_TEXT) read FText write FText;
    property Id:    Int64   Index (IS_ATTR) read FId write FId;
    property Sign:  string  Index (IS_ATTR) read FSign write FSign;
    property Title: string  Index (IS_ATTR) read FTitle write FTitle;
    property Url:   string  Index (IS_ATTR or IS_OPTN) read FUrl write SetUrl stored Url_Specified;
  end;



  // ************************************************************************ //
  // XML       : TEvent, global, <complexType>
  // Namespace : http://example.com/
  // ************************************************************************ //
  TEvent = class(TRemotable)
  private
    FId: string;
    FId_Specified: boolean;
    FDateTime: TXSDateTime;
    FDateTime_Specified: boolean;
    FGamer1_Name: string;
    FGamer1_Name_Specified: boolean;
    FGamer2_Name: string;
    FGamer2_Name_Specified: boolean;
    FBet: Array_Of_TBet;
    FBet_Specified: boolean;
    procedure SetId(Index: Integer; const Astring: string);
    function  Id_Specified(Index: Integer): boolean;
    procedure SetDateTime(Index: Integer; const ATXSDateTime: TXSDateTime);
    function  DateTime_Specified(Index: Integer): boolean;
    procedure SetGamer1_Name(Index: Integer; const Astring: string);
    function  Gamer1_Name_Specified(Index: Integer): boolean;
    procedure SetGamer2_Name(Index: Integer; const Astring: string);
    function  Gamer2_Name_Specified(Index: Integer): boolean;
    procedure SetBet(Index: Integer; const AArray_Of_TBet: Array_Of_TBet);
    function  Bet_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property Id:          string         Index (IS_ATTR or IS_OPTN) read FId write SetId stored Id_Specified;
    property DateTime:    TXSDateTime    Index (IS_ATTR or IS_OPTN) read FDateTime write SetDateTime stored DateTime_Specified;
    property Gamer1_Name: string         Index (IS_ATTR or IS_OPTN) read FGamer1_Name write SetGamer1_Name stored Gamer1_Name_Specified;
    property Gamer2_Name: string         Index (IS_ATTR or IS_OPTN) read FGamer2_Name write SetGamer2_Name stored Gamer2_Name_Specified;
    property Bet:         Array_Of_TBet  Index (IS_OPTN or IS_UNBD) read FBet write SetBet stored Bet_Specified;
  end;



  // ************************************************************************ //
  // XML       : TBet, global, <complexType>
  // Namespace : http://example.com/
  // ************************************************************************ //
  TBet = class(TRemotable)
  private
    FText: Variant;
    FPeriod: string;
    FKind: string;
    FSubject: string;
    FSubject_Specified: boolean;
    FGamer: string;
    FGamer_Specified: boolean;
    FValue: string;
    FValue_Specified: boolean;
    FModifier: string;
    FModifier_Specified: boolean;
    FKoef: Single;
    FKoef_Specified: boolean;
    procedure SetSubject(Index: Integer; const Astring: string);
    function  Subject_Specified(Index: Integer): boolean;
    procedure SetGamer(Index: Integer; const Astring: string);
    function  Gamer_Specified(Index: Integer): boolean;
    procedure SetValue(Index: Integer; const Astring: string);
    function  Value_Specified(Index: Integer): boolean;
    procedure SetModifier(Index: Integer; const Astring: string);
    function  Modifier_Specified(Index: Integer): boolean;
    procedure SetKoef(Index: Integer; const ASingle: Single);
    function  Koef_Specified(Index: Integer): boolean;
  published
    property Text:     Variant  Index (IS_TEXT) read FText write FText;
    property Period:   string   Index (IS_ATTR) read FPeriod write FPeriod;
    property Kind:     string   Index (IS_ATTR) read FKind write FKind;
    property Subject:  string   Index (IS_ATTR or IS_OPTN) read FSubject write SetSubject stored Subject_Specified;
    property Gamer:    string   Index (IS_ATTR or IS_OPTN) read FGamer write SetGamer stored Gamer_Specified;
    property Value:    string   Index (IS_ATTR or IS_OPTN) read FValue write SetValue stored Value_Specified;
    property Modifier: string   Index (IS_ATTR or IS_OPTN) read FModifier write SetModifier stored Modifier_Specified;
    property Koef:     Single   Index (IS_ATTR or IS_OPTN) read FKoef write SetKoef stored Koef_Specified;
  end;



  // ************************************************************************ //
  // XML       : TTournir, global, <complexType>
  // Namespace : http://example.com/
  // ************************************************************************ //
  TTournir = class(TRemotable)
  private
    FText: string;
    FId: string;
    FId_Specified: boolean;
    FRegion: string;
    FRegion_Specified: boolean;
    FTitle: string;
    FUrl: string;
    FUrl_Specified: boolean;
    procedure SetId(Index: Integer; const Astring: string);
    function  Id_Specified(Index: Integer): boolean;
    procedure SetRegion(Index: Integer; const Astring: string);
    function  Region_Specified(Index: Integer): boolean;
    procedure SetUrl(Index: Integer; const Astring: string);
    function  Url_Specified(Index: Integer): boolean;
  published
    property Text:   string  Index (IS_TEXT) read FText write FText;
    property Id:     string  Index (IS_ATTR or IS_OPTN) read FId write SetId stored Id_Specified;
    property Region: string  Index (IS_ATTR or IS_OPTN) read FRegion write SetRegion stored Region_Specified;
    property Title:  string  Index (IS_ATTR) read FTitle write FTitle;
    property Url:    string  Index (IS_ATTR or IS_OPTN) read FUrl write SetUrl stored Url_Specified;
  end;

  TSports    = array of TSport;                 { "http://example.com/"[GblCplx] }


  // ************************************************************************ //
  // XML       : TSportsResponse, global, <complexType>
  // Namespace : http://example.com/
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  TSportsResponse = class(TRemotable)
  private
    FSports: TSports;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property Sports: TSports  read FSports write FSports;
  end;



  // ************************************************************************ //
  // XML       : TBookersResponse, global, <complexType>
  // Namespace : http://example.com/
  // Serializtn: [xoLiteralParam]
  // Info      : Wrapper
  // ************************************************************************ //
  TBookersResponse = class(TRemotable)
  private
    FBookers: TBookers;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property Bookers: TBookers  read FBookers write FBookers;
  end;



  // ************************************************************************ //
  // XML       : TSport, global, <complexType>
  // Namespace : http://example.com/
  // ************************************************************************ //
  TSport = class(TRemotable)
  private
    FText: string;
    FId: Int64;
    FSign: string;
    FTitle: string;
    FUrl: string;
  published
    property Text:  string  Index (IS_TEXT) read FText write FText;
    property Id:    Int64   Index (IS_ATTR) read FId write FId;
    property Sign:  string  Index (IS_ATTR) read FSign write FSign;
    property Title: string  Index (IS_ATTR) read FTitle write FTitle;
    property Url:   string  Index (IS_ATTR) read FUrl write FUrl;
  end;


  // ************************************************************************ //
  // Namespace : http://example.com/
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : rpc
  // use       : literal
  // binding   : ScanBinding
  // service   : ScanService
  // port      : ScanPort
  // URL       : http://localhost:8080/soap/ScanBooker.php
  // ************************************************************************ //
  TScanPort = interface(IInvokable)
  ['{DA8126F7-F4F8-C40F-E8F5-D147645BF057}']

    // Cannot unwrap: 
    //     - Input part does not refer to an element
    //     - Output part does not refer to an element
    function  getBookers(const UserSign: string): TBookersResponse; stdcall;

    // Cannot unwrap: 
    //     - Input part does not refer to an element
    //     - Output part does not refer to an element
    function  getSports(const BookerSignPart: string): TSportsResponse; stdcall;

    // Cannot unwrap: 
    //     - Input message has more than one part
    //     - Output part does not refer to an element
    function  getTournirs(const BookerSignPart: string; const SportIdPart: Int64): TTournirsResponse; stdcall;

    // Cannot unwrap: 
    //     - Input message has more than one part
    //     - Output part does not refer to an element
    function  getEvents(const BookerSignPart: string; const SportIdPart: Int64; const TournirIdPart: string; const TournirUrlPart: string): TEventsResponse; stdcall;
  end;

function GetTScanPort(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): TScanPort;


implementation
  uses SysUtils;

function GetTScanPort(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): TScanPort;
const
  defWSDL = 'D:\Swim4\php\soap\Scan.wsdl';
  defURL  = 'http://localhost:8080/soap/ScanBooker.php';
  defSvc  = 'ScanService';
  defPrt  = 'ScanPort';
var
  RIO: THTTPRIO;
begin
  Result := nil;
  if (Addr = '') then
  begin
    if UseWSDL then
      Addr := defWSDL
    else
      Addr := defURL;
  end;
  if HTTPRIO = nil then
    RIO := THTTPRIO.Create(nil)
  else
    RIO := HTTPRIO;
  try
    Result := (RIO as TScanPort);
    if UseWSDL then
    begin
      RIO.WSDLLocation := Addr;
      RIO.Service := defSvc;
      RIO.Port := defPrt;
    end else
      RIO.URL := Addr;
  finally
    if (Result = nil) and (HTTPRIO = nil) then
      RIO.Free;
  end;
end;


constructor TTournirsResponse.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor TTournirsResponse.Destroy;
var
  I: Integer;
begin
  for I := 0 to System.Length(FTournirs)-1 do
    SysUtils.FreeAndNil(FTournirs[I]);
  System.SetLength(FTournirs, 0);
  inherited Destroy;
end;

constructor TEventsResponse.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor TEventsResponse.Destroy;
var
  I: Integer;
begin
  for I := 0 to System.Length(FEvents)-1 do
    SysUtils.FreeAndNil(FEvents[I]);
  System.SetLength(FEvents, 0);
  inherited Destroy;
end;

procedure TBooker.SetUrl(Index: Integer; const Astring: string);
begin
  FUrl := Astring;
  FUrl_Specified := True;
end;

function TBooker.Url_Specified(Index: Integer): boolean;
begin
  Result := FUrl_Specified;
end;

destructor TEvent.Destroy;
var
  I: Integer;
begin
  for I := 0 to System.Length(FBet)-1 do
    SysUtils.FreeAndNil(FBet[I]);
  System.SetLength(FBet, 0);
  SysUtils.FreeAndNil(FDateTime);
  inherited Destroy;
end;

procedure TEvent.SetId(Index: Integer; const Astring: string);
begin
  FId := Astring;
  FId_Specified := True;
end;

function TEvent.Id_Specified(Index: Integer): boolean;
begin
  Result := FId_Specified;
end;

procedure TEvent.SetDateTime(Index: Integer; const ATXSDateTime: TXSDateTime);
begin
  FDateTime := ATXSDateTime;
  FDateTime_Specified := True;
end;

function TEvent.DateTime_Specified(Index: Integer): boolean;
begin
  Result := FDateTime_Specified;
end;

procedure TEvent.SetGamer1_Name(Index: Integer; const Astring: string);
begin
  FGamer1_Name := Astring;
  FGamer1_Name_Specified := True;
end;

function TEvent.Gamer1_Name_Specified(Index: Integer): boolean;
begin
  Result := FGamer1_Name_Specified;
end;

procedure TEvent.SetGamer2_Name(Index: Integer; const Astring: string);
begin
  FGamer2_Name := Astring;
  FGamer2_Name_Specified := True;
end;

function TEvent.Gamer2_Name_Specified(Index: Integer): boolean;
begin
  Result := FGamer2_Name_Specified;
end;

procedure TEvent.SetBet(Index: Integer; const AArray_Of_TBet: Array_Of_TBet);
begin
  FBet := AArray_Of_TBet;
  FBet_Specified := True;
end;

function TEvent.Bet_Specified(Index: Integer): boolean;
begin
  Result := FBet_Specified;
end;

procedure TBet.SetSubject(Index: Integer; const Astring: string);
begin
  FSubject := Astring;
  FSubject_Specified := True;
end;

function TBet.Subject_Specified(Index: Integer): boolean;
begin
  Result := FSubject_Specified;
end;

procedure TBet.SetGamer(Index: Integer; const Astring: string);
begin
  FGamer := Astring;
  FGamer_Specified := True;
end;

function TBet.Gamer_Specified(Index: Integer): boolean;
begin
  Result := FGamer_Specified;
end;

procedure TBet.SetValue(Index: Integer; const Astring: string);
begin
  FValue := Astring;
  FValue_Specified := True;
end;

function TBet.Value_Specified(Index: Integer): boolean;
begin
  Result := FValue_Specified;
end;

procedure TBet.SetModifier(Index: Integer; const Astring: string);
begin
  FModifier := Astring;
  FModifier_Specified := True;
end;

function TBet.Modifier_Specified(Index: Integer): boolean;
begin
  Result := FModifier_Specified;
end;

procedure TBet.SetKoef(Index: Integer; const ASingle: Single);
begin
  FKoef := ASingle;
  FKoef_Specified := True;
end;

function TBet.Koef_Specified(Index: Integer): boolean;
begin
  Result := FKoef_Specified;
end;

procedure TTournir.SetId(Index: Integer; const Astring: string);
begin
  FId := Astring;
  FId_Specified := True;
end;

function TTournir.Id_Specified(Index: Integer): boolean;
begin
  Result := FId_Specified;
end;

procedure TTournir.SetRegion(Index: Integer; const Astring: string);
begin
  FRegion := Astring;
  FRegion_Specified := True;
end;

function TTournir.Region_Specified(Index: Integer): boolean;
begin
  Result := FRegion_Specified;
end;

procedure TTournir.SetUrl(Index: Integer; const Astring: string);
begin
  FUrl := Astring;
  FUrl_Specified := True;
end;

function TTournir.Url_Specified(Index: Integer): boolean;
begin
  Result := FUrl_Specified;
end;

constructor TSportsResponse.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor TSportsResponse.Destroy;
var
  I: Integer;
begin
  for I := 0 to System.Length(FSports)-1 do
    SysUtils.FreeAndNil(FSports[I]);
  System.SetLength(FSports, 0);
  inherited Destroy;
end;

constructor TBookersResponse.Create;
begin
  inherited Create;
  FSerializationOptions := [xoLiteralParam];
end;

destructor TBookersResponse.Destroy;
var
  I: Integer;
begin
  for I := 0 to System.Length(FBookers)-1 do
    SysUtils.FreeAndNil(FBookers[I]);
  System.SetLength(FBookers, 0);
  inherited Destroy;
end;

initialization
  { TScanPort }
  InvRegistry.RegisterInterface(TypeInfo(TScanPort), 'http://example.com/', 'utf-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(TScanPort), '');
  InvRegistry.RegisterInvokeOptions(TypeInfo(TScanPort), ioLiteral);
  { TScanPort.getBookers }
  InvRegistry.RegisterParamInfo(TypeInfo(TScanPort), 'getBookers', 'BookersResponse', '',
                                '[Namespace="http://example.com/"]');
  { TScanPort.getSports }
  InvRegistry.RegisterParamInfo(TypeInfo(TScanPort), 'getSports', 'SportsResponsePart', '',
                                '[Namespace="http://example.com/"]');
  { TScanPort.getTournirs }
  InvRegistry.RegisterParamInfo(TypeInfo(TScanPort), 'getTournirs', 'TournirResponse', '',
                                '[Namespace="http://example.com/"]');
  { TScanPort.getEvents }
  InvRegistry.RegisterParamInfo(TypeInfo(TScanPort), 'getEvents', 'EventsResponsePart', '',
                                '[Namespace="http://example.com/"]');
  RemClassRegistry.RegisterXSInfo(TypeInfo(TTournirs), 'http://example.com/', 'TTournirs');
  RemClassRegistry.RegisterXSClass(TTournirsResponse, 'http://example.com/', 'TTournirsResponse');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(TTournirsResponse), 'Tournirs', '[ArrayItemName="Tournir"]');
  RemClassRegistry.RegisterSerializeOptions(TTournirsResponse, [xoLiteralParam]);
  RemClassRegistry.RegisterXSInfo(TypeInfo(Array_Of_TBet), 'http://example.com/', 'Array_Of_TBet');
  RemClassRegistry.RegisterXSInfo(TypeInfo(TEvents), 'http://example.com/', 'TEvents');
  RemClassRegistry.RegisterXSClass(TEventsResponse, 'http://example.com/', 'TEventsResponse');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(TEventsResponse), 'Events', '[ArrayItemName="Event"]');
  RemClassRegistry.RegisterSerializeOptions(TEventsResponse, [xoLiteralParam]);
  RemClassRegistry.RegisterXSInfo(TypeInfo(TBookers), 'http://example.com/', 'TBookers');
  RemClassRegistry.RegisterXSClass(TBooker, 'http://example.com/', 'TBooker');
  RemClassRegistry.RegisterXSClass(TEvent, 'http://example.com/', 'TEvent');
  RemClassRegistry.RegisterXSClass(TBet, 'http://example.com/', 'TBet');
  RemClassRegistry.RegisterXSClass(TTournir, 'http://example.com/', 'TTournir');
  RemClassRegistry.RegisterXSInfo(TypeInfo(TSports), 'http://example.com/', 'TSports');
  RemClassRegistry.RegisterXSClass(TSportsResponse, 'http://example.com/', 'TSportsResponse');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(TSportsResponse), 'Sports', '[ArrayItemName="Sport"]');
  RemClassRegistry.RegisterSerializeOptions(TSportsResponse, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(TBookersResponse, 'http://example.com/', 'TBookersResponse');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(TBookersResponse), 'Bookers', '[ArrayItemName="Booker"]');
  RemClassRegistry.RegisterSerializeOptions(TBookersResponse, [xoLiteralParam]);
  RemClassRegistry.RegisterXSClass(TSport, 'http://example.com/', 'TSport');

end.