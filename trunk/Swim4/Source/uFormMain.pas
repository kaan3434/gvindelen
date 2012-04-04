unit uFormMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ActnList, Vcl.ActnMan,
  Vcl.RibbonLunaStyleActnCtrls, Vcl.Ribbon,
  Vcl.ImgList, Vcl.ActnCtrls, Vcl.ToolWin, Vcl.ActnMenus,
  Vcl.RibbonActnMenus, Data.Bind.EngExt, Vcl.Bind.DBEngExt, Data.Bind.Components;

type
  TForm1 = class(TForm)
    Ribbon: TRibbon;
    actMngRibbon: TActionManager;
    RibbonPageScaner: TRibbonPage;
    RibbonApplicationMenuBar1: TRibbonApplicationMenuBar;
    RibbonGroupScannerBookers: TRibbonGroup;
    imgListRibbonLarge: TImageList;
    actScanAllBooker: TAction;
    RibbonPage1: TRibbonPage;
    imgListRibbon: TImageList;
    ActionListBookerScan: TActionList;
    imgListBookers: TImageList;
    actScan_bwin: TAction;
    Action1: TAction;
    actScan_betcity: TAction;
    Action2: TAction;
    Action3: TAction;
    procedure actScan_bwinExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure CreateButtons(BookerSign: string);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
uses
  GvFile;

procedure TForm1.actScan_bwinExecute(Sender: TObject);
begin
//  ShowMessage('111');
end;

procedure TForm1.CreateButtons(BookerSign: string);
begin
  RibbonGroupScannerBookers.Ac
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  Bookers: TStringList;
  i: integer;

begin
  Bookers:= TStringList.Create;
  try
    GvFile.ListFileName(Bookers, '*.png', false);
  finally
    Bookers.Free;
  end;
end;

end.
