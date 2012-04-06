
//////////////////////////////////////////////////
//  Interbase Data Access Components
//  Copyright © 1998-2011 Devart. All right reserved.
//  Table SQL Frame 
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I IbDac.inc}

unit IBCTableSQLFrame;
{$ENDIF}

interface

uses
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}
  Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls, Buttons, ComCtrls,
{$IFDEF FPC}
  LResources,
{$ENDIF}
  Classes, SysUtils, CRTypes, DBAccess, CRFrame, CRTabEditor,
  CREditor, DATableSQLFrame;

type
  TIBCTableSQLFrame = class(TDATableSQLFrame)
    cbSystem: TCheckBox;
    lbKeyFields: TLabel;
    cbKeyFields: TComboBox;
    procedure cbSystemClick(Sender: TObject);
    procedure cbKeyFieldsExit(Sender: TObject);
    procedure cbKeyFieldsDropDown(Sender: TObject);
  protected
    procedure DoActivate; override;
  public
    constructor Create(Owner: TComponent); override;
  end;

implementation

{$IFNDEF FPC}
{$R IBCTableSQLFrame.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF}

uses
  CRFunctions, IBC;

{ TIBCTableSQLFrame }

constructor TIBCTableSQLFrame.Create(Owner: TComponent);
begin
  inherited;

{$IFDEF UNIX}
  cbKeyFields.Items.Text := ' '; // bug in TComboBox
{$ENDIF}
end;

procedure TIBCTableSQLFrame.DoActivate;
begin
  inherited;

  cbKeyFields.Text := TIBCTable(GetLocalTable).KeyFields;
end;

procedure TIBCTableSQLFrame.cbSystemClick(Sender: TObject);
begin
  FListGot := False;
  FAllTables := cbSystem.Checked;
end;

procedure TIBCTableSQLFrame.cbKeyFieldsExit(Sender: TObject);
begin
  if cbKeyFields.Text <> TIBCTable(GetLocalTable).KeyFields then begin
    TIBCTable(GetLocalTable).KeyFields := cbKeyFields.Text;
    InitSQL;
    Modified := True;
  end;
end;

procedure TIBCTableSQLFrame.cbKeyFieldsDropDown(Sender: TObject);
var
  List: _TStringList;
begin
{$IFDEF UNIX}
  cbKeyFields.OnGetItems := nil;
  try
{$ENDIF}
  if TDBAccessUtils.UsedConnection(GetLocalTable) = nil then
    Exit;

  cbKeyFields.Clear;
  try
    List := _TStringList.Create;
    try
      TIBCTable(GetLocalTable).QueryKeyFields(TIBCTable(GetLocalTable).TableName, List);
      AssignStrings(List, cbKeyFields.Items);
    finally
      List.Free;
    end;
  except
    cbKeyFields.Clear;
  {$IFDEF UNIX}
    cbKeyFields.Items.Add('');
  {$ENDIF}
    Application.HandleException(Self);
  end;
{$IFDEF UNIX}
  finally
    cbKeyFields.OnGetItems := cbKeyFieldsDropDown;
  end;
{$ENDIF}
end;

end.

