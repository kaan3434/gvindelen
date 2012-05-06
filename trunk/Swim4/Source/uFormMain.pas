unit uFormMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ActnList, Vcl.ActnMan,
  Vcl.RibbonLunaStyleActnCtrls, Vcl.Ribbon,
  Vcl.ImgList, Vcl.ActnCtrls, Vcl.ToolWin, Vcl.ActnMenus,
  Vcl.RibbonActnMenus, Data.Bind.EngExt, Vcl.Bind.DBEngExt, Data.Bind.Components,
  Vcl.StdCtrls, Vcl.ExtCtrls, DBGridEhGrouping, Vcl.ComCtrls, GridsEh, DBGridEh,
  Data.DB, Soap.InvokeRegistry, Soap.Rio, Soap.SOAPHTTPClient, ToolCtrlsEh,
  GvVars, GvXml, JvComponentBase, JvMTComponents;

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
    DBGridEh1: TDBGridEh;
    StatusBar1: TStatusBar;
    ProgressBar1: TProgressBar;
    dsSwims: TDataSource;
    actDummy: TAction;
    actNeedScan: TAction;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure actScanAllBookerExecute(Sender: TObject);
    procedure actDummyExecute(Sender: TObject);
    procedure actNeedScanExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    FThreadList: TList;
    procedure CreateButtons(aBooker: TGvXmlNode);
    function AppendPngToImageList(aImageList: TImageList;
      aPngFileName: String): integer;
    procedure AppendActionToGroup(aGroup: TRibbonGroup;
      ndBookersBooker: TGvXmlNode; aChecked: Boolean; aEvent: TNotifyEvent);
    procedure OnThreadTerminate(Sender: TObject);
  public
    { Public declarations }
    procedure StartThreads;
  end;

var
  Form1: TForm1;
  Path: TVarList;

implementation

{$R *.dfm}
uses
  GvFile, PngImage, uDmFormMain, uWebServiceThread, uSettings;

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
    Settings.Scaner[TAction(Sender).Tag]:= TAction(Sender).Checked;
end;

procedure TForm1.actScanAllBookerExecute(Sender: TObject);
var
  Booker: TGvXmlNode;
  BookerId: Integer;
begin
  for Booker in Settings.Bookers.ChildNodes do
  begin
    if Settings.Scaner[Booker['Id']] then
      dmFormMain.SportsRequestAdd(Booker);
  end;
  StartThreads;
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
    act.Caption:= ndBookersBooker['Title'];;
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
  AppendActionToGroup(tbScannerBookers, aBooker, settings.Scaner[aBooker['Id']], actNeedScan.OnExecute);
  AppendActionTogroup(tbViewerBookers, aBooker, false, actDummy.OnExecute);
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:= FThreadList.Count = 0;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  Bookers: TStringList;
  i: integer;
  BookerName: String;
  Booker: TGvXmlNode;
begin
  FThreadList:= TList.Create;
  for Booker in Settings.Bookers.ChildNodes do
    CreateButtons(Booker);
  StartThreads;
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  i: integer;
begin
  for i := FThreadList.Count-1 downto 0 do
    TThread(FThreadList.Items[i]).Terminate;
end;

procedure TForm1.OnThreadTerminate(Sender: TObject);
begin
  FThreadList.Delete(FThreadList.IndexOf(Sender));
end;

procedure TForm1.StartThreads;
var
  i: integer;
  ScanThread: TWebServiceRequester;
begin
  for i := 1 to 1 do
  begin
    ScanThread:= TWebServiceRequester.Create(true);
    FThreadList.Add(ScanThread);
    ScanThread.OnTerminate:= OnThreadTerminate;
    ScanThread.Resume;
  end;
end;

end.
