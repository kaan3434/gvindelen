unit uFormMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ActnList, Vcl.ActnMan,
  Vcl.RibbonLunaStyleActnCtrls, Vcl.Ribbon,
  Vcl.ImgList, Vcl.ActnCtrls, Vcl.ToolWin, Vcl.ActnMenus,
  Vcl.RibbonActnMenus, Data.Bind.EngExt, Vcl.Bind.DBEngExt, Data.Bind.Components,
  Vcl.StdCtrls, Vcl.ExtCtrls, DBGridEhGrouping, Vcl.ComCtrls, GridsEh, DBGridEh,
  Data.DB, Soap.InvokeRegistry, Soap.Rio, Soap.SOAPHTTPClient;

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
    HTTPRIO1: THTTPRIO;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    procedure CreateButtons(aBookerSign: string; aImgPath: String);
    function AppendPngToImageList(aImageList: TImageList;
      aPngFileName: String): integer;
    procedure AppendActionToGroup(aGroup: TRibbonGroup; aImageIndex: Integer;
      aCaption: String);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
uses
  GvFile, PngImage, uDmSwim;

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

procedure TForm1.AppendActionToGroup(aGroup: TRibbonGroup; aImageIndex: Integer; aCaption: String);
var
  actClientItem: TActionClientItem;
  act: TAction;
begin
  actClientItem:= aGroup.Items.Add;
  with actClientItem do
  begin
    act:= TAction.Create(Self);
    Action := act;
    act.AutoCheck:= true;
    act.OnExecute:= actScanAllBooker.OnExecute;
    act.Caption:= aCaption;
    act.Visible:= true;
    act.ImageIndex:= aImageIndex;
    CommandStyle:= csButton;
    (actClientItem.CommandProperties as TButtonProperties).ButtonSize:= bsLarge;
  end;
end;

procedure TForm1.CreateButtons(aBookerSign: string; aImgPath: string);
var
  ImgIndex: integer;
begin
  ImgIndex:= AppendPngToImageList(imgListRibbon, aImgPath);
  AppendPngToImageList(imgListRibbonLarge, aImgPath);
  AppendActionToGroup(tbScannerBookers, ImgIndex, aBookerSign);
  AppendActionTogroup(tbViewerBookers, ImgIndex, aBookerSign);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  Bookers: TStringList;
  i: integer;
  BookerName: String;
begin
  Bookers:= TStringList.Create;
  try
    GvFile.ListFileName(Bookers, ExtractFilePath(ParamStr(0))+'Bookers\*.png', false);
    for i:= 0 to Bookers.Count - 1 do
    begin
      BookerName:= ExtractFileNameOnly(Bookers[i]);
      CreateButtons(BookerName, Bookers[i]);
    end;
  finally
    Bookers.Free;
  end;
  ShowMessage(IntToStr(imgListRibbon.count));
end;

end.
