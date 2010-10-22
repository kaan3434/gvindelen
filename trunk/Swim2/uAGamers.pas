unit uAGamers;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uBaseForm, Provider, pFIBClientDataSet, DB, DBClient, ImgList,
  TB2Item, ActnList, ComCtrls, ExtCtrls, GridsEh, DBGridEh, DBCtrls, TBX,
  TB2Dock, TB2Toolbar, FIBDataSet, pFIBDataSet, GvCollapsePanel;

type
  TfrmAGamers = class(TfrmBaseForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAGamers: TfrmAGamers;

implementation

uses dm;

{$R *.dfm}

end.
