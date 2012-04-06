{$I DacDemo.inc}

unit Threads;

interface

uses
  Classes, SysUtils,
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  Menus, ImgList, StdCtrls, ComCtrls, Buttons, ExtCtrls, Graphics,
  Controls, Forms, Dialogs, DBCtrls, Grids, DBGrids,
{$IFNDEF VER130}
  Variants,
{$ENDIF}
  DB, DBAccess, IBC, DemoFrame, MemDS, SyncObjs;

type
  TThreadsFrame = class(TDemoFrame)
    Splitter1: TSplitter;
    Shape1: TShape;
    meErrorLog: TMemo;
    Panel2: TPanel;
    Panel5: TPanel;
    btStart: TSpeedButton;
    btStop: TSpeedButton;
    btRun: TSpeedButton;
    btRunMax: TSpeedButton;
    btClearLog: TSpeedButton;
    Panel6: TPanel;
    btOpen: TSpeedButton;
    btDeleteAll: TSpeedButton;
    DBNavigator1: TDBNavigator;
    Panel11: TPanel;
    Panel10: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    lbThreadCount: TLabel;
    lbExceptCount: TLabel;
    Panel12: TPanel;
    lbInterval: TLabel;
    lbTime: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Panel13: TPanel;
    Panel14: TPanel;
    Label3: TLabel;
    edCount: TEdit;
    Panel9: TPanel;
    Label4: TLabel;
    rbInsert: TRadioButton;
    rbSelect: TRadioButton;
    Panel3: TPanel;
    Splitter2: TSplitter;
    Panel4: TPanel;
    meSQL: TMemo;
    meLog: TMemo;
    DBGrid1: TDBGrid;
    Timer: TTimer;
    IBCQuery: TIBCQuery;
    IBCDataSource: TIBCDataSource;
    btCreate: TSpeedButton;
    btDrop: TSpeedButton;
    procedure btRunClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure btStartClick(Sender: TObject);
    procedure btStopClick(Sender: TObject);
    procedure edCountChange(Sender: TObject);
    procedure btRunMaxClick(Sender: TObject);
    procedure btClearLogClick(Sender: TObject);
    procedure btOpenClick(Sender: TObject);
    procedure rgModeClick(Sender: TObject);
    procedure btDeleteAllClick(Sender: TObject);
  private
    ThreadCount: integer;
    ThreadNum: integer;
    hCountSec: TCriticalSection;
    BegTime: TDateTime;
    MaxThread: integer;
    Interval: integer;
    ExceptCount: integer;
    EventLog, ExceptLog: TStringList;

    procedure ShowStatus;

  public
    destructor Destroy; override;
    procedure Initialize; override;
    procedure SetDebug(Value: boolean); override;
  end;

  TDemoThread = class(TThread)
  private
    FFrame: TThreadsFrame;

  protected
    procedure Execute; override;

  public
    constructor Create(Frame: TThreadsFrame);
  end;

var
  ThreadsFrame: TThreadsFrame;

implementation

uses
  ThreadsData;

{$IFNDEF FPC}
{$IFDEF CLR}
{$R *.nfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}
{$ENDIF}

constructor TDemoThread.Create(Frame: TThreadsFrame);
begin
  inherited Create(True);

  FFrame := Frame;
  FreeOnTerminate := True;
  Suspended := False;
end;

procedure TDemoThread.Execute;
var
  Data: TThreadsDataModule;
  ThreadNum: integer;
  i: integer;
begin
  FFrame.hCountSec.Enter;
    Inc(FFrame.ThreadCount);
    Inc(FFrame.ThreadNum);
    ThreadNum := FFrame.ThreadNum;
  FFrame.hCountSec.Leave;
  Synchronize(FFrame.ShowStatus);

  Data := TThreadsDataModule.Create(nil);
  try
  try
    FFrame.hCountSec.Enter;
      FFrame.EventLog.Add(IntToStr(ThreadNum) + ' Connecting...');
    FFrame.hCountSec.Leave;
    Synchronize(FFrame.ShowStatus);

    FFrame.AssignConnectionTo(Data.IBCConnection);
    Data.IBCConnection.ConnectPrompt := False;
    Data.IBCConnection.Connect;

    FFrame.hCountSec.Enter;
      FFrame.EventLog.Add(IntToStr(ThreadNum) + ' Connected');
    FFrame.hCountSec.Leave;
    Synchronize(FFrame.ShowStatus);

    if FFrame.rbInsert.Checked then begin
    // INSERT
      Data.IBCSQL.ParamByName('ID').AsInteger := Random(10000);
      Data.IBCSQL.Execute;
      Data.IBCConnection.Commit;
      FFrame.hCountSec.Enter;
        FFrame.EventLog.Add(IntToStr(ThreadNum) + ' Executed');
      FFrame.hCountSec.Leave;
      Synchronize(FFrame.ShowStatus);
    end
    else
      if FFrame.rbSelect.Checked then begin
    // SELECT
        Data.IBCQuery.Open;
        i := 0;
        while not Data.IBCQuery.Eof do begin
          Data.IBCQuery.Next;
          Inc(i);
        end;
        FFrame.hCountSec.Enter;
          FFrame.EventLog.Add(IntToStr(ThreadNum) + ' Fetched ' + IntToStr(i) + ' rows');
        FFrame.hCountSec.Leave;
        Synchronize(FFrame.ShowStatus);
        Data.IBCQuery.Close;
      end;

    Data.IBCConnection.Disconnect;
    FFrame.hCountSec.Enter;
      FFrame.EventLog.Add(IntToStr(ThreadNum) + ' Disconnected');
    FFrame.hCountSec.Leave;
    Synchronize(FFrame.ShowStatus);
  except
    on E:Exception do begin
      FFrame.hCountSec.Enter;
        FFrame.EventLog.Add(IntToStr(ThreadNum) + ' ' + IntToStr(FFrame.ThreadCount) + ' Exception ' + E.Message);
        FFrame.ExceptLog.Add(IntToStr(ThreadNum) + ' ' + IntToStr(FFrame.ThreadCount) + ' Exception ' + E.Message);
        Inc(FFrame.ExceptCount);
      FFrame.hCountSec.Leave;
      Synchronize(FFrame.ShowStatus);
    end;
  end;
  finally
    Data.Free;
  end;

  FFrame.hCountSec.Enter;
    Dec(FFrame.ThreadCount);
  FFrame.hCountSec.Leave;
  Synchronize(FFrame.ShowStatus);
end;

procedure TThreadsFrame.ShowStatus;
begin
  lbThreadCount.Caption := IntToStr(ThreadCount);
  lbExceptCount.Caption := IntToStr(ExceptCount);

  if meLog.Lines.Count > 1000 then
    meLog.Lines.Clear;
  meLog.Lines.AddStrings(EventLog);
  EventLog.Clear;

  meErrorLog.Lines.AddStrings(ExceptLog);
  ExceptLog.Clear;
end;

const
  Delay = 1000;

procedure TThreadsFrame.Initialize;
begin
  inherited;
  
  IBCQuery.Connection := TIBCConnection(Connection);

  MaxThread := 5;
  Interval := 2000;
  ExceptCount := 0;
  EventLog := TStringList.Create;
  ExceptLog := TStringList.Create;
  hCountSec := TCriticalSection.Create;

  Randomize;

  ThreadsDataModule := TThreadsDataModule.Create(Self);
  edCount.Text := IntToStr(MaxThread);
  rbSelect.Checked := True;
end;

destructor TThreadsFrame.Destroy;
begin
  hCountSec.Free;
  EventLog.Free;
  ExceptLog.Free;

  inherited;
end;

procedure TThreadsFrame.btRunClick(Sender: TObject);
begin
  IBCQuery.Connection.Connect;
  if IBCQuery.Connection.Connected then
    TDemoThread.Create(Self);
end;

procedure TThreadsFrame.btRunMaxClick(Sender: TObject);
var
  i: integer;
begin
  IBCQuery.Connection.Connect;
  if IBCQuery.Connection.Connected then
    for i := 1 to MaxThread do
      TDemoThread.Create(Self);
end;

procedure TThreadsFrame.btStartClick(Sender: TObject);
begin
  edCount.Text := IntToStr(MaxThread);
  BegTime := Time;
  TimerTimer(nil);
end;

procedure TThreadsFrame.btStopClick(Sender: TObject);
begin
  Timer.Enabled := False;
end;

procedure TThreadsFrame.TimerTimer(Sender: TObject);
begin
  if ThreadCount < MaxThread then begin
    btRunClick(nil);
    if ThreadCount < (MaxThread div 10) * 9 then
      Dec(Interval, Interval div 10);
  end
  else
    Inc(Interval, Interval div 10);

  lbInterval.Caption := IntToStr(Interval);
  lbExceptCount.Caption := IntToStr(ExceptCount);
  Timer.Interval := Random(Interval - 1) + 1;
  lbTime.Caption := TimeToStr(Time - BegTime);

  lbInterval.Caption := lbInterval.Caption + ' / ' + IntToStr(Timer.Interval);

  Timer.Enabled := True;
end;

procedure TThreadsFrame.edCountChange(Sender: TObject);
begin
  MaxThread := StrToInt(edCount.Text);
end;

procedure TThreadsFrame.btClearLogClick(Sender: TObject);
begin
  meLog.Lines.Clear;
  meErrorLog.Lines.Clear;
  ThreadNum := 0;
  ExceptCount := 0;
  lbExceptCount.Caption := IntToStr(ExceptCount);
end;

procedure TThreadsFrame.btOpenClick(Sender: TObject);
begin
  IBCQuery.Close;
  IBCQuery.Open;
end;

procedure TThreadsFrame.rgModeClick(Sender: TObject);
begin
  if rbSelect.Checked then
    meSQL.Lines.Assign(ThreadsDataModule.IBCQuery.SQL)
  else
    if rbInsert.Checked then
      meSQL.Lines.Assign(ThreadsDataModule.IBCSQL.SQL)
end;

procedure TThreadsFrame.btDeleteAllClick(Sender: TObject);
begin
  IBCQuery.Connection.ExecSQL('DELETE FROM Thread_Table', [Null]);
  IBCQuery.Connection.CommitRetaining;
end;

procedure TThreadsFrame.SetDebug(Value: boolean);
begin
  IBCQuery.Debug := Value;
end;

end.
