{$I DacDemo.inc}

unit Query;

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
  DBAccess, IBC, DemoFrame, IbDacDemoForm;

type
  TQueryFrame = class(TDemoFrame)
    DBGrid: TDBGrid;
    DataSource: TDataSource;
    ToolBar: TPanel;
    btOpen: TSpeedButton;
    btClose: TSpeedButton;
    btPrepare: TSpeedButton;
    btUnPrepare: TSpeedButton;
    btExecute: TSpeedButton;
    meSQL: TMemo;
    Panel1: TPanel;
    DBNavigator1: TDBNavigator;
    cbFetchAll: TCheckBox;
    btRefreshRecord: TSpeedButton;
    btShowState: TSpeedButton;
    IBCQuery: TIBCQuery;
    Panel5: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    btSaveToXML: TSpeedButton;
    SaveDialog: TSaveDialog;
    Panel4: TPanel;
    StaticText1: TLabel;
    edFetchRows: TEdit;
    procedure btOpenClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure btPrepareClick(Sender: TObject);
    procedure btUnPrepareClick(Sender: TObject);
    procedure btExecuteClick(Sender: TObject);
    procedure meSQLExit(Sender: TObject);
    procedure cbFetchAllClick(Sender: TObject);
    procedure btRefreshRecordClick(Sender: TObject);
    procedure btShowStateClick(Sender: TObject);
    procedure IBCQueryAfterExecute(Sender: TObject; Result: Boolean);
    procedure btSaveToXMLClick(Sender: TObject);
  private
    procedure ShowState;
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

procedure TQueryFrame.ShowState;
var
  St:string;

  procedure AddSt(S:string);
  begin
    if St <> '' then
      St := St + ', ';
    St := St + S;
  end;

begin
  St := '';

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

  IbDacForm.StatusBar.Panels[1].Text := St;
end;

procedure TQueryFrame.meSQLExit(Sender: TObject);
begin
  if Trim(IBCQuery.SQL.Text) <> Trim(meSQL.Lines.Text) then
    IBCQuery.SQL.Text := meSQL.Lines.Text;
  ShowState;
end;

procedure TQueryFrame.btOpenClick(Sender: TObject);
begin
  try
    IBCQuery.SQL.Text := meSQL.Lines.Text;
    IBCQuery.FetchRows := StrToInt(edFetchRows.Text);
    IBCQuery.Open;
  finally
    ShowState;
  end;
end;

procedure TQueryFrame.btCloseClick(Sender: TObject);
begin
  IBCQuery.Close;
  ShowState;
end;

procedure TQueryFrame.btPrepareClick(Sender: TObject);
begin
  try
    IBCQuery.SQL.Text := meSQL.Lines.Text;
    IBCQuery.Prepare;
  finally
    ShowState;
  end;
end;

procedure TQueryFrame.btUnPrepareClick(Sender: TObject);
begin
  IBCQuery.UnPrepare;
  ShowState;
end;

procedure TQueryFrame.btExecuteClick(Sender: TObject);
begin
  try
    IBCQuery.SQL.Text := meSQL.Lines.Text;
    IBCQuery.Execute;
  finally
    ShowState;
  end;
end;

procedure TQueryFrame.cbFetchAllClick(Sender: TObject);
begin
  IBCQuery.FetchAll := cbFetchAll.Checked;
end;

procedure TQueryFrame.btRefreshRecordClick(Sender: TObject);
begin
  IBCQuery.RefreshRecord;
end;

procedure TQueryFrame.btShowStateClick(Sender: TObject);
begin
  ShowState;
end;

procedure TQueryFrame.IBCQueryAfterExecute(Sender: TObject; Result: Boolean);
begin
  ShowState;

  if Result then
    IbDacForm.StatusBar.Panels[0].Text := IbDacForm.StatusBar.Panels[0].Text + '   >>>> Success'
  else
    IbDacForm.StatusBar.Panels[0].Text := IbDacForm.StatusBar.Panels[0].Text + '   >>>> Fail';

{$IFDEF MSWINDOWS}
  MessageBeep(1);
{$ENDIF}
end;

procedure TQueryFrame.btSaveToXMLClick(Sender: TObject);
begin
  if SaveDialog.Execute then
    IBCQuery.SaveToXML(SaveDialog.FileName);
end;

procedure TQueryFrame.Initialize;
begin
  IBCQuery.Connection := TIBCConnection(Connection);

  meSQL.Lines.Assign(IBCQuery.SQL);
  ShowState;
  IBCQuery.FetchAll := cbFetchAll.Checked;
  edFetchRows.Text := IntToStr(IBCQuery.FetchRows);
end;

procedure TQueryFrame.SetDebug(Value: boolean);
begin
  IBCQuery.Debug := Value;
end;

{$IFDEF FPC}
initialization
  {$i Query.lrs}
{$ENDIF}

end.
