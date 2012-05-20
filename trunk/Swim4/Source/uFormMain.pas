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
  GvVars, GvXml, JvComponentBase, JvMTComponents, uDmFormMain;

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
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure actScanAllBookerExecute(Sender: TObject);
    procedure actDummyExecute(Sender: TObject);
    procedure actNeedScanExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure actTeachTournirsExecute(Sender: TObject);
  private
    { Private declarations }
    FThreadList: TList;
    dm: TDmFormMain;
    procedure CreateButtons(aBooker: TGvXmlNode);
    function AppendPngToImageList(aImageList: TImageList;
      aPngFileName: String): integer;
    procedure AppendActionToGroup(aGroup: TRibbonGroup;
      ndBookersBooker: TGvXmlNode; aChecked: Boolean; aEvent: TNotifyEvent);
    procedure OnThreadTerminate(Sender: TObject);
    function GetThreadCount: Integer;
    procedure SetThreadCount(const Value: Integer);
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
  GvFile, PngImage, uWebServiceThread, uSettings, uTeachTournirs;

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
    Settings.ScanerOn[TAction(Sender).Tag]:= TAction(Sender).Checked;
end;

procedure TForm1.actScanAllBookerExecute(Sender: TObject);
var
  Booker: TGvXmlNode;
  BookerId: Integer;
begin
  for Booker in Settings.Bookers.ChildNodes do
  begin
    if Settings.ScanerOn[Booker['Id']] then
      dm.SportsRequestAdd(Booker);
  end;
  StartThreads;
end;

procedure TForm1.actTeachTournirsExecute(Sender: TObject);
var
  frmTeachTournir: TfrmTeachTournirs;
begin
  frmTeachTournir:= TfrmTeachTournirs.Create(self);
  try
    frmTeachTournir.ShowModal;
  finally
    frmTeachTournir.Free;
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
    act.ImageIndex:= act.Tag;
    act.Checked:= aChecked;
    CommandStyle:= csButton;
    (actClientItem.CommandProperties as TButtonProperties).ButtonSize:= bsLarge;
  end;
end;

procedure TForm1.CreateButtons(aBooker: TGvXmlNode);
var
  ImgIndex: integer;
  ImgName: string;
begin
  ImgName:= settings.Path['Images']+aBooker['Sign']+'.png';
  ImgIndex:= AppendPngToImageList(imgListRibbon, ImgName);
  AppendPngToImageList(imgListRibbonLarge, ImgName);
  AppendActionToGroup(tbScannerBookers, aBooker, settings.ScanerOn[aBooker['Id']], actNeedScan.OnExecute);
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
  Booker: TGvXmlNode;
begin
  dm:= TDmFormMain.Create(self);
  FThreadList:= TList.Create;
  for Booker in Settings.Bookers.ChildNodes do
    CreateButtons(Booker);
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

procedure TForm1.StartThreads;
var
  p: Pointer;
begin
  for p in FThreadList do
    TWebServiceRequester(p).Resume;
end;

end.
