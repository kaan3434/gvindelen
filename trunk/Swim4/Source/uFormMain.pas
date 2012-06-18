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
  SpTBXDkPanels, SpTBXItem, FIBDataSet, pFIBDataSet;

type
  TForm1 = class(TForm)
    Ribbon: TRibbon;
    actMngRibbon: TActionManager;
    RibbonPageScaner: TRibbonPage;
    RibbonApplicationMenuBar1: TRibbonApplicationMenuBar;
    actScanAllBooker: TAction;
    RibbonPage1: TRibbonPage;
    imgListRibbon: TImageList;
    imgListRibbonLarge: TImageList;
    tbViewerBookers: TRibbonGroup;
    tbScannerBookers: TRibbonGroup;
    actViewAll: TAction;
    StatusBar1: TStatusBar;
    ProgressBar1: TProgressBar;
    actDummy: TAction;
    actNeedScan: TAction;
    RibbonPage2: TRibbonPage;
    RibbonGroup1: TRibbonGroup;
    actTeachTournirs: TAction;
    actTeachEvents: TAction;
    actRunThread: TAction;
    dckLeft: TSpTBXMultiDock;
    dckRight: TSpTBXMultiDock;
    pnlSwims: TSpTBXDockablePanel;
    DBGridEh1: TDBGridEh;
    dsSwim: TDataSource;
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
  private
    { Private declarations }
    FThreadList: TList;
    dm: TDmFormMain;
    procedure CreateBookerButtons;
    procedure CreateButtons(aBookerDataSet: TDataSet);
    function AppendPngToImageList(aImageList: TImageList;
      aPngFileName: String): integer;
    procedure AppendActionToGroup(aGroup: TRibbonGroup;
      ndBookersBooker: TGvXmlNode; aChecked: Boolean; aEvent: TNotifyEvent);
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
  GvFile, PngImage, uWebServiceThread, uSettings, uTeachTournirs, uTeachGamers;

procedure TForm1.Button1Click(Sender: TObject);
begin
  actScanAllBooker.ImageIndex:= actScanAllBooker.ImageIndex + 1;
end;

function TForm1.AppendPngToImageList(aImageList: TImageList; aPngFileName: String): integer;
var
  png: TPngImage;
  Bmp: TBitMap;
begin
  Result:= aImageList.Count;
  png := TPngImage.Create;
  try
    png.LoadFromFile(aPngFileName);
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
    png.Free;
  end;
end;

procedure TForm1.actDummyExecute(Sender: TObject);
begin
  //Dummy
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
  ndBookersBooker: TGvXmlNode; aChecked: Boolean; aEvent: TNotifyEvent);
var
  actClientItem: TActionClientItem;
  act: TAction;
begin
  actClientItem:= aGroup.Items.Add;
  with actClientItem do
  begin
    act:= TAction.Create(Self);
    Action := act;
    act.Tag:= ndBookersBooker['Id'];
    act.AutoCheck:= true;
    act.OnExecute:= aEvent;
    act.Caption:= ndBookersBooker['Title'];
    act.Visible:= true;
    act.ImageIndex:= ndBookersBooker['ImgIndex'];
    act.Checked:= aChecked;
    CommandStyle:= csButton;
    (actClientItem.CommandProperties as TButtonProperties).ButtonSize:= bsLarge;
  end;
end;

procedure TForm1.CreateBookerButtons;
begin
  with dm.qryTemp do
  begin
    SelectSQL.Text:= 'select * from bookers order by booker_id';
    Open;
    while not Eof do
    begin
      CreateButtons(dm.qryTemp);
      Next;
    end;
    Close;
  end;
end;

procedure TForm1.CreateButtons(aBooker: TGvXmlNode);
var
  ImgIndex: integer;
  ImgName: string;
begin
  ImgName:= settings.Path['Images']+aBooker['Sign']+'.png';
  ImgIndex:= AppendPngToImageList(imgListRibbon, ImgName);
  aBooker.Attr['ImgIndex'].AsInteger:= ImgIndex;
  AppendPngToImageList(imgListRibbonLarge, ImgName);
  AppendActionToGroup(tbScannerBookers, aBooker, false, actNeedScan.OnExecute);
  AppendActionTogroup(tbViewerBookers, aBooker, false, actDummy.OnExecute);
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
  dm;
  try
    dm.Bookers2Xml(Bookers);
    for Booker in Bookers.ChildNodes do
      CreateButtons(Booker);
  finally
    Bookers.Free;
  end;
  FThreadList:= TList.Create;
//  ThreadCount:= Settings.Scaners.Attr['ThreadCount'].AsIntegerDef(1);
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
begin
  settings.Scaners['ThreadCount']:= Value;
  while FThreadList.Count < Value do
  begin
    ScanThread:= TWebServiceRequester.Create(true);
    FThreadList.Add(ScanThread);
    ScanThread.OnTerminate:= OnThreadTerminate;
  end;
  while FThreadList.Count > Value do
    TWebServiceRequester(FThreadList[0]).Terminate;
end;

procedure TForm1.ShowQueueSize(var msg: TMessage);
begin
  StatusBar1.SimpleText:= Format('Очередь %u', [msg.WParam]);
end;

procedure TForm1.StartThreads;
var
  p: Pointer;
begin
  for p in FThreadList do
    TWebServiceRequester(p).Resume;
end;

end.
