unit uFormWizardReturn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFormWizardBase, fib, FIBDatabase, pFIBDatabase, ActnList,
  JvExControls, JvWizard, uFrameOrderItems, uFrameReturn, NativeXml,
  ExtCtrls, JvExStdCtrls, JvGroupBox;

type
  TFormWizardReturn = class(TFormWizardBase)
    wzIPageOrderItems: TJvWizardInteriorPage;
    wzIPageMoneyBackKind: TJvWizardInteriorPage;
    wzWPage: TJvWizardWelcomePage;
    procedure FormCreate(Sender: TObject);
    procedure wzFormActivePageChanging(Sender: TObject;
      var ToPage: TJvWizardCustomPage);
  private
    { Private declarations }
    ndOrder: TXmlNode;
    ndOrderItems: TXmlNode;
    ndOrderItem: TXmlNode;
    ndArticle: TXmlNode;
    ndAdress: TXmlNode;
    ndPlace: TXmlNode;
    ndClient: TXmlNode;
    ndOrderTaxs: TXmlNode;
    ndOrderTax: TXmlNode;
    ndOrderMoneys: TXmlNode;
    ndAccount: TXmlNode;
    ndMoneyBack: TXmlNode;
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
  udmOtto, GvNativeXml;

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
  Root.Name:= 'ORDER';
  ndOrder:= Root;
  ndAdress:= ndOrder.NodeFindOrCreate('ADRESS');
  ndPlace:= ndAdress.NodeFindOrCreate('PLACE');
  ndClient:= ndOrder.NodeFindOrCreate('CLIENT');
  ndOrderItems:= ndOrder.NodeFindOrCreate('ORDERITEMS');
  ndOrderTaxs:= ndOrder.NodeFindOrCreate('ORDERTAXS');
  ndOrderMoneys:= ndOrder.NodeFindOrCreate('ORDERMONEYS');
  ndAccount:= ndClient.NodeFindOrCreate('ACCOUNT');
  ndMoneyBack:= ndOrder.NodeFindOrCreate('MONEYBACK');
end;

procedure TFormWizardReturn.ReadFromDB(aObjectId: Integer);
begin
  inherited;
  dmOtto.ObjectGet(ndOrder, aObjectId, trnRead);
  trnWrite.StartTransaction;
  if not FlagPresent('DELIVERED', ndOrder, 'STATUS_FLAG_LIST') then
  begin
    SetXmlAttr(ndOrder, 'NEW.STATUS_SIGN', 'DELIVERED');
    dmOtto.ActionExecute(trnWrite, ndOrder);
    dmOtto.ObjectGet(ndOrder, OrderId, trnWrite);
  end;

  dmOtto.OrderItemsGet(ndOrderItems, aObjectId, trnWrite);
  dmOtto.OrderTaxsGet(ndOrderTaxs, aObjectId, trnWrite);
  dmOtto.OrderMoneysGet(ndOrderMoneys, aObjectId, trnWrite);
  dmOtto.ObjectGet(ndClient, GetXmlAttrValue(ndOrder, 'CLIENT_ID'), trnWrite);
  dmOtto.ObjectGet(ndAccount, GetXmlAttrValue(ndClient, 'ACCOUNT_ID'), trnWrite);
  dmOtto.ObjectGet(ndAdress, GetXmlAttrValue(ndOrder, 'ADRESS_ID'), trnWrite);
  dmOtto.ObjectGet(ndPlace, GetXmlAttrValue(ndAdress, 'PLACE_ID'), trnWrite);
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
    frmMoneyBack.ndMoneyBack:= ndMoneyBack;
    IncludeForm(wzIPageMoneyBackKind, frmMoneyBack);

    wzForm.ActivePageIndex:= 0;
  finally
    Tag := 0;
  end;
end;

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

end.
