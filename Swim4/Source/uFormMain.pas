unit uFormMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ActnList, Vcl.ActnMan, Vcl.RibbonLunaStyleActnCtrls, Vcl.Ribbon,
  Vcl.ImgList, Vcl.ActnCtrls, Vcl.ToolWin, Vcl.ActnMenus,
  Vcl.RibbonActnMenus, Data.Bind.EngExt, Vcl.Bind.DBEngExt, Data.Bind.Components,
  Vcl.StdCtrls, Vcl.ExtCtrls, DBGridEhGrouping, Vcl.ComCtrls, GridsEh, DBGridEh,
  Data.DB, Soap.InvokeRegistry, Soap.Rio, Soap.SOAPHTTPClient, ToolCtrlsEh,
  GvVars, GvXml, JvComponentBase, JvMTComponents, uDmFormMain, uDmSwim, TB2Dock,
  SpTBXDkPanels, SpTBXItem, FIBDataSet, pFIBDataSet, Vcl.RibbonActnCtrls,
  Vcl.Mask, DBCtrlsEh, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, IdHeaderList, IdIntercept, IdLogBase, IdLogEvent,
  IdLogFile;

type
  TForm1 = class(TForm)
    Ribbon: TRibbon;
    rpScanner: TRibbonPage;
    RibbonApplicationMenuBar1: TRibbonApplicationMenuBar;
    rpViewer: TRibbonPage;
    imgListRibbon: TImageList;
    imgListRibbonLarge: TImageList;
    tbViewerBookers: TRibbonGroup;
    tbScannerBookers: TRibbonGroup;
    StatusBar1: TStatusBar;
    ProgressBar1: TProgressBar;
    rpTeacher: TRibbonPage;
    RibbonGroup1: TRibbonGroup;
    pnlSwimItems: TSpTBXDockablePanel;
    grdSwimItems: TDBGridEh;
    pnlSwimEvents: TSpTBXDockablePanel;
    grdSwimEvents: TDBGridEh;
    SpTBXSplitter1: TSpTBXSplitter;
    rgIgnore1: TRibbonGroup;
    rgIgnore2: TRibbonGroup;
    RibbonGroup5: TRibbonGroup;
    RibbonSpinEdit2: TRibbonSpinEdit;
    RibbonSpinEdit3: TRibbonSpinEdit;
    RibbonSpinEdit4: TRibbonSpinEdit;
    RibbonSpinEdit5: TRibbonSpinEdit;
    actMngRibbon: TActionManager;
    actScanAllBooker: TAction;
    actNeedShow: TAction;
    actDummy: TAction;
    actNeedScan: TAction;
    actTeachTournirs: TAction;
    actTeachEvents: TAction;
    actRunThread: TAction;
    actIgnoreBet1: TAction;
    actIgnoreBet2: TAction;
    actIgnoreEvent1: TAction;
    actIgnoreEvent2: TAction;
    actCalcMin: TAction;
    actCalcMax: TAction;
    rgBetAmount: TRibbonGroup;
    actSetCalcValuteBYR: TAction;
    actSetCalcValuteEUR: TAction;
    actSetCalcValuteRUR: TAction;
    actSetCalcValuteUSD: TAction;
    edAmount: TRibbonSpinEdit;
    actSetCalcValuteMNY: TAction;
    actIncThread: TAction;
    actDecThread: TAction;
    actIncBet1: TAction;
    actDecBet1: TAction;
    actIncBet2: TAction;
    actDecBet2: TAction;
    actCalcSwim: TAction;
    actSetExchangeRates: TAction;
    actIncKoef1: TAction;
    actDecKoef1: TAction;
    actIncKoef2: TAction;
    actDecKoef2: TAction;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure actScanAllBookerExecute(Sender: TObject);
    procedure actDummyExecute(Sender: TObject);
    procedure actNeedScanExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure actTeachTournirsExecute(Sender: TObject);
    procedure actTeachEventsExecute(Sender: TObject);
    procedure actRunThreadExecute(Sender: TObject);
    procedure actCalcMinExecute(Sender: TObject);
    procedure cbValuteSignChange(Sender: TObject);
    procedure actSetCalcValuteExecute(Sender: TObject);
    procedure actCalcMaxExecute(Sender: TObject);
    procedure actIncThreadExecute(Sender: TObject);
    procedure actIncBet1Execute(Sender: TObject);
    procedure actDecBet1Execute(Sender: TObject);
    procedure actIncBet2Execute(Sender: TObject);
    procedure actDecBet2Execute(Sender: TObject);
    procedure actCalcSwimExecute(Sender: TObject);
  private
    { Private declarations }
    FThreadList: TList;
    dm: TDmFormMain;
    FCalcValuteSign: string;
    procedure CreateBookerButtons;
    procedure CreateButtons(aBookerDataSet: TFIBDataSet);
    function AppendPngToImageList(aImageList: TImageList;
      aPngField: TBlobField): integer;
    procedure AppendActionToGroup(aGroup: TRibbonGroup;
      aDataSet: TDataSet; aImgIndex: Integer; aEvent: TNotifyEvent);
    procedure OnThreadTerminate(Sender: TObject);
    function GetThreadCount: Integer;
    procedure SetThreadCount(const Value: Integer);
    procedure ShowQueueSize(var msg: TMessage); message MY_QUEUESIZE;
    property ThreadCount: Integer read GetThreadCount write SetThreadCount;
  public
    { Public declarations }
    procedure StartThreads;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
uses
  GvFile, PngImage, uWebServiceThread, uSettings, uTeachTournirs, uTeachGamers,
  GvRibbon, GvSoapClient;

procedure TForm1.Button1Click(Sender: TObject);
begin
  actScanAllBooker.ImageIndex:= actScanAllBooker.ImageIndex + 1;
end;

procedure TForm1.cbValuteSignChange(Sender: TObject);
begin
//  edAmount.Increment:= Settings.CurrencyStep(cbValuteSign.Text);
end;

function TForm1.AppendPngToImageList(aImageList: TImageList; aPngField: TBlobField): integer;
var
  png: TPngImage;
  Bmp: TBitMap;
  Stream: TStream;
begin
  Result:= aImageList.Count;
  png := TPngImage.Create;
  Stream:= aPngField.DataSet.CreateBlobStream(aPngField, bmRead);
  try
    png.LoadFromStream(Stream);
    Bmp:= TBitmap.Create;
    try
      Bmp.Width:= aImageList.Width;
      Bmp.Height:= aImageList.Height;
      Bmp.Canvas.StretchDraw(Rect(0,0, aImageList.Width, aImageList.Height), png);
      Bmp.AlphaFormat:=afIgnored;
      aImageList.Add(Bmp, nil);
    finally
      Bmp.Free;
    end;
  finally
    Stream.Free;
    png.Free;
  end;
end;

procedure TForm1.actCalcMaxExecute(Sender: TObject);
begin
  grdSwimItems.DataSource.DataSet.DisableControls;
  try
    grdSwimItems.DataSource.DataSet.Close;
    dm.calcSwimMax(FCalcValuteSign, edAmount.Value);
    grdSwimItems.DataSource.DataSet.Open;
  finally
    grdSwimItems.DataSource.DataSet.EnableControls;
  end;
end;

procedure TForm1.actCalcMinExecute(Sender: TObject);
begin
  grdSwimItems.DataSource.DataSet.DisableControls;
  try
    grdSwimItems.DataSource.DataSet.Close;
    dm.trnRead.Commit;
    dm.calcSwimMin(FCalcValuteSign, edAmount.Value);
    dm.trnRead.StartTransaction;
    grdSwimItems.DataSource.DataSet.Open;
  finally
    grdSwimItems.DataSource.DataSet.EnableControls;
  end;
end;

procedure TForm1.actCalcSwimExecute(Sender: TObject);
var
  vSwimCount: Integer;
begin
  dm.dbSwim.QueryValue('select * from swim_get', 0);
  dm.trnRead.Commit;
  dm.trnRead.StartTransaction;
end;

procedure TForm1.actDecBet1Execute(Sender: TObject);
var
  vDataSet: TDataSet;
begin
  vDataSet:= grdSwimItems.DataSource.DataSet;
  vDataSet.DisableControls;
  try
    dm.setBet1(vDataSet['Swim_Id'], vDataSet['Valute1_Sign'], vDataSet['SV1'],
      -Settings.Bookers.Find('Booker', 'Id', vDataSet['Booker1_Id']).Attr['Money_Step'].AsFloatDef(1));
    vDataSet.Close;
    vDataSet.Open;
  finally
    vDataSet.EnableControls;
  end;
end;

procedure TForm1.actDecBet2Execute(Sender: TObject);
var
  vDataSet: TDataSet;
begin
  vDataSet:= grdSwimItems.DataSource.DataSet;
  vDataSet.DisableControls;
  try
    dm.setBet2(vDataSet['Swim_Id'], vDataSet['Valute2_Sign'], vDataSet['SV2'],
      -Settings.Bookers.Find('Booker', 'Id', vDataSet['Booker2_Id']).Attr['Money_Step'].AsFloatDef(1));
    vDataSet.Close;
    vDataSet.Open;
  finally
    vDataSet.EnableControls;
  end;
end;

procedure TForm1.actDummyExecute(Sender: TObject);
begin
  //Dummy
end;

procedure TForm1.actIncBet1Execute(Sender: TObject);
var
  vDataSet: TDataSet;
begin
  vDataSet:= grdSwimItems.DataSource.DataSet;
  vDataSet.DisableControls;
  try
    dm.setBet1(vDataSet['Swim_Id'], vDataSet['Valute1_Sign'], vDataSet['SV1'],
      Settings.Bookers.Find('Booker', 'Id', vDataSet['Booker1_Id']).Attr['Money_Step'].AsFloatDef(1));
    vDataSet.Close;
    vDataSet.Open;
  finally
    vDataSet.EnableControls;
  end;
end;

procedure TForm1.actIncBet2Execute(Sender: TObject);
var
  vDataSet: TDataSet;
begin
  vDataSet:= grdSwimItems.DataSource.DataSet;
  vDataSet.DisableControls;
  try
    dm.setBet2(vDataSet['Swim_Id'], vDataSet['Valute2_Sign'], vDataSet['SV2'],
      Settings.Bookers.Find('Booker', 'Id', vDataSet['Booker2_Id']).Attr['Money_Step'].AsFloatDef(1));
    vDataSet.Close;
    vDataSet.Open;
  finally
    vDataSet.EnableControls;
  end;
end;

procedure TForm1.actIncThreadExecute(Sender: TObject);
begin
  ThreadCount := ThreadCount + 1;
  StartThreads;
end;

procedure TForm1.actNeedScanExecute(Sender: TObject);
begin
  if (Sender is TAction) then
    dm.ScanerOnOff(TAction(Sender).Tag, TAction(Sender).Checked);
end;

procedure TForm1.actRunThreadExecute(Sender: TObject);
begin
  StartThreads;
end;

procedure TForm1.actScanAllBookerExecute(Sender: TObject);
begin
  dm.MakeSportsRequests;
  StartThreads;
end;

procedure TForm1.actSetCalcValuteExecute(Sender: TObject);
var
  aci: TActionClientItem;
  Action: TAction;
begin
  aci:= findItemByControl(rgBetAmount, edAmount);
  if assigned(aci) then
    aci.ImageIndex:= TAction(Sender).ImageIndex;
  FCalcValuteSign:= TAction(Sender).Caption;
end;

procedure TForm1.actTeachEventsExecute(Sender: TObject);
begin
  with TfrmTeachGamers.Create(self) do
  try
    ShowModal;
  finally
    Free;
  end;

end;

procedure TForm1.actTeachTournirsExecute(Sender: TObject);
begin
  with TfrmTeachTournirs.Create(self) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TForm1.AppendActionToGroup(aGroup: TRibbonGroup;
  aDataSet: TDataSet; aImgIndex: Integer; aEvent: TNotifyEvent);
var
  actClientItem: TActionClientItem;
  act: TAction;
begin
  actClientItem:= TActionClientItem(aGroup.Items.Insert(0));
  with actClientItem do
  begin
    act:= TAction.Create(Self);
    Action := act;
    act.Tag:= aDataSet['Booker_Id'];
    act.AutoCheck:= true;
    act.OnExecute:= aEvent;
    act.Caption:= aDataSet['Booker_Name'];
    act.Visible:= true;
    act.ImageIndex:= aImgIndex;
    act.Checked:= aDataSet.FieldByName('Scan_Flg').AsBoolean;;
    CommandStyle:= csButton;
  end;
end;

procedure TForm1.CreateBookerButtons;
begin
  with dm.qryTemp do
  begin
    SelectSQL.Text:= 'select * from bookers order by booker_id desc';
    Open;
    while not Eof do
    begin
      CreateButtons(dm.qryTemp);
      Next;
    end;
    Close;
  end;
end;

procedure TForm1.CreateButtons(aBookerDataSet: TFIBDataSet);
var
  ImgIndex: integer;
begin
  ImgIndex:= AppendPngToImageList(imgListRibbon, TBlobField(aBookerDataSet.FieldByName('small_icon')));
  AppendPngToImageList(imgListRibbonLarge, TBlobField(aBookerDataSet.FieldByName('small_icon')));
  AppendActionToGroup(tbScannerBookers, aBookerDataSet, ImgIndex, actNeedScan.OnExecute);
  AppendActionTogroup(tbViewerBookers, aBookerDataSet, ImgIndex, actNeedShow.OnExecute);
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  p: Pointer;
begin
  for p in FThreadList do
  begin
    TThread(p).Terminate;
    TThread(p).Resume;
  end;
  while FThreadList.Count > 0 do Application.ProcessMessages;
  CanClose:= FThreadList.Count = 0;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  Bookers, Booker: TGvXmlNode;
begin
  dm:= TDmFormMain.Create(self);
  CreateBookerButtons;
  FThreadList:= TList.Create;
  ThreadCount:= Settings.Scaners.Attr['ThreadCount'].AsIntegerDef(1);
  dm.trnWrite.StartTransaction;
  try
    dm.RequestsClean;
  finally
    dm.trnWrite.Commit;
  end;
  if Settings.Scaners.Attr['AutoStart'].AsBooleanDef(false) then
    StartThreads;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  dm.Free;
end;

function TForm1.GetThreadCount: Integer;
begin
  result:= FThreadList.Count;
end;

procedure TForm1.OnThreadTerminate(Sender: TObject);
begin
  FThreadList.Delete(FThreadList.IndexOf(Sender));
end;

procedure TForm1.SetThreadCount(const Value: Integer);
var
  ScanThread: TWebServiceRequester;
  i: integer;
begin
  settings.Scaners['ThreadCount']:= Value;
  while FThreadList.Count < Value do
  begin
    ScanThread:= TWebServiceRequester.Create(true);
    FThreadList.Add(ScanThread);
    ScanThread.OnTerminate:= OnThreadTerminate;
  end;
  for i:= Value to FThreadList.Count-1 do
    TWebServiceRequester(FThreadList[i]).Terminate;
end;

procedure TForm1.ShowQueueSize(var msg: TMessage);
begin
  StatusBar1.SimpleText:= Format('������� %u', [msg.WParam]);
end;

procedure TForm1.StartThreads;
var
  p: Pointer;
begin
  for p in FThreadList do
    if TWebServiceRequester(p).Suspended then
      TWebServiceRequester(p).Resume;
end;

end.
