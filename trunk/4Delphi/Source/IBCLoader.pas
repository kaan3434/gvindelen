
//////////////////////////////////////////////////
//  InterBase Data Access Components
//  Copyright © 2006-2011 Devart. All right reserved.
//////////////////////////////////////////////////

{$IFNDEF CLR}
{$IFNDEF UNIDACPRO}
{$I IbDac.inc}
unit IBCLoader;
{$ENDIF}
{$ENDIF}

interface

uses
{$IFDEF VER6P}
  Variants,
{$ENDIF}
  Classes, SysUtils, DB,
  MemUtils, MemData, {$IFDEF FPC}MemDataSet{$ELSE}MemDS{$ENDIF},
  CRAccess, DBAccess, DALoader,
  IBC, IBCServices, IBCClasses;

type
  TIBCInsertMode = (imInsert, imUpdateOrInsert);

{ TIBCLoaderColumn }

  TIBCLoaderColumn = class(TDAColumn)
  private
    FSize: integer;
    FPrecision: integer;
    FScale: integer;
  published
    property Size: integer read FSize write FSize default 0;
    property Precision: integer read FPrecision write FPrecision default 0;
    property Scale: integer read FScale write FScale default 0;
  end;

{ TIBCLoader }

{$IFDEF VER16P}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32)]
{$ENDIF}
  TIBCLoader = class (TDALoader)
  private
    FInsertMode: TIBCInsertMode;
    FRowsPerBatch: integer;
    function GetConnection: TIBCConnection;
    procedure SetConnection(Value: TIBCConnection);
    function GetIBCTransaction: TIBCTransaction;
    procedure SetIBCTransaction(Value: TIBCTransaction);
    procedure SetInsertMode(const Value: TIBCInsertMode);
    procedure SetRowsPerBatch(Value: integer);

  protected
    function GetInternalLoaderClass: TCRLoaderClass; override;
    procedure SetInternalLoader(Value: TCRLoader); override;
    class function GetColumnClass: TDAColumnClass; override;
    function GetDataTypesMapClass: TDataTypesMapClass; override;
    function GetTransaction: TDATransaction; override;
    procedure ReadColumn(Column: TDAColumn; CRColumn: TCRLoaderColumn); override;
    procedure WriteColumn(Column: TDAColumn; CRColumn: TCRLoaderColumn); override;

  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;

  published
    property RowsPerBatch: integer read FRowsPerBatch write SetRowsPerBatch default 50;
    property InsertMode: TIBCInsertMode read FInsertMode write SetInsertMode default imInsert;
    property Connection: TIBCConnection read GetConnection write SetConnection;
    property Transaction: TIBCTransaction read GetIBCTransaction write SetIBCTransaction stored IsTransactionStored;

    property TableName;
    property Columns;
    property AutoCommit;

    property OnPutData;
    property OnGetColumnData;
    property OnProgress;
  end;

implementation

{ TIBCLoader }

constructor TIBCLoader.Create(Owner: TComponent);
begin
  inherited Create(Owner);
  FRowsPerBatch := 50;
end;

destructor TIBCLoader.Destroy;
begin
  inherited;
end;

function TIBCLoader.GetInternalLoaderClass: TCRLoaderClass;
begin
  Result := TGDSLoader;
end;

procedure TIBCLoader.SetInternalLoader(Value: TCRLoader);
begin
  inherited;

  if FILoader <> nil then begin
    FILoader.SetProp(prInsertMode, Variant(FInsertMode));
    FILoader.SetProp(prRowsPerBatch, FRowsPerBatch);
  end;
end;

class function TIBCLoader.GetColumnClass: TDAColumnClass;
begin
  Result := TIBCLoaderColumn;
end;

function TIBCLoader.GetDataTypesMapClass: TDataTypesMapClass;
begin
  Result := TIBCDataTypesMap;
end;

function TIBCLoader.GetTransaction: TDATransaction;
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

procedure TIBCLoader.ReadColumn(Column: TDAColumn; CRColumn: TCRLoaderColumn);
var
  IntCol: TGDSLoaderColumn;
begin
  inherited;

  IntCol := TGDSLoaderColumn(CRColumn);
  with TIBCLoaderColumn(Column) do begin
    Size := IntCol.Size;
    Precision := IntCol.Precision;
    Scale := IntCol.Scale;
  end;
end;

procedure TIBCLoader.WriteColumn(Column: TDAColumn; CRColumn: TCRLoaderColumn);
var
  IntCol: TGDSLoaderColumn;
begin
  inherited;

  IntCol := TGDSLoaderColumn(CRColumn);
  with TIBCLoaderColumn(Column) do begin
    IntCol.Size := Size;
    IntCol.Precision := Precision;
    IntCol.Scale := Scale;
  end;
end;

function TIBCLoader.GetConnection: TIBCConnection;
begin
  Result := TIBCConnection(inherited Connection);
end;

procedure TIBCLoader.SetConnection(Value: TIBCConnection);
begin
  inherited Connection := Value;
end;

function TIBCLoader.GetIBCTransaction: TIBCTransaction;
begin
  Result := TIBCTransaction(inherited Transaction);
end;

procedure TIBCLoader.SetIBCTransaction(Value: TIBCTransaction);
begin
  inherited Transaction := Value;
end;

procedure TIBCLoader.SetInsertMode(const Value: TIBCInsertMode);
begin
  if Value <> FInsertMode then begin
    FInsertMode := Value;
    if FILoader <> nil then
      FILoader.SetProp(prInsertMode, Variant(Value));
  end;
end;

procedure TIBCLoader.SetRowsPerBatch(Value: integer);
begin
  if Value <> FRowsPerBatch then begin
    FRowsPerBatch := Value;
    if FILoader <> nil then
      FILoader.SetProp(prRowsPerBatch, Value);
  end;
end;

end.
