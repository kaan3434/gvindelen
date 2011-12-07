unit uFormTableClients;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uBaseNSIForm, DBGridEhGrouping, FIBDatabase, pFIBDatabase,
  ImgList, PngImageList, ActnList, DB, FIBDataSet, pFIBDataSet, GridsEh,
  DBGridEh, StdCtrls, JvExStdCtrls, JvGroupBox, ExtCtrls, JvExExtCtrls,
  JvExtComponent, JvPanel, TB2Item, TBX, TB2Dock, TB2Toolbar, ComCtrls;

type
  TFormTableClients = class(TBaseNSIForm)
    pcClientDetail: TPageControl;
    tsClientOrders: TTabSheet;
    tsClientAccountMovements: TTabSheet;
    grdClientOrders: TDBGridEh;
    grdAccountMovements: TDBGridEh;
    qryAccountMovements: TpFIBDataSet;
    dsAccountMovements: TDataSource;
    qryClientOrders: TpFIBDataSet;
    dsClientOrders: TDataSource;
    actAccountUserDebit: TAction;
    actAccountUserCredit: TAction;
    btnAccountUserDebit: TTBXItem;
    btnAccountUserCredit: TTBXItem;
    procedure FormCreate(Sender: TObject);
    procedure actAccountUserDebitExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormTableClients: TFormTableClients;

implementation

uses
  udmOtto, QDialogs, NativeXml, GvNativeXml;

{$R *.dfm}

procedure TFormTableClients.FormCreate(Sender: TObject);
begin
  inherited;
  trnNSI.StartTransaction;
  qryMain.Open;
  qryAccountMovements.Open;
  qryClientOrders.Open;
end;

procedure TFormTableClients.actAccountUserDebitExecute(Sender: TObject);
var
  AccountId: Integer;
  Amount_Eur: Double;
  Xml: TNativeXml;
  ndClient: TXmlNode;
begin
  if InputQuery('–учное зачисление на счет', '”кажите вносимую сумму 0..1000 EUR', Amount_Eur, 0, 1000, 2) then
  begin
    Xml:= TNativeXml.CreateName('CLIENT');
    ndClient:= Xml.Root;
    try
      trnWrite.StartTransaction;
      dmOtto.ObjectGet(ndClient, qryMain['CLIENT_ID'], trnWrite);
      try
      if GetXmlAttrValue(ndClient, 'ACCOUNT_ID') = null then
        begin
          // —оздаем счет
          AccountId:= dmOtto.GetNewObjectId('ACCOUNT');
          dmOtto.ActionExecute(trnWrite, 'ACCOUNT', 'ACCOUNT_CREATE', '', 0, AccountId);
          SetXmlAttr(ndClient, 'ACCOUNT_ID', AccountId);
          dmOtto.ActionExecute(trnWrite, ndClient);
        end
        else
          AccountId:= qryMain['ACCOUNT_ID'];
        dmOtto.ActionExecute(trnWrite, 'ACCOUNT','ACCOUNT_USERDEBIT',
          Value2Vars(Amount_EUR, 'AMOUNT_EUR'), 0, AccountId);
        trnWrite.Commit;
      except
        on E:Exception do
          begin
            trnWrite.Rollback;
            ShowMessage(E.Message);
          end
      end;
    finally
      Xml.Free;
    end;
  end;
  qryMain.CloseOpen(True);
end;

end.
