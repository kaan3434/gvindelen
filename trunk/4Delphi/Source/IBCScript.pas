
//////////////////////////////////////////////////
//  InterBase Data Access Components
//  Copyright © 1998-2011 Devart. All right reserved.
//  IBCScript
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I IbDac.inc}

unit IBCScript;
{$ENDIF}

interface

uses
  Classes, SysUtils,
{$IFDEF VER6P}
  Variants,
{$ENDIF}
  MemUtils, DAScript, IBCParser, CRParser, IBC, DBAccess, IBCClasses,
  IBCError, IBCScriptProcessor;

type
{$IFDEF VER16P}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32)]
{$ENDIF}
  TIBCScript = class(TDAScript)
  private
    FAutoDDL: boolean;

    function GetTransaction: TIBCTransaction;
    procedure SetTransaction(const Value: TIBCTransaction);
    procedure SetAutoDDL(Value: boolean);

  protected
    function GetProcessorClass: TDAScriptProcessorClass; override;
    procedure SetProcessor(Value: TDAScriptProcessor); override;
    function GetConnection: TIBCConnection;
    procedure SetConnection(Value: TIBCConnection);
    procedure AssignTo(Dest: TPersistent); override;
    function GetDataSet: TCustomIBCDataSet;
    procedure SetDataSet(Value: TCustomIBCDataSet);
    function GetParams: TIBCParams;
    function CreateCommand: TCustomDASQL; override;

  public
    constructor Create(Owner: TComponent); override;

    property Params: TIBCParams read GetParams;
  published
    property AutoCommit;
    property AutoDDL: Boolean read FAutoDDL write SetAutoDDL default True;
    property Connection: TIBCConnection read GetConnection write SetConnection;
    property DataSet: TCustomIBCDataSet read GetDataSet write SetDataSet;
    property Transaction: TIBCTransaction read GetTransaction write SetTransaction stored IsTransactionStored;
  end;

  TIBCScriptProcessor = class (TCustomIBCScriptProcessor)
  protected
    procedure SetAutoDDL(Value: boolean); override;
    procedure SetDatabase(Connection: TCustomDAConnection; const Value: string); override;
    procedure SetRole(Connection: TCustomDAConnection; const Value: string); override;
    procedure SetCharset(Connection: TCustomDAConnection; const Value: string); override;
    procedure SetSQLDialect(Connection: TCustomDAConnection; Value: integer); override;
    procedure CreateDatabase(Connection: TCustomDAConnection; const Params: string); override;
    procedure DropDatabase(Connection: TCustomDAConnection); override;
  end;

implementation

uses
  DAConsts, IBCConsts, CRAccess;
  
{ TIBCScript }

constructor TIBCScript.Create(Owner: TComponent);
begin
  inherited Create(Owner);

  FAutoDDL := True;
  CheckProcessor;
  Delimiter := ';';
end;

function TIBCScript.GetProcessorClass: TDAScriptProcessorClass;
begin
  Result := TIBCScriptProcessor;
end;

procedure TIBCScript.SetProcessor(Value: TDAScriptProcessor);
begin
  inherited;

  if FProcessor <> nil then begin
    FProcessor.SetProp(prAutoDDL, FAutoDDL);
  end;
end;

function TIBCScript.GetConnection: TIBCConnection;
begin
  Result := TIBCConnection(inherited Connection);
end;

procedure TIBCScript.SetConnection(Value: TIBCConnection);
begin
  inherited SetConnection(Value);
end;

procedure TIBCScript.AssignTo(Dest: TPersistent);
begin
  if Dest is TIBCScript then begin
    TIBCScript(Dest).Transaction := TIBCTransaction(TDBAccessUtils.GetFTransaction(FCommand));
  end;
  
  inherited;
end;

function TIBCScript.GetDataSet: TCustomIBCDataSet;
begin
  Result := TCustomIBCDataSet(inherited DataSet);
end;

procedure TIBCScript.SetDataSet(Value: TCustomIBCDataSet);
begin
  inherited DataSet := Value;
end;

function TIBCScript.CreateCommand: TCustomDASQL;
begin
  Result := TIBCSQL.Create(nil);
  TIBCSQL(Result).AutoCommit := False;
end;

function TIBCScript.GetTransaction: TIBCTransaction;
begin
  Result := TIBCTransaction(inherited Transaction);
end;

procedure TIBCScript.SetTransaction(const Value: TIBCTransaction);
begin
  inherited Transaction := Value;
end;

function TIBCScript.GetParams: TIBCParams;
begin
  Result := TIBCParams(inherited Params);
end;

procedure TIBCScript.SetAutoDDL(Value: boolean);
begin
  FAutoDDL := Value;
  if FProcessor <> nil then
    FProcessor.SetProp(prAutoDDL, Value);
end;

{ TIBCScriptProcessor }

procedure TIBCScriptProcessor.SetAutoDDL(Value: boolean);
begin
  TIBCScript(FOwner).AutoDDL := Value;
end;

procedure TIBCScriptProcessor.SetDatabase(Connection: TCustomDAConnection; const Value: string);
begin
  TIBCConnection(Connection).Database := Value;
end;

procedure TIBCScriptProcessor.SetRole(Connection: TCustomDAConnection; const Value: string);
begin
  TIBCConnection(Connection).Options.Role := Value;
end;

procedure TIBCScriptProcessor.SetCharset(Connection: TCustomDAConnection; const Value: string);
begin
  TIBCConnection(Connection).Options.Charset := Value;
end;

procedure TIBCScriptProcessor.SetSQLDialect(Connection: TCustomDAConnection; Value: integer);
begin
  TIBCConnection(Connection).SQLDialect := Value;
end;

procedure TIBCScriptProcessor.CreateDatabase(Connection: TCustomDAConnection; const Params: string);
begin
  TIBCConnection(Connection).Params.Text := Params;
  TIBCConnection(Connection).CreateDatabase;
end;

procedure TIBCScriptProcessor.DropDatabase(Connection: TCustomDAConnection);
begin
  TIBCConnection(Connection).DropDatabase;
end;

end.
