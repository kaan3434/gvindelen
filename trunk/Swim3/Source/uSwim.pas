unit uSwim;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, TB2Item, TBX, TB2Dock, TB2Toolbar,
  StdCtrls, ComCtrls,
  GridsEh, DBGridEh, ExtCtrls, ImgList, TB2ExtItems, TBXExtItems,
  TB2ToolWindow, Menus, gsFileVersionInfo,
  DBCtrlsEh, GvVars, uSwimCommon,
  GvWebScript, IdAntiFreezeBase, IdAntiFreeze, FIBDataSet, pFIBDataSet,
  Mask, IdBaseComponent, DB, NativeXml, DBGridEhGrouping;

const
  dsIgnore=0;
  dsDownload=1;
  dsLoad=2;
  bsAll=0;
  bsUp=1;
  bsDown=2;
  isShow=0;
  isLock=1;
  isExclude=2;

  KUp=1.6;
  KDown=2.3;
  iiRusFlg=5;

type
  TfSwim = class(TForm)
    ActionList1: TActionList;
    actExit: TAction;
    sb: TStatusBar;
    OpenDialog: TOpenDialog;
    actDownloadAllLines: TAction;
    ProgressBar: TProgressBar;
    TBXDock1: TTBXDock;
    actTeach: TAction;
    ToolbarTop: TTBXToolbar;
    TBXItem4: TTBXItem;
    TBImageList: TTBImageList;
    actCalcFromMax: TAction;
    actCalcFromMin: TAction;
    TBXSeparatorItem2: TTBXSeparatorItem;
    dsSwim: TDataSource;
    Panel1: TPanel;
    DockBottom: TTBXDock;
    TBXToolbar3: TTBXToolbar;
    eiGamer1: TTBXSpinEditItem;
    eiWin1: TTBXEditItem;
    eiGamer2: TTBXSpinEditItem;
    eiWin2: TTBXEditItem;
    gridSwim: TDBGridEh;
    actDownloadBetsMarathon: TAction;
    actIgnoreBetsMarathon: TAction;
    TBXItem5: TTBXItem;
    TopWindow: TTBXToolWindow;
    rePanel: TRichEdit;
    btnSave: TTBXItem;
    TBXDock2: TTBXDock;
    ToolbarBottom: TTBXToolbar;
    eiGamer1RUR: TTBXEditItem;
    eiGamer2RUR: TTBXEditItem;
    eiWin1RUR: TTBXEditItem;
    eiWin2RUR: TTBXEditItem;
    TBXLabelItem2: TTBXLabelItem;
    TBXLabelItem3: TTBXLabelItem;
    actSetAlreadyBet: TAction;
    Version: TgsFileVersionInfo;
    actExcludeBet1: TAction;
    actExcludeBet2: TAction;
    ilState: TImageList;
    actHourDec: TAction;
    actHourInc: TAction;
    StateDefault: TTBXSubmenuItem;
    btnShow: TTBXItem;
    btnLock: TTBXItem;
    btnExclude: TTBXItem;
    actChangeK1: TAction;
    actChangeK2: TAction;
    btnDefault: TTBXItem;
    TBXSeparatorItem4: TTBXSeparatorItem;
    ilMoney: TTBImageList;
    tbCalculate: TTBXToolbar;
    TBXLabelItem1: TTBXLabelItem;
    TBControlItem1: TTBControlItem;
    TBXSeparatorItem1: TTBXSeparatorItem;
    neBet: TTBXSpinEditItem;
    TBXItem9: TTBXItem;
    TBXItem8: TTBXItem;
    TBXSeparatorItem3: TTBXSeparatorItem;
    neBetBLR: TTBXSpinEditItem;
    neBetUSD: TTBXSpinEditItem;
    TBXSeparatorItem5: TTBXSeparatorItem;
    btnAlreadyBet: TTBXItem;
    TBXItem2: TTBXItem;
    TBXItem1: TTBXItem;
    TBXItem10: TTBXItem;
    TBXItem7: TTBXItem;
    cbHour: TDBComboBoxEh;
    TBXSeparatorItem7: TTBXSeparatorItem;
    btnDeficit: TTBXItem;
    GvWebScript: TGvWebScript;
    IdAntiFreeze1: TIdAntiFreeze;
    actKursUSD: TAction;
    actKursEUR: TAction;
    actKursBLR: TAction;
    actASports: TAction;
    actBSports: TAction;
    actTournirs: TAction;
    actCountrys: TAction;
    actAGamers: TAction;
    actBGamers: TAction;
    actEvents: TAction;
    tblSwims: TpFIBDataSet;
    actSaveSwim: TAction;
    tbTables: TTBXToolbar;
    TBXItem14: TTBXItem;
    TBXItem13: TTBXItem;
    TBXItem16: TTBXItem;
    TBXItem15: TTBXItem;
    TBXItem19: TTBXItem;
    TBXItem18: TTBXItem;
    TBXItem17: TTBXItem;
    tbValutes: TTBXToolbar;
    TBXItem3: TTBXItem;
    TBXItem6: TTBXItem;
    TBXItem11: TTBXItem;
    TBXVisibilityToggleItem1: TTBXVisibilityToggleItem;
    TBXVisibilityToggleItem2: TTBXVisibilityToggleItem;
    TimerRefresh: TTimer;
    actClearEvents: TAction;
    TBXItem12: TTBXItem;
    TBXItem20: TTBXItem;
    actRenum: TAction;
    TBXItem21: TTBXItem;
    procedure actExitExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actDownloadAllLinesExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure actCalcFromMinExecute(Sender: TObject);
    procedure actCalcFromMaxExecute(Sender: TObject);
    procedure eiGamer1ValueChange(Sender: TTBXCustomSpinEditItem;
      const AValue: Extended);
    procedure eiGamer2ValueChange(Sender: TTBXCustomSpinEditItem;
      const AValue: Extended);
    procedure btnLoadBetClick(Sender: TObject);
    procedure actSetAlreadyBetExecute(Sender: TObject);
    procedure actExcludeBet1Execute(Sender: TObject);
    procedure actExcludeBet2Execute(Sender: TObject);
    procedure WebProgressChange(Sender: TObject; Progress,
      ProgressMax: Integer);
    procedure cbHourChange(Sender: TObject);
    procedure actHourIncExecute(Sender: TObject);
    procedure actHourDecExecute(Sender: TObject);
    procedure memSwimEventFilterRecord(DataSet: TDataSet;
      var Accept: Boolean);
    procedure btnShowStateClick(Sender: TObject);
    procedure btnDeficitClick(Sender: TObject);
    procedure actChangeK2Execute(Sender: TObject);
    procedure actChangeK1Execute(Sender: TObject);
    procedure actChangeK1Update(Sender: TObject);
    procedure actChangeK2Update(Sender: TObject);
    procedure btnBreakClick(Sender: TObject);
    procedure neBetBLRValueChange(Sender: TTBXCustomSpinEditItem;
      const AValue: Extended);
    procedure neBetUSDValueChange(Sender: TTBXCustomSpinEditItem;
      const AValue: Extended);
    procedure btnEndWaitClick(Sender: TObject);
    procedure actKursUSDExecute(Sender: TObject);
    procedure actKursEURExecute(Sender: TObject);
    procedure actKursBLRExecute(Sender: TObject);
    procedure UpdateUnknownCount;
    procedure actTeachExecute(Sender: TObject);
    procedure actASportsExecute(Sender: TObject);
    procedure actBSportsExecute(Sender: TObject);
    procedure actTournirsExecute(Sender: TObject);
    procedure actCountrysExecute(Sender: TObject);
    procedure tblSwimsAfterScroll(DataSet: TDataSet);
    procedure tblSwimsFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure actSaveSwimExecute(Sender: TObject);
    procedure TimerRefreshTimer(Sender: TObject);
    procedure actClearEventsExecute(Sender: TObject);
    procedure gridSwimGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure actBGamersExecute(Sender: TObject);
    procedure actRenumExecute(Sender: TObject);
  private
    vlState: TVarList;
    LockedPresent: Boolean;
    USportsCount, UTournirsCount, UGamersCount: Integer;
    procedure UpdateState(Button: TTBCustomItem; ShowState: Integer);
    function GetDownloadState(Booker_Name: String): Integer;
    function GetShowState(Booker_Id: integer): Integer;
    procedure RefreshData;
  private
    { Private declarations }
    InProcess: Boolean;
    FS1, FS2, FSV1, FSV2, FK1, FK2, FKurs1, FKurs2: Extended;
    KursBLRRUR, KursRURUSD, KursRUREUR: Single;
    procedure CalcWin;
    procedure WMSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
    procedure RefreshSwimEvents;
    procedure SetAppHeader(Str: String);
  public
    { Public declarations }
  end;

type
  TIDMSwimImplement = class(TInterfacedObject, IDMSwim)
//    StoredProc: TFIBStoredProc;
  private
    function Booker_Name(BookerId: Integer): ShortString;
    procedure UpdateStatusBar(aText: ShortString);
    procedure StepProgressBar;
    procedure InitProgressBar(aMaxValue: Integer);

    function GetASportId_byBSportName(BookerId: Integer; BSportName, TournirName: PChar;
      var BSportId, TournirId, Ways: Integer): integer;

    function PutEvent(aSt: PChar): Integer;
  end;


var
  fSwim: TfSwim;
  dmSwimImpl: IDMSwim;

implementation

uses
  dm, GvStr, GvFile,
//  urlmon, wininet,
  DateUtils, GvCloner,
  Math,
  uASports, uBSports, uCountrys, uBTournirs, 
  uBGamers, uUnknowns;

{$R *.dfm}

{ TIDMSwimImplement }

function TIDMSwimImplement.Booker_Name(BookerId: Integer): ShortString;
begin
  Result:= dmSwim.GetBookerName(BookerId);
end;

function TIDMSwimImplement.GetASportId_byBSportName(BookerId: Integer;
  BSportName, TournirName: PChar; var BSportId,
  TournirId, Ways: Integer): integer;
var
  CountrySign: String;
begin
  Result:= dmSwim.GetASportId_byBSportName(BookerId, BSportName, TournirName,
    CountrySign, BSportId, TournirId, Ways);
end;

procedure TIDMSwimImplement.InitProgressBar(aMaxValue: Integer);
begin
  fSwim.ProgressBar.Position:= 0;
  fSwim.ProgressBar.Max:= aMaxValue;
end;

function TIDMSwimImplement.PutEvent(aSt: PChar): Integer;
var
  sl: TStringList;
begin
  sl:= TStringList.Create;
  try
    sl.Text:= aSt;
    dmSwim.PutEvent(sl);
  finally
    sl.Free;
  end;
end;

procedure TIDMSwimImplement.StepProgressBar;
begin
  Application.ProcessMessages;
  fSwim.ProgressBar.StepIt;
end;

procedure TIDMSwimImplement.UpdateStatusBar(aText: ShortString);
begin
  Application.ProcessMessages;
  fSwim.sb.SimpleText:= aText;
end;


procedure TfSwim.FormCreate(Sender: TObject);
var
  St: String;
  vlProxies: TVarList;
  Btn: TTBXItem;
  State: TTBXSubmenuItem;
  I: Integer;
  sl: TStringList;

procedure LoadPlugin(FileName: string);
var
  PluginInfo: function: integer; stdcall; 
  handle: THandle;
  Booker_Id: Integer;
  BookerName: string;
begin
  handle:= LoadLibrary(Pchar(FileName));
  try
    if handle <> 0 then
    begin
      @PluginInfo:= GetProcAddress(handle,'BookerId');
      if @PluginInfo <> nil then
        Booker_Id:= PluginInfo
      else
        Exit;
      BookerName:= dmSwim.getBookerName(Booker_Id);

      vlState.Inc('Count');
      vlState[vlState['Count']]:= BookerName;
      vlState[BookerName+'.Name']:= BookerName;
      vlState[BookerName+'.Caption']:= BookerName;
      vlState.AsInteger[BookerName+'.Id']:= Booker_Id;
      vlState[BookerName+'.Plugin']:= FileName;
      vlState[BookerName+'.Index']:= vlState['Count'];
      // Кнопки верхнего тулбара
      Btn:= DuplicateComponents(btnDefault) as TTBXItem;
      Btn.Caption:= BookerName;
      Btn.Tag:= Booker_Id;
      Btn.ImageIndex:= GetDownloadState(BookerName);
      ToolbarTop.Items.Insert(i+1, Btn);
      // Кнопки нижнего тулбара
      State:= DuplicateComponents(StateDefault) as TTBXSubmenuItem;
      State.Tag:= Booker_id;
      State.Caption:= BookerName;
      ToolbarBottom.Items.Add(State);
      UpdateState(State, GetShowState(Booker_Id));

    end;
  finally
    FreeLibrary(handle);
  end;
end;

begin
  DBGridEhCenter.FilterEditCloseUpApplyFilter:= true;
  vlProxies:= TVarList.Create;
  try
    St:= 'Proxy_'+GetUserFromWindows;
    vlProxies.LoadSectionFromIniFile(ProjectIniFileName, St);
    if vlProxies.Count<>0 then
    begin
      GvWebScript.ProxyHost:= vlProxies['Host'];
      GvWebScript.ProxyPort:= vlProxies.AsInteger['Port'];
    end;
  finally
    vlProxies.Free;
  end;

  InProcess:= true;
  try
    cbHour.ItemIndex:= 3;
  finally
    InProcess:= false;
  end;

  vlState:= TVarList.Create;
  vlState.LoadSectionFromIniFile(ProjectIniFileName, 'State');
  Caption:= Format('Вилочки. Version %s',
    [Version.FileVersion]);
  vlState['Count']:= '0';
  sl:= TStringList.Create;
  try
    ListFileName(sl, Path['Plugin']+'*.swm', false);
    for i:= 0 to sl.Count - 1 do
      LoadPlugin(sl[i]);
  finally
    sl.Free;
  end;
//  btnDefault.Visible:= false;
//  StateDefault.Visible:= false;
end;

procedure TfSwim.FormDestroy(Sender: TObject);
begin
  vlState.SaveSectionToIniFile(ProjectIniFileName, 'State');
  vlState.Free;
end;

procedure TfSwim.actExitExecute(Sender: TObject);
begin
  Halt;
//  Close;
end;

procedure TfSwim.actDownloadAllLinesExecute(Sender: TObject);
var
  i, DownloadState: Integer;
  Booker_Name, Booker_Caption: string;
  PluginExec: procedure (aDMSwim: IDMSwim); stdcall;
  Handle: THandle;

procedure UpdateHint(Booker_Name: String);
var
  btn: TTBCustomItem;
begin
  btn:= ToolbarTop.Items[vlState.AsInteger[Booker_Name+'.Index']];
  btn.Hint:= Format('%s (%u)', [vlState[Booker_Name+'.Caption'],
    dmSwim.GetBetsCount(vlState.AsInteger[Booker_Name+'.Id'])]);
end;

begin
  Case MessageDlg('Очистить события?', mtConfirmation, mbYesNoCancel, 0) of
    mrYes: actClearEvents.Execute;
    mrCancel: Exit;
  end;
  sb.SimpleText:= 'Грузим html';
  For i:= 1 to vlState.AsInteger['Count'] do
  begin
    Booker_Name:= vlState[IntToStr(i)];
    Booker_Caption:= vlState[Booker_Name+'.Caption'];
    DownloadState:= GetDownloadState(Booker_Name);
    if DownloadState = 0 then continue;

    sb.SimpleText:= Format('Грузим линию %s', [Booker_Caption]);
    SetAppHeader(Booker_Caption);
    if DownloadState=2 then
    begin
      DeleteFiles(Path['Lines']+Booker_Name+'*.*');
      GvWebScript.ScriptFileName:= Path['Script']+Booker_Name+'.xml';
      GvWebScript.Vars.AddStringsAsArea('Path', Path);
      GvWebScript.Run;
    end;

    handle := LoadLibrary(PChar(vlState[Booker_Name+'.Plugin']));
    try
      @PluginExec := GetProcAddress(handle,'RecognizeLine');
      PluginExec(dmSwimImpl);
//      DMSwimIntf:= dmSwimImpl;
//     RecognizePlusMinusLine;
    finally
      FreeLibrary(handle);
    end;

//    try
//      Case BookerId of
//        GudBet_Id: DownloadGudBetLine(DownloadState);
//        BetCity_Id: DownloadBetCityLine(DownloadState);
//        Favorit_Id: DownloadFavoriteLine(DownloadState);
//        Marathon_Id: DownloadMarathonLine(DownloadState);
//        Parimatch_Id: DownloadParimatchLine(DownloadState);
//        Ucon_Id: DownloadUconLine(DownloadState);
//        BetBy_Id: DownloadBetByLine(DownloadState);
//        PlusMinus_Id: DownloadPlusMinusLine(DownloadState);
//        BWin_Id: DownloadBWinLine(DownloadState);
//        BetAtHome_Id: DownloadBetAtHomeLine(DownloadState);
//        Expekt_Id: DownloadExpektLine(DownloadState);
//        Buker_Id: DownloadBukerLine(DownloadState);
//      end;
//    except
//    end;
    dmSwim.CalculateSwim(vlState.AsInteger[Booker_Name+'.Id']);
    UpdateUnknownCount;
    RefreshSwimEvents;
    UpdateHint(Booker_Name);
  end;
  SetAppHeader('Расчет...');
  dmSwim.DeleteEmptyEvents;
  UpdateUnknownCount;
  sb.SimpleText:= 'Все линии загружены и распознаны';
end;

procedure TfSwim.RefreshSwimEvents;
var
  DtTm_To: TDateTime;
  bm: Pointer;
begin
  bm:= tblSwims.GetBookmark;
  try
    DtTm_To:= IncHour(Now, StrToInt(cbHour.KeyItems[cbHour.ItemIndex]));
    tblSwims.Close;
    tblSwims.ParamByName('EVENT_DTM_FROM').AsDateTime:= IncMinute(Now, 5);
    tblSwims.ParamByName('EVENT_DTM_TO').AsDateTime:= DtTm_To;
    tblSwims.Filtered:= true;
    tblSwims.Open;
    tblSwims.GotoBookmark(bm);
  finally
    tblSwims.FreeBookmark(bm);
  end;
end;

procedure TfSwim.FormActivate(Sender: TObject);
begin
  KursBLRRUR:= dmSwim.GetValuteKurs('BLR');
  KursRURUSD:= dmSwim.GetValuteKurs('USD');
  KursRUREUR:= dmSwim.GetValuteKurs('EUR');
  RefreshSwimEvents;
  UpdateUnknownCount;
  RefreshData;
end;


procedure TfSwim.actCalcFromMinExecute(Sender: TObject);
begin
  dmSwim.CalcFromMin(neBet.Value);
  RefreshSwimEvents;
end;

procedure TfSwim.actCalcFromMaxExecute(Sender: TObject);
begin
  dmSwim.CalcFromMax(neBet.Value);
  RefreshSwimEvents;
end;

procedure TfSwim.CalcWin;
var
  W1, W2, WR1, WR2,S1, S2: Extended;
  ii: integer;
function GetTournirName(Event_Id, Bookmaker_Id: Integer): String;
begin
  result:= '';
end;
begin
  S1:= eiGamer1.Value;
  S2:= eiGamer2.Value;
  WR1:= RoundTo(FS1*(FK1-1)-FS2, -2);
  WR2:= RoundTo(FS2*(FK2-1)-FS1, -2);
  W1:= RoundTo(S1*(FK1-1)-FS2*FKurs1, -2);
  W2:= RoundTo(S2*(FK2-1)-FS1*FKurs2, -2);
  if W1<0 then
    ii:= 1
  else
  if W1=0 then
    ii:= 2
  else
    ii:= 3;
  eiWin1.ImageIndex:= ii;
  eiWin1.Text:= Format('%1.2f', [W1]);
  if W2<0 then
    ii:= 1
  else
  if W2=0 then
    ii:= 2
  else
    ii:= 3;
  eiWin2.ImageIndex:= ii;
  eiWin2.Text:= Format('%1.2f', [W2]);

  eiGamer1RUR.Text:= Format('%1.2f', [FS1]);
  eiGamer2RUR.Text:= Format('%1.2f', [FS2]);
  eiWin1RUR.Text:= Format('%1.2f', [WR1]);
  eiWin2RUR.Text:= Format('%1.2f', [WR2]);

  with rePanel, tblSwims do
  begin
    Lines.Clear;
    Lines.Add(Format('%s  <%3.1f%%> %s. %s',
      [FormatDateTime('DD-MM-YYYY HH:NN', FieldByName('Event_Dtm').AsDateTime),
       FieldByName('K').AsFloat,
       FieldByName('ASport_Nm').AsString,
       FieldByName('ATournir_Nm').AsString]));
    Lines.Add(Format(
      '%-10s %-60s %-3s %5.1f %5.2f %10.2f %-3s',
      [Copy(FieldByName('Booker1_Nm').AsString, 1, 15),
       Copy(FieldByName('AGamer1_Nm').AsString, 1, 60),
       FieldByName('BetType1_Lbl').AsString,
       FieldByName('V1').AsFloat,
       FieldByName('K1').AsFloat,
       FieldByName('SV1').AsFloat,
       FieldByName('Valute1_Sgn').AsString]));
    Lines.Add(Format(
      '%-10s %-60s %-3s %5.1f %5.2f %10.2f %-3s',
      [Copy(FieldByName('Booker2_Nm').AsString, 1, 15),
       Copy(FieldByName('AGamer2_Nm').AsString, 1, 60),
       FieldByName('BetType2_Lbl').AsString,
       FieldByName('V2').AsFloat,
       FieldByName('K2').AsFloat,
       FieldByName('SV2').AsFloat,
       FieldByName('Valute2_Sgn').AsString]));
  end;
end;

procedure TfSwim.eiGamer1ValueChange(Sender: TTBXCustomSpinEditItem;
  const AValue: Extended);
begin
  if FKurs1=0 then Exit;
  FS1:= AValue/FKurs1;
  CalcWin;
end;

procedure TfSwim.eiGamer2ValueChange(Sender: TTBXCustomSpinEditItem;
  const AValue: Extended);
begin
  if FKurs2=0 then Exit;
  FS2:= AValue/FKurs2;
  CalcWin;
end;

procedure TfSwim.btnLoadBetClick(Sender: TObject);
begin
  with TTbxItem(Sender) do
  begin
    ImageIndex:= ImageIndex+1;
    if ImageIndex>2 then ImageIndex:= 0;
    vlState.AsInteger[Format('%s.Download', [TTbxItem(Sender).Caption])]:= ImageIndex;
  end;
end;

procedure TfSwim.WMSysCommand;
begin
  if (Msg.CmdType = SC_MINIMIZE) then
    TopWindow.Floating:= true;
  inherited;
end;

procedure TfSwim.actSetAlreadyBetExecute(Sender: TObject);
begin
  dmSwim.AlreadyBet(tblSwims['Swim_Id']);
  RefreshSwimEvents;
end;

procedure TfSwim.actExcludeBet1Execute(Sender: TObject);
var
  v: variant;
begin
  v := tblSwims['V1'];
  if VarIsNull(v) then
    v:= 0;
  dmSwim.ExcludeBet(tblSwims['Event_Id'], tblSwims['Booker1_Id'],
    tblSwims['BetType1_Id'], V);
  RefreshSwimEvents;
end;

procedure TfSwim.actExcludeBet2Execute(Sender: TObject);
var
  v: variant;
begin
  v := tblSwims['V2'];
  if VarIsNull(v) then
    v:= 0;
  dmSwim.ExcludeBet(tblSwims['Event_Id'], tblSwims['Booker2_Id'],
    tblSwims['BetType2_Id'], V);
  RefreshSwimEvents;
end;

procedure TfSwim.WebProgressChange(Sender: TObject; Progress,
  ProgressMax: Integer);
begin
  ProgressBar.Max:= ProgressMax;
  ProgressBar.Position:= Progress;
end;

procedure TfSwim.cbHourChange(Sender: TObject);
begin
  if Not InProcess then
    RefreshSwimEvents;
end;

procedure TfSwim.actHourIncExecute(Sender: TObject);
begin
  if cbHour.ItemIndex+1<cbHour.Items.Count then
    cbHour.ItemIndex:= cbHour.ItemIndex+1;
end;

procedure TfSwim.actHourDecExecute(Sender: TObject);
begin
  if cbHour.ItemIndex-1>=0 then
    cbHour.ItemIndex:= cbHour.ItemIndex-1;
end;

procedure TfSwim.memSwimEventFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
var
  Bookmaker1_Id, ShowState1, BetState1: Integer;
  Bookmaker2_Id, ShowState2, BetState2: Integer;
  K: Extended;

begin
  Accept:= false;

  if (DataSet['K']<=0) and Not btnDeficit.Checked then Exit;

  Bookmaker1_Id:= DataSet['Bookmaker1_id'];
  ShowState1:= vlState.AsInteger[Format('%u.Show', [Bookmaker1_Id])];
  BetState1:= vlState.AsInteger[Format('%u.Bet', [Bookmaker1_Id])];
  if ShowState1 = isExclude then Exit;
  if BetState1 <> bsAll then
  begin
    K:= DataSet['K1'];
    if (BetState1 = bsUp) and (K>KUp) then Exit;
    if (BetState1 = bsDown) and (K<KDown) then Exit;
  end;

  Bookmaker2_Id:= DataSet['Bookmaker2_id'];
  ShowState2:= vlState.AsInteger[Format('%u.Show', [Bookmaker2_Id])];
  BetState2:= vlState.AsInteger[Format('%u.Bet', [Bookmaker2_Id])];
  if ShowState2 = isExclude then Exit;
  if BetState2 <> bsAll then
  begin
    K:= DataSet['K2'];
    if (BetState2 = bsUp) and (K>KUp) then Exit;
    if (BetState2 = bsDown) and (K<KDown) then Exit;
  end;

  if LockedPresent and (ShowState1<>isLock) and (ShowState2<>isLock) then
    Exit;
  Accept:= true;
end;

procedure TfSwim.UpdateState(Button: TTBCustomItem; ShowState: Integer);
var
  i: Integer;
  BookerName: string;
begin
  BookerName:= vlState[IntToStr(Button.Parent.IndexOf(Button))];
  vlState.AsInteger[Format('%s.Show', [BookerName])]:= ShowState;
  LockedPresent:= false;
  Button.ImageIndex:= ShowState;
  For i:= 1 to vlState.AsInteger['Count'] do
  begin
    LockedPresent:= GetShowState(i)=isLock;
    if LockedPresent then break;
  end;
end;

procedure TfSwim.btnShowStateClick(Sender: TObject);
begin
  UpdateState(TTBXItem(Sender).Parent, TTBXItem(Sender).Tag);
  RefreshSwimEvents;
end;

procedure TfSwim.btnDeficitClick(Sender: TObject);
begin
  RefreshSwimEvents;
end;

procedure TfSwim.actChangeK1Execute(Sender: TObject);
var
  BetId: Integer;
  K: Extended;
  KSt, VSt: String;
begin
  BetId:= tblSwims['Bet1_Id'];
  K:= tblSwims['K1'];
  KSt:= InputBox('Новый Коэфф', '', FloatToStrF(K,ffFixed, 3, 2));
  KSt:= ReplaceAll(KSt, ',', '.');
  if tblSwims.FieldByName('V1').IsNull then
    VSt:= '0'
  else
    VSt:= tblSwims['V1'];
  dmSwim.UpdateBet(BetId, VSt, KSt);
  dmSwim.CalculateSwim(tblSwims['Booker1_Id']);
  RefreshSwimEvents;
end;


procedure TfSwim.actChangeK2Execute(Sender: TObject);
var
  BetId: Integer;
  K: Extended;
  KSt, VSt: String;
begin
  BetId:= tblSwims['Bet2_Id'];
  K:= tblSwims['K2'];
  KSt:= InputBox('Новый Коэфф', '', FloatToStrF(K,ffFixed, 3, 2));
  KSt:= ReplaceAll(KSt, ',', '.');
  if tblSwims.FieldByName('V2').IsNull then
    VSt:= '0'
  else
    VSt:= tblSwims['V2'];
  dmSwim.UpdateBet(BetId, VSt, KSt);
  dmSwim.CalculateSwim(tblSwims['Booker2_Id']);
  RefreshSwimEvents;
end;

procedure TfSwim.actChangeK1Update(Sender: TObject);
begin
  actChangeK1.Enabled:= Not tblSwims.Eof;
end;

procedure TfSwim.actChangeK2Update(Sender: TObject);
begin
  actChangeK2.Enabled:= Not tblSwims.Eof;
end;

function TfSwim.GetDownloadState(Booker_Name: String): Integer;
begin
  result:= vlState.AsInteger[Format('%s.Download', [Booker_Name])];
end;

function TfSwim.GetShowState(Booker_Id: Integer): Integer;
begin
  result:= vlState.AsInteger[Format('%s.Show', [vlState[IntToStr(Booker_Id)]])];
end;

procedure TfSwim.btnBreakClick(Sender: TObject);
begin
  GvWebScript.StopAction:= saStopScript;
end;

procedure TfSwim.neBetBLRValueChange(Sender: TTBXCustomSpinEditItem;
  const AValue: Extended);
begin
  neBet.Value:= AValue/KursBLRRUR;
end;

procedure TfSwim.neBetUSDValueChange(Sender: TTBXCustomSpinEditItem;
  const AValue: Extended);
begin
  neBet.Value:= AValue/KursRURUSD;
end;

procedure TfSwim.btnEndWaitClick(Sender: TObject);
begin
  GvWebScript.StopAction:= saEndWait;
end;

procedure TfSwim.SetAppHeader(Str: String);
begin
  if Str='' then
    Application.Title:= 'Вилочки'
  else
    Application.Title:= Format('[%s]', [Str]);
end;

//procedure TfSwim.DownloadMarathonLine(DownloadState: Integer);
//var
//  Html: String;
//begin
//  sb.SimpleText:= 'Грузим линию Marathon';
//  SetAppHeader(Marathon_Name);
//  if DownloadState=2 then
//  begin
//    DeleteFiles(Path['Lines']+'Marathon*.*');
//    GvWebScript.ScriptFileName:= Path['Script']+'Marathon.xml';
//    GvWebScript.Vars.AddStringsAsArea('Path', Path);
//    GvWebScript.Run;
//  end;
//  Html:= LoadFileAsString(Path['Lines']+'Marathon.html');
//  if Html<>'' then
//  begin
//    dmSwim.DeleteBookersBet(Marathon_Id);
//    RecognizeMarathonLine(Html, ProgressBar, sb);
//  end;
//end;

//procedure TfSwim.DownloadParimatchLine(DownloadState: Integer);
//var
//  Html, BookerName: String;
//begin
//  sb.SimpleText:= 'Грузим линию Parimatch';
//  BookerName:= 'Parimatch';
//  SetAppHeader(Parimatch_Name);
//  if DownloadState=2 then
//  begin
//    DeleteFiles(Path['Lines']+BookerName+'*.*');
//    GvWebScript.ScriptFileName:= Path['Script']+BookerName+'.xml';
//    GvWebScript.Vars.AddStringsAsArea('Path', Path);
//    GvWebScript.Run;
//  end;
//  html:= LoadFileAsString(Path['Lines']+BookerName+'.html');
//  if Html<>'' then
//  begin
//    dmSwim.DeleteBookersBet(Parimatch_Id);
//    RecognizeParimatchLine(Html, ProgressBar, sb);
//  end;
//end;

//procedure TfSwim.DownloadUconLine(DownloadState: Integer);
//var
//  Html: String;
//begin
//  sb.SimpleText:= 'Грузим линию Ucon';
//  SetAppHeader(Ucon_Name);
//  if DownloadState=2 then
//  begin
//    DeleteFiles(Path['Lines']+'Ucon*.*');
//    GvWebScript.ScriptFileName:= Path['Script']+'Ucon.xml';
//    GvWebScript.Vars.AddStringsAsArea('Path', Path);
//    GvWebScript.Run;
//  end;
//  Html:= LoadFileAsString(Path['Lines']+'Ucon.html');
//  if Html<>'' then
//  begin
//    dmSwim.DeleteBookersBet(Ucon_Id);
//    RecognizeUconLine(Html, ProgressBar, sb);
//  end;
//end;

//procedure TfSwim.DownloadBetCityLine(DownloadState: Integer);
//var
//  Html: String;
//begin
//  sb.SimpleText:= 'Грузим линию BetCity';
//  SetAppHeader(BetCity_Name);
//  if DownloadState=2 then
//  begin
//    DeleteFiles(Path['Lines']+'BetCity*.*');
//    GvWebScript.ScriptFileName:= Path['Script']+'BetCity.xml';
//    GvWebScript.Vars.AddStringsAsArea('Path', Path);
//    GvWebScript.Run;
//  end;
//  html:= LoadFileAsString(Path['Lines']+'BetCity.html');
//  if Html<>'' then
//  begin
//    dmSwim.DeleteBookersBet(BetCity_Id);
//    RecognizeBetCityLine(Html, ProgressBar, sb);
//  end;
//end;

//procedure TfSwim.DownloadFavoriteLine(DownloadState: Integer);
//procedure RecognizePart(SportName: String);
//var
//  FName, Html: String;
//begin
//  FName:= Format('%sfavorit.%s.html', [Path['Lines'], SportName]);
//  if FileExists(FName) then
//  begin
//    Html:= LoadFileAsString(FName);
//    if Html<>'' then
//      RecognizeFavoritLine(Html, ProgressBar, sb);
//  end;
//end;
//
//var
//  Html: String;
//begin
//  sb.SimpleText:= 'Грузим линию Favorit';
//  SetAppHeader(Favorit_Name);
//  if DownloadState=2 then
//  try
//    DeleteFiles(Path['Lines']+'Favorit*.*');
//    GvWebScript.ScriptFileName:= Path['Script']+'Favorit.xml';
//    GvWebScript.Vars.AddStringsAsArea('Path', Path);
//    GvWebScript.Run;
//  except
//  end;
//  dmSwim.DeleteBookersBet(Favorit_Id);
//  RecognizePart('Футбол');
//  RecognizePart('Теннис');
//  RecognizePart('Баскетбол');
//  RecognizePart('Волейбол');
//  RecognizePart('АмФутбол');
//  RecognizePart('Гандбол');
//  RecognizePart('Футзал');
//end;

//procedure TfSwim.DownloadBetByLine(DownloadState: Integer);
//var
//  Html: String;
//begin
//  sb.SimpleText:= 'Грузим линию BetBy';
//  SetAppHeader(BetBy_Name);
//  if DownloadState=2 then
//  begin
//    DeleteFiles(Path['Lines']+'BetBy*.*');
//    GvWebScript.ScriptFileName:= Path['Script']+'BetBy.xml';
//    GvWebScript.Vars.AddStringsAsArea('Path', Path);
//    GvWebScript.Run;
//  end;
//  Html:= LoadFileAsString(Path['Lines']+'BetBy.html');
//  if Html<>'' then
//  begin
//    dmSwim.DeleteBookersBet(BetBy_Id);
//    RecognizeBetByLine(Html, ProgressBar, sb);
//  end;
//end;

//procedure DownloadPlusMinusLine(DownloadState: Integer);
//procedure RecognizePart(SportName: String);
//var
//  FName, Html: String;
//begin
//  FName:= Format('%splusminus.%s.html', [Path['Lines'], SportName]);
//  if FileExists(FName) then
//  begin
//    Html:= LoadFileAsString(FName);
//    if Html<>'' then
//      RecognizePlusMinusLine(Html, ProgressBar, sb);
//  end;
//end;
//
//var
//  Html: String;
//begin
//  RecognizePart('Футбол');
//  RecognizePart('Теннис');
//  RecognizePart('Баскетбол');
//  RecognizePart('Волейбол');
//  RecognizePart('Гандбол');
//  RecognizePart('Другие');
//end;

//procedure TfSwim.DownloadGudBetLine(DownloadState: Integer);
////var
////  Html: String;
//begin
//{  sb.SimpleText:= 'Грузим линию GudBet';
//  SetAppHeader(GudBet_Name);
//  if DownloadState=2 then
//  begin
//    DeleteFiles(Path['Lines']+'GudBet*.*');
//    GvWebScript.ScriptFileName:= Path['Script']+'GudBet.xml';
//    GvWebScript.Vars.AddStringsAsArea('Path', Path);
//    GvWebScript.Run;
//  end;
//  html:= LoadFileAsString(Path['Lines']+'GudBet.html');
//  if Html<>'' then
//  try
//    PrepareLine(Line, GudBet_Id);
//    Html:= KillParazit(Path['Script']+'Parazits.txt', Html);
//    RecognizeGudBetLine(Html, Line, sb);
//    dmSwim.RecognizeLine(Line, ProgressBar);
//  finally
//    Line.XmlFormat:= xfReadable;
//    Line.SaveToFile(Path['Bets']+'GudBet.xml');
//  end;}
//end;

//procedure TfSwim.DownloadBWinLine(DownloadState: Integer);
//procedure RecognizePart(SportName, LineType: String);
//var
//  FName, Html: String;
//begin
//  FName:= Format('%sbwin.%s.%s.html', [Path['Lines'], SportName, LineType]);
//  if FileExists(FName) then
//  begin
//    Html:= LoadFileAsString(FName);
//    if Html<>'' then
//      RecognizeBWinLine(Html, SportName, LineType, ProgressBar, sb);
//  end;
//end;
//
//begin
//  sb.SimpleText:= 'Грузим линию BWin';
//  SetAppHeader(BWin_Name);
//  if DownloadState=2 then
//  try
//    DeleteFiles(Path['Lines']+'bwin*.*');
//    GvWebScript.ScriptFileName:= Path['Script']+'bwin.xml';
//    GvWebScript.Vars.AddStringsAsArea('Path', Path);
//    GvWebScript.Run;
//  except
//  end;
//  dmSwim.DeleteBookersBet(BWin_Id);
//  RecognizePart('Теннис', '1_2');
//  RecognizePart('Теннис', 'TOTAL');
//  RecognizePart('Футбол', '1_X_2');
//  RecognizePart('Футбол', '1X_X2_12');
//  RecognizePart('Футбол', 'TOTAL');
//  RecognizePart('Футзал', '1_X_2');
//  RecognizePart('Футзал', 'TOTAL');
//  RecognizePart('Гандбол', '1_X_2');
//  RecognizePart('Гандбол', 'TOTAL');
//  RecognizePart('Баскетбол', '1_2_DEF');
//  RecognizePart('Баскетбол', 'TOTAL');
//  RecognizePart('Волейбол', '1_2');
//  RecognizePart('Волейбол', 'TOTAL');
//  RecognizePart('Бейсбол', '1_2_DEF');
//  RecognizePart('Бейсбол', 'TOTAL');
//  RecognizePart('АмФутбол', '1_2_DEF');
//  RecognizePart('АмФутбол', 'TOTAL');
//end;

//procedure TfSwim.DownloadBetAtHomeLine(DownloadState: Integer);
//procedure RecognizePart(SportName, LineType: String);
//var
//  FName, Html: String;
//begin
//  FName:= Format('%sBetAtHome.%s.%s.html', [Path['Lines'], SportName, LineType]);
//  if FileExists(FName) then
//  begin
//    Html:= LoadFileAsString(FName);
//    if Html<>'' then
//      RecognizeBetAtHomeLine(Html, SportName, LineType, ProgressBar, sb);
//  end;
//end;
//begin
//  sb.SimpleText:= 'Грузим линию BetAtHome';
//  SetAppHeader(BetAtHome_Name);
//  if DownloadState=2 then
//  try
//    DeleteFiles(Path['Lines']+'BetAtHome*.*');
//    GvWebScript.ScriptFileName:= Path['Script']+'BetAtHome.xml';
//    GvWebScript.Vars.AddStringsAsArea('Path', Path);
//    GvWebScript.Run;
//  except
//  end;
//  RecognizePart('Футбол', '1_X_2');
//  RecognizePart('Футбол', '1X_X2_12');
//  RecognizePart('Футбол', 'TOTAL');
//  RecognizePart('Теннис', '1_2');
//  RecognizePart('Теннис', 'FORA');
//  RecognizePart('Футзал', '1_X_2');
//  RecognizePart('Футзал', 'TOTAL');
//  RecognizePart('Гандбол', '1_X_2');
//  RecognizePart('Гандбол', 'TOTAL');
//  RecognizePart('Баскетбол', '1_2_DEF');
//  RecognizePart('Баскетбол', 'TOTAL');
//  RecognizePart('Волейбол', '1_2');
//  RecognizePart('Волейбол', 'TOTAL');
//end;

//procedure TfSwim.DownloadLeonBetLine(DownloadState: Integer);
////var
////  Html: String;
//begin
//{  sb.SimpleText:= 'Грузим линию LeonBet';
//  SetAppHeader(LeonBet_Name);
//  if DownloadState=2 then
//  begin
//    DeleteFiles(Path['Lines']+'LeonBet*.*');
//    GvWebScript.ScriptFileName:= Path['Script']+'LeonBet.xml';
//    GvWebScript.Vars.AddStringsAsArea('Path', Path);
//    GvWebScript.Run;
//  end;
//  html:= LoadFileAsString(Path['Lines']+'LeonBet.html');
//  if Html<>'' then
//  try
//    PrepareLine(Line, LeonBet_Id);
//    Html:= KillParazit(Path['Script']+'Parazits.txt', Html);
//    RecognizeLeonBetLine(Html, Line, sb);
//    dmSwim.RecognizeLine(Line, ProgressBar);
//  finally
//    Line.XmlFormat:= xfReadable;
//    Line.SaveToFile(Path['Bets']+'LeonBet.xml');
//  end;}
//end;

//procedure TfSwim.DownloadExpektLine(DownloadState: Integer);
//procedure RecognizePart(SportName, LineType: String);
//var
//  FName, Html: String;
//begin
//  FName:= Format('%sexpekt.%s.%s.html', [Path['Lines'], SportName, LineType]);
//  if FileExists(FName) then
//  begin
//    Html:= LoadFileAsString(FName);
//    if Html<>'' then
//      RecognizeExpektLine(Html, SportName, LineType, ProgressBar, sb);
//  end;
//end;
//begin
//  sb.SimpleText:= 'Грузим линию Expekt';
//  SetAppHeader(Expekt_Name);
//  if DownloadState=2 then
//  begin
//    DeleteFiles(Path['Lines']+'expekt*.*');
//    GvWebScript.ScriptFileName:= Path['Script']+'expekt.xml';
//    GvWebScript.Vars.AddStringsAsArea('Path', Path);
//    GvWebScript.Run;
//  end;
//  dmSwim.DeleteBookersBet(Expekt_Id);
//  RecognizePart('Футбол', '1_X_2');
//  RecognizePart('Футбол', '1X_X2_12');
////  RecognizePart('Футбол', 'TOTAL');
////    RecognizePart(Line, 'Футзал', '1_X_2');
////    RecognizePart(Line, 'Футзал', 'TOTAL');
//  RecognizePart('Гандбол', '1_X_2');
////  RecognizePart('Гандбол', 'TOTAL');
//  RecognizePart('Баскетбол', '1_2');
////  RecognizePart('Баскетбол', 'TOTAL');
//  RecognizePart('Теннис', '1_2');
////  RecognizePart('Теннис', 'TOTAL');
//  RecognizePart('Волейбол', '1_2');
////  RecognizePart('Волейбол', 'TOTAL');
////    RecognizePart(Line, 'Бейсбол', '1_2_DEF');
////    RecognizePart(Line, 'Бейсбол', 'TOTAL');
//  RecognizePart('АмФутбол', '1_2');
////  RecognizePart('АмФутбол', 'TOTAL');
//  RecognizePart('Снукер', '1_2');
//end;

procedure TfSwim.actKursUSDExecute(Sender: TObject);
Var
  Kurs: String;
begin
  Kurs:= dmSwim.GetKursValuteRUR('USD');
  Kurs:= InputBox('Введите курс', 'RUR -> USD', Kurs);
  dmSwim.SetKursValuteRUR('USD', Kurs);
  RefreshData;
end;

procedure TfSwim.actKursEURExecute(Sender: TObject);
Var
  Kurs: String;
begin
  Kurs:= dmSwim.GetKursValuteRUR('EUR');
  Kurs:= InputBox('Введите курс', 'RUR -> EUR', Kurs);
  dmSwim.SetKursValuteRUR('EUR', Kurs);
  RefreshData;
end;

procedure TfSwim.actKursBLRExecute(Sender: TObject);
Var
  Kurs: String;
begin
  Kurs:= dmSwim.GetKursValuteBLR('BLR');
  Kurs:= InputBox('Введите курс', 'BLR -> RUR', Kurs);
  dmSwim.SetKursValuteBLR('BLR', Kurs);
  RefreshData;
end;

procedure TfSwim.UpdateUnknownCount;
begin
  dmSwim.GetUnknownCounts(USportsCount, UTournirsCount, UGamersCount);
  actTeach.Hint:= Format('Спорт: %u; Турниров: %u; Игроков: %u',
                         [USportsCount, UTournirsCount, UGamersCount]);
end;

procedure TfSwim.RefreshData;
begin
  actKursBLR.Hint:= Format('1 RUR = %1.0f BLR', [KursBLRRUR]);
  actKursUSD.Hint:= Format('1 USD = %4.2f RUR', [1/KursRURUSD]);
  actKursEUR.Hint:= Format('1 EUR = %4.2f RUR', [1/KursRUREUR]);
end;

procedure TfSwim.actTeachExecute(Sender: TObject);
begin
  UpdateUnknownCount;
  if USportsCount > 0 then
  begin
    with TfrmBSports.Create(self) do
    try
      ReadOnly:= false;
      Filter:= 'asport_id is null';
      ShowModal;
    finally
      Free;
    end;
    UpdateUnknownCount;
  end;
  if UTournirsCount > 0 then
  begin
    with TfrmBTournirs.Create(nil) do
    try
      ReadOnly:= false;
      Filter:= '(Country_Sgn is null) or (ATournir_Id is null)';
      ShowModal;
    finally
      Free;
    end;
    UpdateUnknownCount;
  end;
  if UGamersCount > 0 then
  begin
    with TfrmUnknowns.Create(self) do
    try
      ReadOnly:= false;
      Filter:= 'AGamer_Id is null';
      ShowModal;
    finally
      Free;
    end;
    UpdateUnknownCount;
  end;
  dmSwim.CalculateSwim;
  RefreshSwimEvents;
end;

procedure TfSwim.actASportsExecute(Sender: TObject);
begin
  with TfrmASports.Create(self) do
  try
    ReadOnly:= false;
    ShowModal;
  finally
    Free;
  end;
end;

procedure TfSwim.actBSportsExecute(Sender: TObject);
begin
  with TfrmBSports.Create(self) do
  try
    ReadOnly:= false;
    ShowModal;
  finally
    Free;
  end;
end;

procedure TfSwim.actTournirsExecute(Sender: TObject);
begin
  with TfrmBTournirs.Create(self) do
  try
    ReadOnly:= false;
    ShowModal;
  finally
    Free;
  end;
end;

procedure TfSwim.actCountrysExecute(Sender: TObject);
begin
  with TfrmCountrys.Create(self) do
  try
    ReadOnly:= false;
    ShowModal;
  finally
    Free;
  end;
end;

procedure TfSwim.tblSwimsAfterScroll(DataSet: TDataSet);
var
  Valute1_Sign, Valute2_Sign: string[3];

procedure UpdateEIControl(EIControl: TTBXSpinEditItem; Valute_Sign: String; Sum: Single);
begin
  if Valute_Sign='BLR' then
  begin
    EIControl.ValueType:= evtInteger;
    EIControl.Value:= RoundTo(Sum, 3);
    EIControl.Increment:= 1000;
    EIControl.ImageIndex:= iiRusFlg+1;
  end
  else
  if Valute_Sign='USD' then
  begin
    EIControl.ValueType:= evtFloat;
    EIControl.Value:= RoundTo(Sum, -2);
    EIControl.Increment:= 0.01;
    EIControl.ImageIndex:= iiRusFlg+3;
  end
  else
  if Valute_Sign='RUR' then
  begin
    EIControl.ValueType:= evtFloat;
    EIControl.Value:= RoundTo(Sum, -2);
    EIControl.Increment:= 0.1;
    EIControl.ImageIndex:= iiRusFlg;
  end;
end;

begin
  if DataSet.Tag=0 then with DataSet do
  begin
    FSV1:= FieldByName('SV1').AsFloat;
    FSV2:= FieldByName('SV2').AsFloat;
    FK1:= FieldByName('K1').AsFloat;
    FK2:= FieldByName('K2').AsFloat;
    FKurs1:= FieldByName('Valute1_Kurs').AsFloat;
    FKurs2:= FieldByName('Valute2_Kurs').AsFloat;
    Valute1_Sign:= FieldByName('Valute1_Sgn').AsString;
    Valute2_Sign:= FieldByName('Valute2_Sgn').AsString;
    eiGamer1RUR.Visible:= (FKurs1<>1) and (FKurs1<>0);
    eiGamer2RUR.Visible:= (FKurs2<>1) and (FKurs2<>0);
    eiWin1RUR.Visible:= (FKurs1<>1) and (FKurs1<>0);
    eiWin2RUR.Visible:= (FKurs2<>1) and (FKurs2<>0);

    UpdateEIControl(eiGamer1, Valute1_Sign, FSV1);
    UpdateEIControl(eiGamer2, Valute2_Sign, FSV2);

    CalcWin;
  end;
end;

procedure TfSwim.tblSwimsFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
var
  Bookmaker1_Id, ShowState1, BetState1: Integer;
  Bookmaker2_Id, ShowState2, BetState2: Integer;
  K: Extended;

begin
  Accept:= false;

  if (DataSet['K']<=0) and Not btnDeficit.Checked then Exit;

  Bookmaker1_Id:= DataSet['Booker1_id'];
  ShowState1:= vlState.AsInteger[Format('%u.Show', [Bookmaker1_Id])];
  BetState1:= vlState.AsInteger[Format('%u.Bet', [Bookmaker1_Id])];
  if ShowState1 = isExclude then Exit;
  if BetState1 <> bsAll then
  begin
    K:= DataSet['K1'];
    if (BetState1 = bsUp) and (K>KUp) then Exit;
    if (BetState1 = bsDown) and (K<KDown) then Exit;
  end;

  Bookmaker2_Id:= DataSet['Booker2_id'];
  ShowState2:= vlState.AsInteger[Format('%u.Show', [Bookmaker2_Id])];
  BetState2:= vlState.AsInteger[Format('%u.Bet', [Bookmaker2_Id])];
  if ShowState2 = isExclude then Exit;
  if BetState2 <> bsAll then
  begin
    K:= DataSet['K2'];
    if (BetState2 = bsUp) and (K>KUp) then Exit;
    if (BetState2 = bsDown) and (K<KDown) then Exit;
  end;

  if LockedPresent and (ShowState1<>isLock) and (ShowState2<>isLock) then
    Exit;
  Accept:= true;
end;

procedure TfSwim.actSaveSwimExecute(Sender: TObject);
var
  bm: Pointer;
begin
  bm:= tblSwims.GetBookmark;
  try
    dmSwim.SaveSwim(tblSwims['Swim_Id'], FS1, eiGamer1.Value, FS2, eiGamer2.Value);
    RefreshSwimEvents;
    tblSwims.GotoBookmark(bm);
  finally
    tblSwims.FreeBookmark(bm);
  end;
end;

procedure TfSwim.TimerRefreshTimer(Sender: TObject);
begin
  RefreshSwimEvents;
end;

procedure TfSwim.actClearEventsExecute(Sender: TObject);
begin
  dmSwim.DeleteOldEvents(IncYear(Now, 5));
  UpdateUnknownCount;
  RefreshSwimEvents;
end;

procedure TfSwim.gridSwimGetCellParams(Sender: TObject; Column: TColumnEh;
  AFont: TFont; var Background: TColor; State: TGridDrawState);
begin
  if Background = gridSwim.Color then
    Background:= clWindow;
end;

procedure TfSwim.actBGamersExecute(Sender: TObject);
begin
  with TfrmBGamers.Create(self) do
  try
    ReadOnly:= false;
    ShowModal;
  finally
    Free;
  end;
end;

procedure TfSwim.actRenumExecute(Sender: TObject);
begin
  dmSwim.RenumTables;
end;


end.
