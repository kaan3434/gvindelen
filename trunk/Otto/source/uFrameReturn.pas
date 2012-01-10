unit uFrameReturn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrameBase1, StdCtrls, ExtCtrls, ImgList, PngImageList,
  ActnList, FIBDatabase, pFIBDatabase, TBXStatusBars, TB2Dock, TB2Toolbar,
  TBX, JvExStdCtrls, JvGroupBox;

type
  TFrameBase2 = class(TFrameBase1)
    rgReturnKind: TRadioGroup;
    grpPostMovement: TJvGroupBox;
    grpBankMovement: TJvGroupBox;
    edBankAccount: TLabeledEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrameBase2: TFrameBase2;

implementation

{$R *.dfm}

end.
