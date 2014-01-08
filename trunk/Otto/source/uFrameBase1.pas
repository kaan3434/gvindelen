unit uFrameBase1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, PngImageList, ActnList, FIBDatabase, pFIBDatabase, 
  TBXStatusBars, TB2Dock, TB2Toolbar, TBX,
  ExtCtrls;

type
  TFrameBase1 = class(TFrame)
    actList: TActionList;
    imgList: TPngImageList;
    pnlFrame: TPanel;
    sBarFrame: TTBXStatusBar;
    dckTop: TTBXDock;
    tbBarTop: TTBXToolbar;
  private
    { Private declarations }
  public
    { Public declarations }
    Saved: Boolean;
    TrnRead: TpFIBTransaction;
    TrnWrite: TpFIBTransaction;
  end;

implementation

{$R *.dfm}


end.
