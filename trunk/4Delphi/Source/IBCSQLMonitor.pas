
//////////////////////////////////////////////////
//  InterBase Data Access Components
//  Copyright © 1998-2011 Devart. All right reserved.
//  SQLMonitor supports
//////////////////////////////////////////////////

{$IFNDEF CLR}
{$I IbDac.inc}
unit IBCSQLMonitor;
{$ENDIF}

interface

uses
  SysUtils, Classes, DB,
  CRTypes, {$IFNDEF FPC}MemDS{$ELSE}MemDataSet{$ENDIF},
  DBAccess, DASQLMonitor, DBMonitorClient, IBC;

type
  TIBCSQLMonitorClass = class of TIBCSQLMonitor;

{$IFDEF VER16P}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32)]
{$ENDIF}
  TIBCSQLMonitor = class(TCustomDASQLMonitor)
  private
  protected
    class function GetMonitor: TCustomDASQLMonitor; override;
    procedure SetMonitor; override;    
    function GetParent(Obj: TObject): TObject; override;
    function GetObjectType(Obj: TObject): integer; override;

  {$IFNDEF STD}
    procedure InternalServiceAttach(Obj: TObject; BeforeEvent: boolean; var MessageID: Cardinal);
    procedure InternalServiceDetach(Obj: TObject; BeforeEvent: boolean; var MessageID: Cardinal);
    procedure InternalServiceQuery(Obj: TObject; BeforeEvent: boolean; var MessageID: Cardinal);
    procedure InternalServiceStart(Obj: TObject; BeforeEvent: boolean; var MessageID: Cardinal);
  {$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    class function GetParamDataType(Param: TDAParam): string; override;
    class function GetDataType(DataType: integer): string;
    class function GetParamValue(Param: TDAParam): string; override;
    class function GetCaption: string; override;

  {$IFNDEF STD}
    class procedure ServiceAttach(Obj: TObject; var MessageID: Cardinal; BeforeEvent: boolean);
    class procedure ServiceDetach(Obj: TObject; var MessageID: Cardinal; BeforeEvent: boolean);
    class procedure ServiceQuery(Obj: TObject; var MessageID: Cardinal; BeforeEvent: boolean);
    class procedure ServiceStart(Obj: TObject; var MessageID: Cardinal; BeforeEvent: boolean);
  {$ENDIF}
  published
    property Active;
    property Options;
    property DBMonitorOptions;
    property TraceFlags;
    property OnSQL;
  end;

implementation

uses
{$IFNDEF STD}
  IBCAdmin,
{$ENDIF}
  IBCArray;

var
  IBCMonitor: TIBCSQLMonitor;

{ TIBCSQLMonitor }

const
  FieldTypeNames: array[0..37] of string = (
    'Unknown', 'VARCHAR', '', 'INTEGER', '', 'BOOLEAN', 'FLOAT',
    'NUMERIC', 'NUMERIC', 'DATE', 'TIME', 'TIMESTAMP', '', '',
    '', '', '', '', '', '',
    '', '', '', 'CHAR', 'VARCHAR',
    'INTEGER', '', '', '', '', '', '',
    '', '', '', '', 'TIMESTAMP', 'NUMERIC');

class function TIBCSQLMonitor.GetDataType(DataType: integer): string;
begin
  Result := '';
  if (DataType = Integer(ftFixedWideChar)) or (DataType = Integer(ftFixedChar)) then
    Result := 'CHAR'
  else
  if (DataType = Integer(ftString)) or (DataType = Integer(ftWideString)) then
    Result := 'VARCHAR'
  else
  if (DataType = Integer(ftAdt)) or (DataType = Integer(ftArray)) or
    (DataType = ftIBCArray) then
    Result := 'ARRAY'
  else
  if DataType <= High(FieldTypeNames) then
    Result := FieldTypeNames[DataType];
end;

class function TIBCSQLMonitor.GetParamDataType(Param: TDAParam): string;
begin
  Result := GetDataType(Integer(Param.DataType));
  if (Param.DataType in [ftString, ftFixedChar, ftWideString]) or
    (Integer(Param.DataType) = Integer(ftFixedWideChar))
  then
    Result := Result + '[' + IntToStr(Length(Param.AsString)) + ']';
end;

class function TIBCSQLMonitor.GetParamValue(Param: TDAParam): string;
var
  i: integer;
  vArray: TIBCArray;

begin
  Result := '';
  if Param.IsNull then
    Result := '<NULL>'
  else
    case Integer(Param.DataType) of
      Integer(ftDate):
        Result := DateToStr(Param.AsDate);
      Integer(ftTime):
        Result := TimeToStr(Param.AsTime);
      Integer(ftDateTime):
        Result := DateTimeToStr(Param.AsDateTime);
      Integer(ftADT), Integer(ftArray), ftIBCArray:
        if Param is TIBCParam then begin
          vArray := TIBCParam(Param).AsArray;
          if vArray <> nil then
            with vArray do begin
              Result := '<ARRAY: ' + GetDataType(Integer(ItemType)) + '[';
              if Cached then
                for i := 0 to CachedDimensions - 1 do begin
                  Result := Result + Format('%d..%d',[CachedLowBound[i], CachedHighBound[i]]);
                  if i < (CachedDimensions - 1) then
                    Result := Result + ', ';
                end
              else
                for i := 0 to ArrayDimensions - 1 do begin
                  Result := Result + Format('%d..%d',[ArrayLowBound[i], ArrayHighBound[i]]);
                  if i < (ArrayDimensions - 1) then
                    Result := Result + ', ';
                end;
              Result := Result + ']>';
            end;
        end;    
      else
        Result := inherited GetParamValue(Param);
    end;
end;

class function TIBCSQLMonitor.GetMonitor: TCustomDASQLMonitor;
begin
  Result := IBCMonitor;
end;

procedure TIBCSQLMonitor.SetMonitor;
begin
  if IBCMonitor = nil then
    IBCMonitor := Self;
end;

class function TIBCSQLMonitor.GetCaption: string;
begin
  Result := 'IBDAC';
end;

function TIBCSQLMonitor.GetParent(Obj: TObject): TObject;
begin
  if (Obj is TIBCSQL) then
    Result := TDBAccessUtils.UsedTransaction(TIBCSQL(Obj))
  else
  if (Obj is TCustomIBCDataset) then
    Result := TDBAccessUtils.UsedTransaction(TCustomIBCDataset(Obj))
  else
    Result := inherited GetParent(Obj);
end;

function TIBCSQLMonitor.GetObjectType(Obj: TObject): integer;
begin
{$IFNDEF STD}
  if (Obj is TCustomIBCService) then
    Result := OT_CONNECTION
  else
{$ENDIF}
    Result := inherited GetObjectType(Obj);
end;

constructor TIBCSQLMonitor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TIBCSQLMonitor.Destroy;
begin
  if IBCMonitor = Self then
    IBCMonitor := nil;

  inherited;
end;

{$IFNDEF STD}
class procedure TIBCSQLMonitor.ServiceAttach(Obj: TObject; var MessageID: Cardinal; BeforeEvent: boolean);
begin
  if Assigned(IBCMonitor) then
    IBCMonitor.InternalServiceAttach(Obj, BeforeEvent, MessageID);
end;

class procedure TIBCSQLMonitor.ServiceDetach(Obj: TObject; var MessageID: Cardinal; BeforeEvent: boolean);
begin
  if Assigned(IBCMonitor) then
    IBCMonitor.InternalServiceDetach(Obj, BeforeEvent, MessageID);
end;

class procedure TIBCSQLMonitor.ServiceQuery(Obj: TObject; var MessageID: Cardinal; BeforeEvent: boolean);
begin
  if Assigned(IBCMonitor) then
    IBCMonitor.InternalServiceQuery(Obj, BeforeEvent, MessageID);
end;

class procedure TIBCSQLMonitor.ServiceStart(Obj: TObject; var MessageID: Cardinal; BeforeEvent: boolean);
begin
  if Assigned(IBCMonitor) then
    IBCMonitor.InternalServiceStart(Obj, BeforeEvent, MessageID);
end;

procedure TIBCSQLMonitor.InternalServiceAttach(Obj: TObject; BeforeEvent: boolean; var MessageID: Cardinal);
var
  St: _string;
  Service: TCustomIBCService;
begin
  CheckActive;

  if Active and (tfConnect in TraceFlags) then begin
    Service := TCustomIBCService(Obj);
    St := 'Service attach: ' + Service.Username + '@' + Service.Server + GetObjectHandle(Obj);

    if (moSQLMonitor in Options) and BeforeEvent then
      AddStatement(St);

    if moDBMonitor in Options then
      SendDBMonitorEvent(BeforeEvent, ET_CONNECT, St, Obj, '',
        nil, False, '', MessageID);

    if Assigned(FOnSQLEvent) and BeforeEvent then
      FOnSQLEvent(Obj, St, tfConnect);
  end;
end;

procedure TIBCSQLMonitor.InternalServiceDetach(Obj: TObject; BeforeEvent: boolean; var MessageID: Cardinal);
var
  St: _string;
  Service: TCustomIBCService;
begin
  CheckActive;

  if Active and (tfConnect in TraceFlags) then begin
    Service := TCustomIBCService(Obj);
    St := 'Service detach: ' + Service.Username + '@' + Service.Server + GetObjectHandle(Obj);

    if (moSQLMonitor in Options) and BeforeEvent then
      AddStatement(St);

    if moDBMonitor in Options then
      SendDBMonitorEvent(BeforeEvent, ET_DISCONNECT, St, Obj, '',
        nil, False, '', MessageID);

    if Assigned(FOnSQLEvent) and BeforeEvent then
      FOnSQLEvent(Obj, St, tfConnect);
  end;
end;

procedure TIBCSQLMonitor.InternalServiceQuery(Obj: TObject; BeforeEvent: boolean; var MessageID: Cardinal);
var
  St: _string;
begin
  CheckActive;

  if Active and (tfMisc in TraceFlags) then begin
    St := 'Service query' + GetObjectHandle(Obj);

    if (moSQLMonitor in Options) and BeforeEvent then
      AddStatement(St);

    if moDBMonitor in Options then
      SendDBMonitorEvent(BeforeEvent, ET_MISC, St, Obj, '',
        nil, False, '', MessageID);

    if Assigned(FOnSQLEvent) and BeforeEvent then
      FOnSQLEvent(Obj, St, tfMisc);
  end;
end;

procedure TIBCSQLMonitor.InternalServiceStart(Obj: TObject; BeforeEvent: boolean; var MessageID: Cardinal);
var
  St: _string;
begin
  CheckActive;

  if Active and (tfMisc in TraceFlags) then begin
    St := 'Service start' + GetObjectHandle(Obj);

    if (moSQLMonitor in Options) and BeforeEvent then
      AddStatement(St);

    if moDBMonitor in Options then
      SendDBMonitorEvent(BeforeEvent, ET_MISC, St, Obj, '',
        nil, False, '', MessageID);

    if Assigned(FOnSQLEvent) and BeforeEvent then
      FOnSQLEvent(Obj, St, tfMisc);
  end;
end;
{$ENDIF}


end.
