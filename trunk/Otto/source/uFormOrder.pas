unit uFormOrder;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, VirtualTrees;

type
  TNodeKind = (nkUnknown, nkClient, nkAddress, nkOrder, nkOrderItem);
  PVSTRecord = ^TVSTRecord;
  TVSTRecord = record
    NodeKind: TNodeKind;
    Id: Integer;
    Caption: string;
    ObjectSign: string;
  end;

type
  TFormOrder = class(TForm)
    vsTreeOrder: TVirtualStringTree;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormOrder: TFormOrder;

implementation

{$R *.dfm}

end.

