
//////////////////////////////////////////////////
//  DB Access Components
//  Copyright © 1998-2011 Devart. All right reserved.
//  SQLGenerator Frame
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I IbDac.inc}

unit IBCSQLGeneratorFrame;
{$ENDIF}

interface

uses
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}
  Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls, Buttons,
{$IFDEF FPC}
  LResources,
{$ENDIF}
  Classes,  SysUtils,
  DBAccess, CRAccess,
  CRFrame, CRTabEditor, DASQLGeneratorFrame;

type
  TIBCSQLGeneratorFrame = class(TDASQLGeneratorFrame)
  protected
    FTablesInfo: TCRTablesInfo;
    FLastTablesInfoSQL: string;

    procedure GenerateSelectFromAllFields; override;
    function GetTablesInfo: TCRTablesInfo; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$IFNDEF FPC}
{$R IBCSQLGeneratorFrame.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF}

uses
  DB, DAQueryEditor, DAUpdateSQLEditor, DAUpdateSQLFrame, ibc;

constructor TIBCSQLGeneratorFrame.Create(AOwner: TComponent);
begin
  inherited;

  FTablesInfo := TCRTablesInfo.Create(TCRTableInfo);
end;

destructor TIBCSQLGeneratorFrame.Destroy;
begin
  FTablesInfo.Free;
  inherited;
end;

procedure TIBCSQLGeneratorFrame.GenerateSelectFromAllFields;
var
  IdentityField: TCRFieldDesc;
begin
  IdentityField := TDBAccessUtils.GetIdentityField(LocalDataSet);
  if (IdentityField <> nil) and (TablesInfo.IndexByName(SelectedTableName) >= 0) and
     (GenerateTableName(IdentityField) = SelectedTableName) then
    LocalDataSet.SQL.Text := 'SELECT RDB$DB_KEY, ' +
      SelectedTableName + '.* FROM ' + SelectedTableName
  else
    inherited;
end;

function TIBCSQLGeneratorFrame.GetTablesInfo: TCRTablesInfo;
var
  SQLInfo: TSQLInfo;
begin
  if FLastTablesInfoSQL <> LocalDataSet.FinalSQL then begin
    FTablesInfo.Clear;
    TDBAccessUtils.CheckIRecordSet(LocalDataSet);
    SQLInfo := TDBAccessUtils.GetSQLInfo(LocalDataSet);
    SQLInfo.ParseTablesInfo(LocalDataSet.FinalSQL, FTablesInfo);
    FLastTablesInfoSQL := LocalDataSet.FinalSQL;
  end;
  Result := FTablesInfo;
end;

end.
