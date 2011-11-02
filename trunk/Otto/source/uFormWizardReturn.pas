unit uFormWizardReturn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFormWizardBase, FIBDatabase, pFIBDatabase, ActnList,
  JvExControls, JvWizard, uFrameOrderItems, uFrameOrder, NativeXml;

type
  TFormWizardReturn = class(TFormWizardBase)
    wzIPageOrderItems: TJvWizardInteriorPage;
    wzIPageOrder: TJvWizardInteriorPage;
    procedure FormCreate(Sender: TObject);
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
    ndAccount: TXmlNode;
    frmOrderItems: TFrameOrderItems;
    frmOrder: TFrameOrder;
//    frmClient: TFrameClient;
//    frmAdress: TFrameAdress;
//    frmOrderSummary: TFrameOrderSummary;
    function GetObjectId: integer;
    procedure SetObjectId(const Value: integer);
  public
    { Public declarations }
    constructor CreateDB(AOwner: TComponent; aObjectId: Integer); override;
    procedure BuildXml; override;
    property OrderId: integer read GetObjectId write SetObjectId;
  end;

var
  FormWizardReturn: TFormWizardReturn;

implementation

uses
  udmOtto, GvNativeXml;

{$R *.dfm}

{ TFormWizardReturn }

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
  ndAccount:= ndClient.NodeFindOrCreate('ACCOUNT');
end;

constructor TFormWizardReturn.CreateDB(AOwner: TComponent;
  aObjectId: Integer);
begin
  inherited;
  dmOtto.ObjectGet(ndOrder, OrderId, trnRead);
  dmOtto.OrderItemsGet(ndOrderItems, OrderId, trnRead);
  dmOtto.OrderTaxsGet(ndOrderTaxs, OrderId, trnRead);
  dmOtto.ObjectGet(ndClient, GetXmlAttrValue(ndOrder, 'CLIENT_ID'), trnRead);
  dmOtto.ObjectGet(ndAccount, GetXmlAttrValue(ndClient, 'ACCOUNT_ID'), trnRead);
  dmOtto.ObjectGet(ndAdress, GetXmlAttrValue(ndOrder, 'ADRESS_ID'), trnRead);
  dmOtto.ObjectGet(ndPlace, GetXmlAttrValue(ndAdress, 'PLACE_ID'), trnRead);
end;

function TFormWizardReturn.GetObjectId: integer;
begin
  result:= ObjectId;
end;

procedure TFormWizardReturn.SetObjectId(const Value: integer);
begin
  ObjectId:= Value;
end;

procedure TFormWizardReturn.FormCreate(Sender: TObject);
begin
  inherited;
  // FrameOrderItems
  frmOrderItems:= TFrameOrderItems.Create(self);
  frmOrderItems.ndOrder:= ndOrder;
  frmOrderItems.ndOrderItems:= ndOrderItems;
  IncludeForm(wzIPageOrderItems, frmOrderItems);

  // FrameOrder
  frmOrder:= TFrameOrder.Create(self);
  frmOrder.ndOrder:= ndOrder;
  IncludeForm(wzIPageOrder, frmOrder);

  wzForm.ActivePage:= wzIPageOrderItems;
end;

end.
