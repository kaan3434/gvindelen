unit uASports;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uBaseForm, Provider, pFIBClientDataSet, DB, DBClient, ImgList,
  TB2Item, ActnList, GridsEh, DBGridEh, ExtCtrls, DBCtrls, TBX, TB2Dock,
  TB2Toolbar, FIBDataSet, pFIBDataSet, ComCtrls;

type
  TfrmASports = class(TfrmBaseForm)
    dsASubSports: TDataSource;
    tblMainASPORT_ID: TFIBIntegerField;
    tblMainASPORT_NM: TFIBStringField;
    tblMainDEFAULT_FLG: TFIBSmallIntField;
    tblMainCOUNTRY_FLG: TFIBSmallIntField;
    tblMainASUBSPORT1_ID: TFIBIntegerField;
    tblMainASUBSPORT2_ID: TFIBIntegerField;
    tblMainWAYS_CNT: TFIBSmallIntField;
    tblMainEVENT_OFS: TFIBSmallIntField;
    tblASubSports: TpFIBDataSet;
    tblMainASUBSPORT1_NM: TStringField;
    tblMainASUBSPORT2_NM: TStringField;
  protected
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmASports: TfrmASports;

implementation

uses dm;

{$R *.dfm}

{ TfrmASports }

end.
