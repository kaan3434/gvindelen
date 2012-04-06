
//////////////////////////////////////////////////
//  InterBase Data Access Components
//  Copyright © 2006-2011 Devart. All right reserved.
//  InterBase Alerter
//////////////////////////////////////////////////

{$IFNDEF CLR}
{$I IbDac.inc}
unit IBCAlerter;
{$ENDIF}

interface

uses
  SysUtils, Classes,
  CRTypes, MemData, CRAccess, DBAccess, DAAlerter,
  IBC, IBCCall, IBCClasses;

type
  TIBCAlertEvent = procedure(Sender: TObject; EventName: string; EventCount: Integer) of object;

{$IFDEF VER16P}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32)]
{$ENDIF}
  TIBCAlerter = class(TDAAlerter)
  private
    FOnEvent: TIBCAlertEvent;

    function GetConnection: TIBCConnection;
    procedure SetConnection(Value: TIBCConnection);
    function GetIBCTransaction: TIBCTransaction;
    procedure SetIBCTransaction(Value: TIBCTransaction);
    function GetEvents: _TStrings;
    procedure SetEvents(Value: _TStrings);
    procedure EventsChange(Sender: TObject);

  protected
    function GetInternalAlerterClass: TCRAlerterClass; override;
    procedure SetInternalAlerter(Value: TCRAlerter); override;
    function GetTransaction: TDATransaction; override;
    procedure DoOnEvent(const EventName: _string; EventCount: Integer); reintroduce;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure SendEvent(const Name: string);

  published
    property Active;
    property AutoRegister;
    property AutoCommit;

    property Connection: TIBCConnection read GetConnection write SetConnection;
    property Transaction: TIBCTransaction read GetIBCTransaction write SetIBCTransaction stored IsTransactionStored;
    property Events: _TStrings read GetEvents write SetEvents;
    property OnEvent: TIBCAlertEvent read FOnEvent write FOnEvent;
  end;

implementation

{ TIBCAlerter }

constructor TIBCAlerter.Create(AOwner: TComponent);
begin
  inherited;

  TStringList(FEvents).OnChange := EventsChange;
end;

destructor TIBCAlerter.Destroy;
begin
  Stop;
  TStringList(FEvents).OnChange := nil;

  inherited;
end;

procedure TIBCAlerter.SendEvent(const Name: string);
begin
  inherited SendEvent(Name, '');
end;

function TIBCAlerter.GetInternalAlerterClass: TCRAlerterClass;
begin
  Result := TGDSAlerter;
end;

procedure TIBCAlerter.SetInternalAlerter(Value: TCRAlerter);
begin
  inherited;

  if FIAlerter <> nil then begin
    TGDSAlerter(FIAlerter).OnEvent := DoOnEvent;
  end;
end;

function TIBCAlerter.GetTransaction: TDATransaction;
var
  vConnection: TIBCConnection;
begin
  Result := inherited GetTransaction;

  if Result = nil then begin
    vConnection := Connection;
    if (vConnection <> nil) and (vConnection.DefaultTransaction <> nil) then
      Result := vConnection.DefaultTransaction
  end;
end;

procedure TIBCAlerter.DoOnEvent(const EventName: _string; EventCount: Integer);
begin
  if Assigned(FOnEvent) then
    FOnEvent(Self, EventName, EventCount);
end;

function TIBCAlerter.GetConnection: TIBCConnection;
begin
  Result := TIBCConnection(inherited Connection);
end;

procedure TIBCAlerter.SetConnection(Value: TIBCConnection);
begin
  inherited Connection := Value;
end;

function TIBCAlerter.GetIBCTransaction: TIBCTransaction;
begin
  Result := TIBCTransaction(inherited Transaction);
end;

procedure TIBCAlerter.SetIBCTransaction(Value: TIBCTransaction);
begin
  inherited Transaction := Value;
end;

function TIBCAlerter.GetEvents: _TStrings;
begin
  Result := FEvents;
end;

procedure TIBCAlerter.SetEvents(Value: _TStrings);
begin
  FEvents.Assign(Value);
end;

procedure TIBCAlerter.EventsChange(Sender: TObject);
begin
  Stop;
  if FIAlerter <> nil then
    FIAlerter.EventNames.Assign(FEvents);
end;

initialization
{$IFDEF MSWINDOWS}
  AllocIBDACWnd;
{$ENDIF}

end.
