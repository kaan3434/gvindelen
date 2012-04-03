unit main;

interface

uses
  common,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, jpeg, Buttons, ComCtrls, ToolWin, ActnList, DBCtrls,
  Grids, DBGrids, ibase;

type
  TShowFormFromDLL = procedure (AppHandle: THandle; DBHandle: TISC_DB_HANDLE); stdcall;
  TDisconnectInDLL = procedure;  stdcall;
  EDLLLoadError = class(Exception);

  TfrmMain = class(TForm)
    Panel1: TPanel;
    StatusBar1: TStatusBar;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton9: TSpeedButton;
    ActionList1: TActionList;
    Act_Connect: TAction;
    Act_Disconnect: TAction;
    Act_About: TAction;
    Act_Close: TAction;
    Timer1: TTimer;
    Panel2: TPanel;
    Splitter1: TSplitter;
    Panel4: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    dbgDemoPack: TDBGrid;
    dbmDemoPack: TDBMemo;
    ToolButton1: TToolButton;
    Panel3: TPanel;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    Bevel1: TBevel;
    procedure Act_ConnectExecute(Sender: TObject);
    procedure Act_DisconnectExecute(Sender: TObject);
    procedure Act_CloseExecute(Sender: TObject);
    procedure Act_AboutExecute(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure dbgDemoPackDblClick(Sender: TObject);
    procedure dbgDemoPackKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
  private
    { Private declarations }
    function Connect: Boolean;
    function Disconnect: Boolean;
    procedure SetActiveInterface(DoActive: Boolean);
    procedure ShowForm(AFormClass: TFormClass);
    procedure ShowFormFromDLL;
    procedure ShowExamples(Order: Integer);
  public
    { Public declarations }
    procedure DisconnectInDLL;
  end;

var
  frmMain: TfrmMain;

implementation

uses dm_main, about, simple, events, fishfact, cachexxx, master_detail,
  local_search, starting_with, local_sorting, local_filtering, midas_simple;

{$R *.DFM}

function TfrmMain.Connect: Boolean;
begin
  Result := dmMain.Connect;
  if Result then
  begin
    SetGlobalConst;
    SetActiveInterface(True);
  end;
end;

function TfrmMain.Disconnect: Boolean;
begin
  Result := dmMain.Disconnect;
  if Result then
  begin
    SetActiveInterface(False);
  end;
end;

procedure TfrmMain.SetActiveInterface(DoActive: Boolean);
begin
  Act_Connect.Enabled := not DoActive;
  Act_Disconnect.Enabled := DoActive;
  Panel1.Visible := DoActive;

  if DoActive then
  begin
    dmMain.dtDemoPack.Open;
    StatusBar1.SimpleText := '  Please DblClick on DBGrids current record to show demo program...';
    ActiveControl := dbgDemoPack;
  end
  else
  begin
    dmMain.dtDemoPack.Close;
    StatusBar1.SimpleText := '  Click Connect Button';
  end;
end;

procedure TfrmMain.ShowForm(AFormClass: TFormClass);
var
  CurrentForm: TForm;
begin
  CurrentForm := nil;
  try
    CurrentForm := TFormClass(AFormClass).Create(Application);
    CurrentForm.ShowModal;
  finally
    CurrentForm.Free;
    CurrentForm := nil;
  end;
end;

procedure TfrmMain.ShowFormFromDLL;
var
  DLLHandle: THandle;
  ShowFormFromDLL: TShowFormFromDLL;
begin
  DLLHandle := LoadLibrary(PChar(GetExePath + DLL_PATH + DLL_NAME + DLL_EXT));
  try
    if DLLHandle <= 0 then
      MsgError(DLL_ERROR_LOAD + DLL_NAME + DLL_EXT);

    @ShowFormFromDLL := GetProcAddress(DLLHandle, 'ShowFormFromDLL');

    if Assigned(ShowFormFromDLL) then
      ShowFormFromDLL(Application.Handle, dmMain.dbDemo.Handle)
    else
      MsgError(GET_PROC_ADDRESS_FAILED);

  finally
    Application.ProcessMessages;
    FreeLibrary(DLLHandle);
  end;
end;

procedure TfrmMain.DisconnectInDLL;
var
  DLLHandle: THandle;
  DisconnectInDLL: TDisconnectInDLL;
begin
  DLLHandle := LoadLibrary(PChar(GetExePath + DLL_PATH + DLL_NAME + DLL_EXT));
  try
    if DLLHandle <= 0 then
      MsgError(DLL_ERROR_LOAD + DLL_NAME + DLL_EXT);

    @DisconnectInDLL := GetProcAddress(DLLHandle, 'DisconnectInDLL');

    if Assigned(DisconnectInDLL) then
      DisconnectInDLL
    else
      MsgError(GET_PROC_ADDRESS_FAILED);

  finally
    Application.ProcessMessages;
    FreeLibrary(DLLHandle);
  end;
end;

procedure TfrmMain.Act_ConnectExecute(Sender: TObject);
begin
  Connect;
end;

procedure TfrmMain.Act_DisconnectExecute(Sender: TObject);
begin
  Disconnect;
end;

procedure TfrmMain.Act_CloseExecute(Sender: TObject);
begin
  Disconnect;
  Close;
end;

procedure TfrmMain.Act_AboutExecute(Sender: TObject);
begin
  ShowForm(TfrmAbout);
end;

procedure TfrmMain.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  Connect;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  Timer1.Enabled := True;
end;

procedure TfrmMain.ShowExamples(Order: Integer);
begin
  case Order of
    1:  ShowForm(TfrmFishfact);
    2:  ShowForm(TfrmSimple);
    3:  ShowForm(TfrmMasterDetail);
    4:  ShowForm(TfrmEvents);
    5:  ShowFormFromDLL;
    6:  ShowForm(TfrmCachexxx);
    7:  ShowForm(TfrmLocalSearch);
    8:  ShowForm(TfrmLocalFiltering);
    9:  ShowForm(TfrmLocalSorting);
    10: ShowForm(TfrmStartingWith);
    11: ShowForm(TfrmMidas);
    else UnderConstruction;
  end;
end;

procedure TfrmMain.dbgDemoPackDblClick(Sender: TObject);
begin
  ShowExamples(dmMain.dtDemoPack.FieldByName('ORDER_IN_DEMO').AsInteger);
end;

procedure TfrmMain.dbgDemoPackKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then dbgDemoPackDblClick(Self);
end;

procedure TfrmMain.SpeedButton4Click(Sender: TObject);
begin
  dbmDemoPack.DataField := 'DESCRIPTION_RUS';
end;

procedure TfrmMain.SpeedButton5Click(Sender: TObject);
begin
  dbmDemoPack.DataField := 'DESCRIPTION_ENG';
end;

end.
