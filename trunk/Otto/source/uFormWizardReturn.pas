unit uFormWizardReturn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFormWizardBase, fib, FIBDatabase, pFIBDatabase, ActnList,
  JvExControls, JvWizard, uFrameOrderItems, uFrameReturn, GvXml,
  ExtCtrls, JvExStdCtrls, JvGroupBox;

type
  TFormWizardReturn = class(TFormWizardBase)
    wzIPageOrderItems: TJvWizardInteriorPage;
    wzIPageMoneyBackKind: TJvWizardInteriorPage;
    wzWPage: TJvWizardWelcomePage;
    procedure FormCreate(Sender: TObject);
//    procedure wzFormActivePageChanging(Sender: TObject;
//      var ToPage: TJvWizardCustomPage);
  private
    { Private declarations }
    ndOrder: TGvXmlNode;
    ndOrderItems: TGvXmlNode;
    ndOrderItem: TGvXmlNode;
    ndArticle: TGvXmlNode;
    ndAdress: TGvXmlNode;
    ndPlace: TGvXmlNode;
    ndClient: TGvXmlNode;
    ndOrderTaxs: TGvXmlNode;
    ndOrderTax: TGvXmlNode;
    ndOrderMoneys: TGvXmlNode;
    ndAccount: TGvXmlNode;
    ndMoneyBack: TGvXmlNode;
    frmOrderItems: TFrameOrderItems;
    frmMoneyBack: TFrameMoneyBack;
//    frmClient: TFrameClient;
//    frmAdress: TFrameAdress;
//    frmOrderSummary: TFrameOrderSummary;
    function GetObjectId: integer;
    procedure SetObjectId(const Value: integer);
  public
    { Public declarations }
    procedure BuildXml; override;
    procedure ReadFromDB(aObjectId: Integer); override;
    property OrderId: integer read GetObjectId write SetObjectId;
  end;

var
  FormWizardReturn: TFormWizardReturn;

implementation

uses
  udmOtto, GvXmlUtils;

{$R *.dfm}

{ TFormWizardReturn }

function TFormWizardReturn.GetObjectId: integer;
begin
  result:= ObjectId;
end;

procedure TFormWizardReturn.SetObjectId(const Value: integer);
begin
  ObjectId:= Value;
end;

procedure TFormWizardReturn.BuildXml;
begin
  inherited;
  Root.NodeName:= 'ORDER';
  ndOrder:= Root;
  ndAdress:= ndOrder.FindOrCreate('ADRESS');
  ndPlace:= ndAdress.FindOrCreate('PLACE');
  ndClient:= ndOrder.FindOrCreate('CLIENT');
  ndOrderItems:= ndOrder.FindOrCreate('ORDERITEMS');
  ndOrderTaxs:= ndOrder.FindOrCreate('ORDERTAXS');
  ndOrderMoneys:= ndOrder.FindOrCreate('ORDERMONEYS');
  ndAccount:= ndClient.FindOrCreate('ACCOUNT');
  ndMoneyBack:= ndOrder.FindOrCreate('MONEYBACK');
end;

procedure TFormWizardReturn.ReadFromDB(aObjectId: Integer);
begin
  inherited;
  dmOtto.ObjectGet(ndOrder, aObjectId, trnRead);
  trnWrite.StartTransaction;
  if not FlagPresent(ndOrder, 'STATUS_FLAG_LIST', 'DELIVERED') then
  begin
    ndOrder['NEW.STATUS_SIGN']:= 'DELIVERED';
    dmOtto.ActionExecute(trnWrite, ndOrder);
    dmOtto.ObjectGet(ndOrder, OrderId, trnWrite);
  end;

  dmOtto.OrderItemsGet(ndOrderItems, aObjectId, trnWrite);
  dmOtto.OrderTaxsGet(ndOrderTaxs, aObjectId, trnWrite);
  dmOtto.OrderMoneysGet(ndOrderMoneys, aObjectId, trnWrite);
  dmOtto.ObjectGet(ndClient, ndOrder['CLIENT_ID'], trnWrite);
  dmOtto.ObjectGet(ndAccount, ndClient['ACCOUNT_ID'], trnWrite);
  dmOtto.ObjectGet(ndAdress, ndOrder['ADRESS_ID'], trnWrite);
  dmOtto.ObjectGet(ndPlace, ndAdress['PLACE_ID'], trnWrite);
end;


procedure TFormWizardReturn.FormCreate(Sender: TObject);
begin
  inherited;

  Tag:= 1;

  try
    // FrameOrderItems
    frmOrderItems:= TFrameOrderItems.Create(self);
    frmOrderItems.ndOrder:= ndOrder;
    frmOrderItems.ndOrderItems:= ndOrderItems;
    IncludeForm(wzIPageOrderItems, frmOrderItems);

    // FrameMoneyBack
    frmMoneyBack:= TFrameMoneyBack.Create(Self);
    frmMoneyBack.ndOrder:= ndOrder;
    frmMoneyBack.ndClient:= ndClient;
//    frmMoneyBack.ndMoneyBack:= ndMoneyBack;
    IncludeForm(wzIPageMoneyBackKind, frmMoneyBack);

    wzForm.ActivePageIndex:= 0;
  finally
    Tag := 0;
  end;
end;

{
procedure TFormWizardReturn.wzFormActivePageChanging(Sender: TObject;
  var ToPage: TJvWizardCustomPage);
begin
  inherited;
  if wzForm.ActivePage = wzIPageOrderItems then
    frmOrderItems.Write
  else
  if wzForm.ActivePage = wzIPageMoneyBackKind then
    frmMoneyBack.Write;
end;
}
end.
