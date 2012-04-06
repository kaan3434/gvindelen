{$I DacDemo.inc}

unit UpdateSQL;

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
  DB, {$IFNDEF FPC}MemDS{$ELSE}MemDataSet{$ENDIF},
  DBAccess, IBC, DemoFrame;

type
  TUpdateSQLFrame = class(TDemoFrame)
    IBCQuery: TIBCQuery;
    DBGrid: TDBGrid;
    DataSource: TDataSource;
    ToolBar: TPanel;
    meSQL: TMemo;
    IBCUpdateSQL: TIBCUpdateSQL;
    btOpen: TSpeedButton;
    btClose: TSpeedButton;
    btPrepare: TSpeedButton;
    btUnPrepare: TSpeedButton;
    btExecute: TSpeedButton;
    Panel3: TPanel;
    Panel1: TPanel;
    btRefreshRecord: TSpeedButton;
    DBNavigator1: TDBNavigator;
    Splitter1: TSplitter;
    Panel6: TPanel;
    cbDeleteObject: TCheckBox;
    cbInsertObject: TCheckBox;
    cbModifyObject: TCheckBox;
    cbRefreshObject: TCheckBox;
    Panel4: TPanel;
    RefreshQuery: TIBCQuery;
    ModifyQuery: TIBCQuery;
    DeleteQuery: TIBCQuery;
    InsertQuery: TIBCQuery;
    procedure btOpenClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure btPrepareClick(Sender: TObject);
    procedure btUnPrepareClick(Sender: TObject);
    procedure btExecuteClick(Sender: TObject);
    procedure meSQLExit(Sender: TObject);
    procedure btRefreshRecordClick(Sender: TObject);
    procedure cbObjectClick(Sender: TObject);
  private
    { Private declarations }
    procedure ShowState;
  public
    procedure Initialize; override;
    procedure SetDebug(Value: boolean); override;
  end;

implementation

uses IbDacDemoForm;

{$IFNDEF FPC}
{$IFDEF CLR}
{$R *.nfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}
{$ENDIF}

procedure TUpdateSQLFrame.ShowState;
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

  if IBCQuery.Prepared then begin
    AddSt('Prepared');

    if IBCQuery.IsQuery then
      AddSt('IsQuery');
  end;

  if IBCQuery.Active then
    AddSt('Active')
  else
    AddSt('Inactive');

  if IBCQuery.Executing then
    AddSt('Executing');

  if IBCQuery.Fetching then
    AddSt('Fetching');

  IbDacForm.StatusBar.Panels[2].Text:= St;
end;

procedure TUpdateSQLFrame.meSQLExit(Sender: TObject);
begin
  if Trim(IBCQuery.SQL.Text) <> Trim(meSQL.Lines.Text) then
    IBCQuery.SQL.Text:= meSQL.Lines.Text;
  ShowState;
end;

procedure TUpdateSQLFrame.btOpenClick(Sender: TObject);
begin
  try
    IBCQuery.Open;
  finally
    ShowState;
  end;
end;

procedure TUpdateSQLFrame.btCloseClick(Sender: TObject);
begin
  IBCQuery.Close;
  ShowState;
end;

procedure TUpdateSQLFrame.btPrepareClick(Sender: TObject);
begin
  try
    IBCQuery.Prepare;
  finally
    ShowState;
  end;
end;

procedure TUpdateSQLFrame.btUnPrepareClick(Sender: TObject);
begin
  IBCQuery.UnPrepare;
  ShowState;
end;

procedure TUpdateSQLFrame.btExecuteClick(Sender: TObject);
begin
  try
    IBCQuery.Execute;
  finally
    ShowState;
  end;
end;

procedure TUpdateSQLFrame.Initialize;
begin
  IBCQuery.Connection := TIBCConnection(Connection);
  DeleteQuery.Connection := TIBCConnection(Connection);
  InsertQuery.Connection := TIBCConnection(Connection);
  ModifyQuery.Connection := TIBCConnection(Connection);
  RefreshQuery.Connection := TIBCConnection(Connection);
  
  meSQL.Lines.Assign(IBCQuery.SQL);
  ShowState;
end;

procedure TUpdateSQLFrame.btRefreshRecordClick(Sender: TObject);
begin
  IBCQuery.RefreshRecord;
end;

procedure TUpdateSQLFrame.SetDebug(Value: boolean);
begin
  IBCQuery.Debug := Value;
end;

procedure TUpdateSQLFrame.cbObjectClick(Sender: TObject);
  function GetComponent(cbObject: TCheckBox; Component: TComponent): TComponent;
  begin
    if cbObject.Checked then
      Result := Component
    else
      Result := nil;
  end;
begin
  IBCUpdateSQL.DeleteObject := GetComponent(cbDeleteObject, DeleteQuery);
  IBCUpdateSQL.InsertObject := GetComponent(cbInsertObject, InsertQuery);
  IBCUpdateSQL.ModifyObject := GetComponent(cbModifyObject, ModifyQuery);
  IBCUpdateSQL.RefreshObject := GetComponent(cbRefreshObject, RefreshQuery);
end;

{$IFDEF FPC}
initialization
  {$i UpdateSQL.lrs}
{$ENDIF}

end.
