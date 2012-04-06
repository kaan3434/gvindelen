{$I DacDemo.inc}

unit Table;

interface

uses
  Classes, SysUtils,
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  Menus, ImgList, StdCtrls, ComCtrls, Buttons, ExtCtrls, Graphics,
  Controls, Forms, Dialogs, DBCtrls, Grids, DBGrids, IbDacVcl,
{$IFNDEF VER130}
  Variants,
{$ENDIF}
{$IFDEF FPC}
  LResources,
{$ENDIF}
  CRTypes, CRFunctions, DB, {$IFNDEF FPC}MemDS{$ELSE}MemDataSet{$ENDIF},
  DBAccess, IBC, DemoFrame, IbDacDemoForm;
  
type
  TTableFrame = class(TDemoFrame)
    DBGrid: TDBGrid;
    DataSource: TDataSource;
    btOpen: TSpeedButton;
    btClose: TSpeedButton;
    btPrepare: TSpeedButton;
    btUnPrepare: TSpeedButton;
    btExecute: TSpeedButton;
    DBNavigator: TDBNavigator;
    IBCTable: TIBCTable;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel5: TPanel;
    Label1: TLabel;
    edTableName: TEdit;
    Panel6: TPanel;
    Label2: TLabel;
    edKeyFields: TEdit;
    Panel7: TPanel;
    Label3: TLabel;
    edOrderFields: TEdit;
    Panel8: TPanel;
    Label4: TLabel;
    edFilterSQL: TEdit;
    procedure btOpenClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure btPrepareClick(Sender: TObject);
    procedure btUnPrepareClick(Sender: TObject);
    procedure btExecuteClick(Sender: TObject);
    procedure edTableNameExit(Sender: TObject);
    procedure edKeyFieldsExit(Sender: TObject);
    procedure edOrderFieldsExit(Sender: TObject);
    procedure edFilterSQLExit(Sender: TObject);
  private
    procedure ShowState;
    procedure SetTableProperties;
  public
    procedure Initialize; override;
    procedure SetDebug(Value: boolean); override;
  end;

implementation

{$IFNDEF FPC}
{$IFDEF CLR}
{$R *.nfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}
{$ENDIF}

procedure TTableFrame.ShowState;
var
  St:string;

  procedure AddSt(S:string);
  begin
    if St <> '' then
      St:= St + ', ';
    St:= St + S;
  end;

begin
  St:= '';

  if IBCTable.Prepared then begin
    AddSt('Prepared');

    if IBCTable.IsQuery then
      AddSt('IsQuery');

  end;

  if IBCTable.Active then
    AddSt('Active')
  else
    AddSt('Inactive');

  IbDacForm.StatusBar.Panels[1].Text:= St;
end;

procedure TTableFrame.SetTableProperties;
begin
  IBCTable.TableName := edTableName.Text;
  IBCTable.KeyFields := edKeyFields.Text;
  IBCTable.FilterSQL := edFilterSQL.Text;
  IBCTable.OrderFields := edOrderFields.Text;
end;

procedure TTableFrame.btOpenClick(Sender: TObject);
begin
  try
    SetTableProperties;
    IBCTable.Open;
  finally
    edKeyFields.Text:= IBCTable.KeyFields;
    ShowState;
  end;
end;

procedure TTableFrame.btCloseClick(Sender: TObject);
begin
  IBCTable.Close;
  ShowState;
end;

procedure TTableFrame.btPrepareClick(Sender: TObject);
begin
  try
    SetTableProperties;
    IBCTable.Prepare;
  finally
    edKeyFields.Text:= IBCTable.KeyFields;  
    ShowState;
  end;
end;

procedure TTableFrame.btUnPrepareClick(Sender: TObject);
begin
  IBCTable.UnPrepare;
  ShowState;
end;

procedure TTableFrame.btExecuteClick(Sender: TObject);
begin
  try
    SetTableProperties;
    IBCTable.Execute;
  finally
    edKeyFields.Text:= IBCTable.KeyFields;  
    ShowState;
  end;
end;

procedure TTableFrame.edTableNameExit(Sender: TObject);
begin
  IBCTable.TableName:= edTableName.Text;
  edKeyFields.Text:= IBCTable.KeyFields;
  ShowState;
end;

procedure TTableFrame.edKeyFieldsExit(Sender: TObject);
begin
  IBCTable.KeyFields:= edKeyFields.Text;
  ShowState;
end;

procedure TTableFrame.edOrderFieldsExit(Sender: TObject);
begin
  IBCTable.OrderFields:= edOrderFields.Text;
  edKeyFields.Text:= IBCTable.KeyFields;
  ShowState;
end;

procedure TTableFrame.edFilterSQLExit(Sender: TObject);
begin
  try
    IBCTable.FilterSQL:= edFilterSQL.Text;
  finally
    edFilterSQL.Text:= IBCTable.FilterSQL;
    ShowState;
  end;
end;

procedure TTableFrame.Initialize;
begin
  IBCTable.Connection := TIBCConnection(Connection);
  
  edTableName.Text := IBCTable.TableName;
  edKeyFields.Text := IBCTable.KeyFields;
  edOrderFields.Text := IBCTable.OrderFields;
  edFilterSQL.Text := IBCTable.FilterSQL;
  ShowState;
end;

procedure TTableFrame.SetDebug(Value: boolean);
begin
  IBCTable.Debug := Value;
end;

{$IFDEF FPC}
initialization
  {$i Table.lrs}
{$ENDIF}

end.
