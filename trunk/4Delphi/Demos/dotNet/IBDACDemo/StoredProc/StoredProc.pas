{$I DacDemo.inc}

unit StoredProc;

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
  MemUtils, DBAccess, IBC, DemoFrame, DAScript, IBCScript, ParamType;

type
  TStoredProcFrame = class(TDemoFrame)
    DBGrid: TDBGrid;
    DataSource: TDataSource;
    ToolBar: TPanel;
    btOpen: TSpeedButton;
    btPrepare: TSpeedButton;
    btUnPrepare: TSpeedButton;
    IBCStoredProc: TIBCStoredProc;
    btClose: TSpeedButton;
    btExecute: TSpeedButton;
    ToolPanel: TPanel;
    edStoredProcNames: TComboBox;
    lbStoredProcName: TLabel;
    btParameters: TSpeedButton;
    btGenerateSQL: TSpeedButton;
    cbGenerateQuery: TCheckBox;
    meSQL: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Splitter1: TSplitter;
    procedure btOpenClick(Sender: TObject);
    procedure btPrepareClick(Sender: TObject);
    procedure btUnPrepareClick(Sender: TObject);
    procedure btExecuteClick(Sender: TObject);
    procedure btGenerateSQLClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure btParametersClick(Sender: TObject);
    procedure edStoredProcNamesDropDown(Sender: TObject);
    procedure edStoredProcNamesChange(Sender: TObject);
  private
    FParamTypeForm: TParamTypeForm;
    procedure ShowState;
  public
    procedure Initialize; override;
    procedure SetDebug(Value: boolean); override;
    
    destructor Destroy; override;
  end;

var
  fmStoredProc: TStoredProcFrame;

implementation

uses Math, IbDacDemoForm;

{$IFNDEF FPC}
{$IFDEF CLR}
{$R *.nfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}
{$ENDIF}

procedure TStoredProcFrame.ShowState;
var
  St: string;
  i: integer;

  procedure AddSt(S:string);
  begin
    if St <> '' then
      St := St + ', ';
    St := St + S;
  end;

begin
  St := '';

  if IBCStoredProc.Prepared then begin
    AddSt('Prepared');

    if IBCStoredProc.IsQuery then
      AddSt('IsQuery');

  end;

  if IBCStoredProc.Active then
    AddSt('Active')
  else
    AddSt('Inactive');

  IbDacForm.StatusBar.Panels[2].Text := St;

  if IBCStoredProc.SQL.Text = '' then
    meSQL.Lines.Text := 'IBCStoredProc.SQL is empty.'
  else
    meSQL.Lines.Text := 'IBCStoredProc.SQL is:' + #13#10 + IBCStoredProc.SQL.Text;
  if IBCStoredProc.Params.Count > 0 then begin
    meSQL.Lines.Add('');
    meSQL.Lines.Add('IBCStoredProc.Params:');
    for i := 0 to IBCStoredProc.Params.Count - 1 do
      meSQL.Lines.Add(IBCStoredProc.Params[i].Name + ' = ' + IBCStoredProc.Params[i].AsString);
  end;
end;

procedure TStoredProcFrame.btOpenClick(Sender: TObject);
begin
  try
    IBCStoredProc.Open;
  finally
    ShowState;
  end;
end;

procedure TStoredProcFrame.btPrepareClick(Sender: TObject);
begin
  try
    IBCStoredProc.Prepare;
  finally
    ShowState;
  end;
end;

procedure TStoredProcFrame.btUnPrepareClick(Sender: TObject);
begin
  try
    IBCStoredProc.UnPrepare;
  finally
    ShowState;
  end;
end;

procedure TStoredProcFrame.btExecuteClick(Sender: TObject);
begin
  try
    IBCStoredProc.Execute;
  finally
    ShowState;
  end;
end;

procedure TStoredProcFrame.btGenerateSQLClick(Sender: TObject);
begin
  try
    IBCStoredProc.PrepareSQL(cbGenerateQuery.Checked);
  finally
    ShowState;
  end;
end;


procedure TStoredProcFrame.btCloseClick(Sender: TObject);
begin
  IBCStoredProc.Close;
  ShowState;
end;

procedure TStoredProcFrame.btParametersClick(Sender: TObject);
begin
  FParamTypeForm.ShowModal;
end;

procedure TStoredProcFrame.edStoredProcNamesDropDown(Sender: TObject);
var
  SpName: String;
  List: _TStringList;
begin
  SpName := edStoredProcNames.Text;
  List := _TStringList.Create;
  try
    Connection.GetStoredProcNames(List);
    AssignStrings(List, edStoredProcNames.Items);
  finally
    List.Free;
  end;
  edStoredProcNames.ItemIndex := edStoredProcNames.Items.IndexOf(SpName);
end;

procedure TStoredProcFrame.edStoredProcNamesChange(Sender: TObject);
begin
  try
    IBCStoredProc.StoredProcName := edStoredProcNames.Text;
  finally
    ShowState;
  end;
end;

procedure TStoredProcFrame.Initialize;
begin
  IBCStoredProc.Connection := TIBCConnection(Connection);
  
  FParamTypeForm := TParamTypeForm.Create(nil);
  FParamTypeForm.Params := IBCStoredProc.Params;
  edStoredProcNames.Items.Add('SEL_FROM_EMP');
  edStoredProcNames.ItemIndex := 0;
  edStoredProcNamesChange(nil)
end;

procedure TStoredProcFrame.SetDebug(Value: boolean);
begin
  IBCStoredProc.Debug := Value;
end;

destructor TStoredProcFrame.Destroy;
begin
  fmStoredProc.Free;
  inherited;
end;

{$IFDEF FPC}
initialization
  {$i StoredProc.lrs}
{$ENDIF}

end.
