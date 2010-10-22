unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBGridEhGrouping, GridsEh, DBGridEh, DB, StdCtrls, ExtCtrls,
  CategoryPanelGroup, AdvSelectors, BtnListB, AdvNavBar, ComCtrls,
  AdvToolBar, AdvOfficePager, AdvOfficePagerStylers, AdvExplorerTreeview,
  AdvGlassButton, AdvAppStyler, AdvOfficeStatusBar, AdvShapeButton,
  AdvToolBarStylers, AdvPanel, AdvSplitter, AdvGlowButton;

type
  TForm1 = class(TForm)
    tbPager1: TAdvToolBarPager;
    tbPage1AdvToolBarPager11: TAdvPage;
    tbPage1AdvToolBarPager12: TAdvPage;
    tbPage1AdvToolBarPager13: TAdvPage;
    advfcpgrfcstylr1: TAdvOfficePagerOfficeStyler;
    advtlbrfcstylr1: TAdvToolBarOfficeStyler;
    btn2: TAdvShapeButton;
    advqckcstlbr1: TAdvQuickAccessToolBar;
    advfcstsbr1: TAdvOfficeStatusBar;
    advnvbr1: TAdvNavBar;
    advnvbrpnl1: TAdvNavBarPanel;
    advnvbrpnl2: TAdvNavBarPanel;
    p1: TAdvPanel;
    advfcpgr1: TAdvOfficePager;
    advfcpgr: TAdvOfficePage;
    advfcpgr2: TAdvOfficePage;
    advfcpgr3: TAdvOfficePage;
    fsty1: TAdvFormStyler;
    advpstylr1: TAdvAppStyler;
    advpnlstylr1: TAdvPanelStyler;
    advfcpg1: TAdvOfficePage;
    advfcpg2: TAdvOfficePage;
    advfcpg3: TAdvOfficePage;
    advfcpg4: TAdvOfficePage;
    advfcpg5: TAdvOfficePage;
    grdOpers1: TDBGridEh;
    spl1: TAdvSplitter;
    grdOpers2: TDBGridEh;
    advtlbr1: TAdvToolBar;
    btn1: TAdvGlowButton;
    advxplrtrvw1: TAdvExplorerTreeview;
    grdOpers3: TDBGridEh;
    advfcpg6: TAdvOfficePage;
    grdOpers4: TDBGridEh;
    spl2: TAdvSplitter;
    grdOpers5: TDBGridEh;
    grdOpers6: TDBGridEh;
    grdOpers7: TDBGridEh;
    grdOpers8: TDBGridEh;
    grdOpers9: TDBGridEh;
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    DocumentId: Integer;
  end;

var
  Form1: TForm1;

implementation

uses
  udmEstd, uEstdInterfaces;

{$R *.dfm}

procedure TForm1.btn1Click(Sender: TObject);
begin
  dmEstd:= TdmEstd.Create(self, TButton(Sender).Caption);
end;

end.
 