unit uFormMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ActnList, Vcl.ActnMan,
  Vcl.RibbonLunaStyleActnCtrls, Vcl.Ribbon,
  Vcl.ImgList, Vcl.ActnCtrls, Vcl.ToolWin, Vcl.ActnMenus,
  Vcl.RibbonActnMenus, Data.Bind.EngExt, Vcl.Bind.DBEngExt, Data.Bind.Components,
  Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Ribbon: TRibbon;
    actMngRibbon: TActionManager;
    RibbonPageScaner: TRibbonPage;
    RibbonApplicationMenuBar1: TRibbonApplicationMenuBar;
    RibbonGroupScannerBookers: TRibbonGroup;
    actScanAllBooker: TAction;
    RibbonPage1: TRibbonPage;
    imgListRibbon: TImageList;
    Action1: TAction;
    Button1: TButton;
    imgListRibbonLarge: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure actScanAllBookerExecute(Sender: TObject);
  private
    { Private declarations }
    procedure CreateButtons(BookerSign: string; ImgPath: String);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
uses
  GvFile, PngImage;

procedure TForm1.actScanAllBookerExecute(Sender: TObject);
begin
//  ShowMessage('111');
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  actScanAllBooker.ImageIndex:= actScanAllBooker.ImageIndex + 1;
end;

procedure TForm1.CreateButtons(BookerSign: string; ImgPath: string);
var
  act: TAction;
  actClientItem: TActionClientItem;
  ImgIndex: integer;
  png: TPngImage;
  bmp: TBitmap;
begin
  ImgIndex:= imgListRibbon.Count;
  png := TPngImage.Create;
  try
    png.LoadFromFile(ImgPath);
    bmp:= TBitmap.Create;
    png.AssignTo(bmp);
    bmp.AlphaFormat:=afIgnored;
    imgListRibbon.Add(bmp, nil);
  finally
    png.Free;
  end;
  actClientItem:= RibbonGroupScannerBookers.Items.Add;
  with actClientItem do
  begin
    act:= TAction.Create(Self);
    Action := act;
    act.AutoCheck:= true;
    act.OnExecute:= actScanAllBooker.OnExecute;
    act.Caption:= BookerSign;
    act.Visible:= true;
    act.Hint:= BookerSign;
    act.ImageIndex:= ImgIndex;
    CommandStyle:= csButton;
    (actClientItem.CommandProperties as TButtonProperties).ButtonSize:= bsLarge;
  end;
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
