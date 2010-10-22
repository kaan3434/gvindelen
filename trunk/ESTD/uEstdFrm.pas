unit uEstdFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, DBGridEhGrouping,
  PlatformDefaultStyleActnCtrls, ActnList, ActnMan, VirtualTrees, GridsEh,
  DBGridEh, ComCtrls, Ribbon, RibbonLunaStyleActnCtrls, Controls, ExtCtrls,
  MemTableDataEh, Db, MemTableEh;

type
  TForm1 = class(TForm)
    Ribbon1: TRibbon;
    RibbonPage1: TRibbonPage;
    ActionManager1: TActionManager;
    PageControl1: TPageControl;
    tsDocSets: TTabSheet;
    RibbonPage2: TRibbonPage;
    tsOperations: TTabSheet;
    DBGridEh1: TDBGridEh;
    Splitter1: TSplitter;
    DBGridEh2: TDBGridEh;
    TabSheet2: TTabSheet;
    DBGridEh3: TDBGridEh;
    DBGridEh4: TDBGridEh;
    Splitter2: TSplitter;
    DBGridEh5: TDBGridEh;
    VirtualStringTree1: TVirtualStringTree;
    Splitter3: TSplitter;
    memDocSets: TMemTableEh;
    DataSource1: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

end.
