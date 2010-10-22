unit uCountrys;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uBaseForm, Provider, pFIBClientDataSet, DB, DBClient, ImgList,
  TB2Item, ActnList, GridsEh, DBGridEh, ExtCtrls, DBCtrls, TBX, TB2Dock,
  TB2Toolbar, ComCtrls, FIBDataSet, pFIBDataSet, GvCollapsePanel,
  TBXDkPanels;

type
  TfrmCountrys = class(TfrmBaseForm)
    cdsMCountrys: TpFIBClientDataSet;
    dsMCountrys: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCountrys: TfrmCountrys;

implementation

uses dm;

{$R *.dfm}

end.
