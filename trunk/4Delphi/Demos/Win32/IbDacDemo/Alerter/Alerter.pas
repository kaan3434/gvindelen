{$I DacDemo.inc}

unit Alerter;

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
  DBAccess, IBC, DemoFrame, IBCAlerter, DAScript, IBCScript;

type
  TAlerterFrame = class(TDemoFrame)
    IBCConnection2: TIBCConnection;
    IBCQuery1: TIBCQuery;
    IBCQuery2: TIBCQuery;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    IBCStoredProc1: TIBCStoredProc;
    IBCTransaction2: TIBCTransaction;
    IBCStoredProc2: TIBCStoredProc;
    scCreate: TIBCScript;
    Panel: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    edTrEvent: TEdit;
    edPrEvent: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    scDrop: TIBCScript;
    rbTriggers: TRadioButton;
    rbProcedure: TRadioButton;
    paTool1: TPanel;
    Label3: TLabel;
    paTool2: TPanel;
    Label4: TLabel;
    DBNavigator1: TDBNavigator;
    DBNavigator2: TDBNavigator;
    IBCConnection1: TIBCConnection;
    IBCTransaction1: TIBCTransaction;
    Splitter1: TSplitter;
    IBCAlerter1: TIBCAlerter;
    IBCAlerter2: TIBCAlerter;
    btOpen: TSpeedButton;
    btClose: TSpeedButton;
    btRegister: TSpeedButton;
    btUnregister: TSpeedButton;
    Panel13: TPanel;
    Panel3: TPanel;
    Panel9: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    btCreate: TSpeedButton;
    btDrop: TSpeedButton;
    procedure btOpenClick(Sender: TObject);
    procedure btRegisterClick(Sender: TObject);
    procedure btUnregisterClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure IBCAlerterEvent(Sender: TObject; EventName: String;
      EventCount: Integer);
    procedure QueryAfterUpdateExecute(Sender: TDataSet;
      StatementTypes: TStatementTypes; Params: TDAParams);
    procedure btCreateClick(Sender: TObject);
    procedure btDropClick(Sender: TObject);
  private
    Query1Change, Query2Change: Boolean;
    procedure Connect;
    procedure SetControlsEnabled(Enabled: Boolean);
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

const
  PrEvent = 'PR_EVENT';
  TrEvent = 'TR_EVENT';

procedure TAlerterFrame.btOpenClick(Sender: TObject);
begin
  Connect;
  IBCQuery1.Open;
  IBCQuery2.Open;
end;

procedure TAlerterFrame.Connect;
begin
  if not IBCConnection1.Connected then begin
    Connection.Connect;
    AssignConnectionTo(IBCConnection1);
    AssignConnectionTo(IBCConnection2);

    IBCConnection1.LoginPrompt := False;
    IBCConnection2.LoginPrompt := False;
    IBCConnection1.Connect;
    IBCConnection2.Connect;
  end;
end;

procedure TAlerterFrame.SetControlsEnabled(Enabled: Boolean);
begin
  btRegister.Enabled := Enabled;
  btUnregister.Enabled := not Enabled;
  rbTriggers.Enabled := Enabled;
  rbProcedure.Enabled := Enabled;
  edTrEvent.Enabled := Enabled;
  edPrEvent.Enabled := Enabled;
end;

procedure TAlerterFrame.btRegisterClick(Sender: TObject);

  procedure RegisterFor(Alerter: TIBCAlerter; Proc: TIBCStoredProc);
  begin
    Alerter.Stop;
    if rbTriggers.Checked then
      Alerter.Events.Text := edTrEvent.Text
    else
      Alerter.Events.Text := edPrEvent.Text;
    Alerter.Start;
    Proc.Prepare;
    Proc.ParamByName(PrEvent).ParamType := ptInput;
    Proc.ParamByName(PrEvent).AsString := edPrEvent.Text;
  end;

begin
  Connect;
  RegisterFor(IBCAlerter1, IBCStoredProc1);
  RegisterFor(IBCAlerter2, IBCStoredProc2);
  SetControlsEnabled(False);
end;

procedure TAlerterFrame.btUnregisterClick(Sender: TObject);
begin
  IBCAlerter1.Stop;
  IBCAlerter2.Stop;
  SetControlsEnabled(True);
end;

procedure TAlerterFrame.btCloseClick(Sender: TObject);
begin
  IBCQuery1.Close;
  IBCQuery2.Close;
end;

procedure TAlerterFrame.IBCAlerterEvent(Sender: TObject; EventName: String;
  EventCount: Integer);
begin
  if Sender = IBCAlerter1 then
    if not Query1Change then
      IBCQuery1.Refresh
    else
      Query1Change := False
  else if Sender = IBCAlerter2 then
    if not Query2Change then
      IBCQuery2.Refresh
    else
      Query2Change := False;
end;

procedure TAlerterFrame.QueryAfterUpdateExecute(Sender: TDataSet;
  StatementTypes: TStatementTypes; Params: TDAParams);
begin
  if Sender = IBCQuery1 then
    Query1Change := True
  else
    Query2Change := True;
  if IBCAlerter1.Active and rbProcedure.Checked then
    if Sender = IBCQuery1 then
      IBCStoredProc1.Execute
    else
      IBCStoredProc2.Execute;
end;

procedure TAlerterFrame.Initialize;
begin
  scCreate.Connection := TIBCConnection(Connection);
  scDrop.Connection := TIBCConnection(Connection);

  Query1Change := False;
  Query2Change := False;
end;

procedure TAlerterFrame.SetDebug(Value: boolean);
begin
  IBCQuery1.Connection.Debug := Value;
  IBCQuery2.Connection.Debug := Value;
  IBCQuery1.Debug := Value;
  IBCQuery2.Debug := Value;
  IBCStoredProc1.Debug := Value;
  IBCStoredProc2.Debug := Value;
  scDrop.Debug := Value;
  scCreate.Debug := Value;
end;

procedure TAlerterFrame.btCreateClick(Sender: TObject);
begin
// Commit makes visible changes in metadata
  if TIBCConnection(Connection).DefaultTransaction.Active then
    TIBCConnection(Connection).DefaultTransaction.Commit;
  Connect;
  scCreate.MacroByName(TrEvent).Value :=
    QuotedStr(edTrEvent.Text);
  scCreate.Execute;
end;

procedure TAlerterFrame.btDropClick(Sender: TObject);
begin
// Close default transaction to prevent metadata update conflict
  if TIBCConnection(Connection).DefaultTransaction.Active then
    TIBCConnection(Connection).DefaultTransaction.Commit;
  scDrop.Execute;
end;

{$IFDEF FPC}
initialization
  {$i Alerter.lrs}
{$ENDIF}

end.
