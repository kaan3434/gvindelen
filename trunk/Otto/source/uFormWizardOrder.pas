unit uFormWizardOrder;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFormWizardBase, FIBDatabase, pFIBDatabase, ActnList,
  JvExControls, JvWizard, GvXml, ExtCtrls, JvExExtCtrls,
  JvPanel, uFrameOrderItems, uFrameOrder, uFrameClient,
  uFrameAdress, uFrameOrderSummary, StdCtrls;

type
  TFormWizardOrder = class(TFormWizardBase)
    wzWPage: TJvWizardWelcomePage;
    wzIPageOrderItems: TJvWizardInteriorPage;
    wzIPageOrder: TJvWizardInteriorPage;
    wzIPageClient: TJvWizardInteriorPage;
    wzIPageAdress: TJvWizardInteriorPage;
    wzIPageOrderSummary: TJvWizardInteriorPage;
    btnClientPageFirst: TButton;
    actClientPageFirst: TAction;
    procedure FormCreate(Sender: TObject);
    procedure trnWriteBeforeEnd(EndingTR: TFIBTransaction;
      Action: TTransactionAction; Force: Boolean);
    procedure actClientPageFirstExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure wzIPageAdressNextButtonClick(Sender: TObject;
      var Stop: Boolean);
    procedure wzIPageClientNextButtonClick(Sender: TObject;
      var Stop: Boolean);
    procedure wzIPageOrderNextButtonClick(Sender: TObject;
      var Stop: Boolean);
    procedure wzIPageOrderItemsNextButtonClick(Sender: TObject;
      var Stop: Boolean);
    procedure wzIPageAdressEnterPage(Sender: TObject;
      const FromPage: TJvWizardCustomPage);
    procedure wzIPageClientEnterPage(Sender: TObject;
      const FromPage: TJvWizardCustomPage);
    procedure wzIPageOrderSummaryEnterPage(Sender: TObject;
      const FromPage: TJvWizardCustomPage);
    procedure wzIPageOrderEnterPage(Sender: TObject;
      const FromPage: TJvWizardCustomPage);
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
    ndProduct: TGvXmlNode;
    frmOrderItems: TFrameOrderItems;
    frmOrder: TFrameOrder;
    frmClient: TFrameClient;
    frmAdress: TFrameAdress;
    frmOrderSummary: TFrameOrderSummary;
    function GetObjectId: integer;
    procedure SetObjectId(const Value: integer);
  public
    { Public declarations }
    constructor CreateBlank(AOwner: TComponent); virtual;
    constructor CreateMessage(AOwner: TComponent; aMessageId: integer); override;
    procedure ParseMessage(aFileName: string); override;
    procedure BuildXml; override;
    procedure ReadFromDB(aObjectId: Integer); override;
    property OrderId: integer read GetObjectId write SetObjectId;
  end;

var
  FormWizardOrder: TFormWizardOrder;

implementation

uses
  udmOtto, GvXmlUtils, uParseOrder;

{$R *.dfm}

{ TFormWizardOrder }

procedure TFormWizardOrder.BuildXml;
begin
  inherited;
  Root.NodeName:= 'ORDER';
  ndOrder:= Root;
  ndAdress:= ndOrder.FindOrCreate('ADRESS');
  ndProduct:= ndOrder.FindOrCreate('PRODUCT');
  ndPlace:= ndAdress.FindOrCreate('PLACE');
  ndClient:= ndOrder.FindOrCreate('CLIENT');
  ndOrderItems:= ndOrder.FindOrCreate('ORDERITEMS');
  ndOrderTaxs:= ndOrder.FindOrCreate('ORDERTAXS');
  ndOrderMoneys:= ndOrder.FindOrCreate('ORDERMONEYS');
  ndAccount:= ndClient.FindOrCreate('ACCOUNT');
end;

constructor TFormWizardOrder.CreateBlank(AOwner: TComponent);
begin
  inherited;
  OrderId:= dmOtto.GetNewObjectId('ORDER');
  ndOrder['SOURCE']:= 'Телефон/Лично';
  ndOrder['ID']:= ObjectId;
  ndOrder['BYR2EUR']:= dmOtto.SettingGet(trnRead, 'BYR2EUR');
  ndOrder['CREATE_DTM']:= Now;
  dmOtto.ActionExecute(trnWrite, 'ORDER_CREATE', ndOrder);
  dmOtto.ObjectGet(ndOrder, OrderId, trnWrite);
  Caption:= 'Новая заявка [ID='+ndOrder['ID']+']';
end;

constructor TFormWizardOrder.CreateMessage(AOwner: TComponent;
  aMessageId: integer);
begin
  inherited;
  OrderId:= dmOtto.GetNewObjectId('ORDER');
  ndOrder['SOURCE']:= 'Internet';
  ndOrder['ID']:= ObjectId;
  ndOrder['BYR2EUR']:= StrToCurr(dmOtto.SettingGet(trnRead, 'BYR2EUR'));
  ndOrder['CREATE_DTM']:= Now;
  BuildXml;
  dmOtto.ActionExecute(trnWrite, 'ORDER_CREATE', ndOrder);
  dmOtto.ObjectGet(ndOrder, OrderId, trnWrite);
end;



procedure TFormWizardOrder.ReadFromDB(aObjectId: Integer);
begin
  inherited;
  dmOtto.ObjectGet(ndOrder, OrderId, trnRead);
  dmOtto.ObjectGet(ndClient, ndOrder['CLIENT_ID'], trnRead);
  dmOtto.ObjectGet(ndAccount, ndClient['ACCOUNT_ID'], trnRead);
  dmOtto.ObjectGet(ndAdress, ndOrder['ADRESS_ID'], trnRead);
  dmOtto.ObjectGet(ndPlace, ndAdress['PLACE_ID'], trnRead);
  dmOtto.ObjectGet(ndProduct, ndOrder['PRODUCT_ID'], trnRead);
  dmOtto.OrderItemsGet(ndOrderItems, OrderId, trnRead);
  dmOtto.OrderTaxsGet(ndOrderTaxs, OrderId, trnRead);
  dmOtto.OrderMoneysGet(ndOrderMoneys, OrderId, trnRead);
  Caption:= Format('Заявка %s [ID=%s]',
                   [ndOrder.Attr['ORDER_CODE'].AsString,
                    ndOrder.Attr['ID'].AsString]);
end;




procedure TFormWizardOrder.FormCreate(Sender: TObject);
begin
  inherited;

  Tag:= 1;

  frmOrderItems:= TFrameOrderItems.Create(self);
  frmOrderItems.ndOrder:= ndOrder;
  frmOrderItems.ndOrderItems:= ndOrderItems;
  IncludeForm(wzIPageOrderItems, frmOrderItems);

  frmOrder:= TFrameOrder.Create(self);
  frmOrder.ndOrder:= ndOrder;
  IncludeForm(wzIPageOrder, frmOrder);

  frmClient:= TFrameClient.Create(self);
  frmClient.ndOrder:= ndOrder;
  frmClient.ndClient:= ndClient;
  frmClient.ndAccount:= ndAccount;
  frmClient.ndAdress:= ndAdress;
  frmClient.ndPlace:= ndPlace;
  IncludeForm(wzIPageClient, frmClient);

  frmAdress:= TFrameAdress.Create(self);
  frmAdress.ndOrder:= ndOrder;
  frmAdress.ndClient:= ndClient;
  frmAdress.ndAdress:= ndAdress;
  frmAdress.ndPlace:= ndPlace;
  IncludeForm(wzIPageAdress, frmAdress);

  frmOrderSummary:= TFrameOrderSummary.Create(self);
  frmOrderSummary.ndOrder:= ndOrder;
  frmOrderSummary.ndClient:= ndClient;
  frmOrderSummary.ndAdress:= ndAdress;
  frmOrderSummary.ndPlace:= ndPlace;
  frmOrderSummary.ndAccount:= ndAccount;
  frmOrderSummary.ndProduct:= ndProduct;
  IncludeForm(wzIPageOrderSummary, frmOrderSummary);

//  if SourceFlag = sfDataBase then
//    wzForm.ActivePage:= wzIPageOrderItems
//  else
  wzForm.ActivePageIndex:= 0;
  Tag:= 0;
end;

function TFormWizardOrder.GetObjectId: integer;
begin
  result:= ObjectId;
end;

procedure TFormWizardOrder.SetObjectId(const Value: integer);
begin
  ObjectId:= Value;
end;

procedure TFormWizardOrder.trnWriteBeforeEnd(EndingTR: TFIBTransaction;
  Action: TTransactionAction; Force: Boolean);
begin
  inherited;
  if Action = taCommit then
  begin
    if MessageId > 0 then
      dmOtto.MessageSuccess(trnWrite, MessageId);
  end;
end;

procedure TFormWizardOrder.actClientPageFirstExecute(Sender: TObject);
begin
  if wzForm.Pages[1] = wzIPageOrderItems then
  begin
    wzForm.Pages.Exchange(1, 3);
    wzForm.Pages.Exchange(2, 4);
  end;
  wzForm.SelectNextPage;
end;

procedure TFormWizardOrder.ParseMessage(aFileName: string);
begin
  Caption:= Format('Интернет-заявка [%s]', [aFileName]);
  ParseFileOrder(Path['Messages.In']+aFileName, ndOrder, trnWrite);
end;

procedure TFormWizardOrder.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  mr: Word;
begin
  inherited;
  if trnWrite.Active then
  begin
    case SourceFlag of
      sfMessage:
        begin
          mr:= MessageDlg('Забраковать интернет-заявку?', mtWarning, mbYesNoCancel, 0);
          CanClose:= mr <> mrCancel;
          if CanClose then
          begin
            trnWrite.Rollback;
            if mr = mrYes then
              dmOtto.MessageError(trnWrite, MessageId);
          end
        end;
      sfBlank:
        begin
          mr:= MessageDlg('Прекратить создание заявки?', mtWarning, mbYesNoCancel, 0);
          CanClose:= mr = mrYes;
          if CanClose then
            trnWrite.Rollback;
        end;
      sfDatabase:
        begin
          mr:= MessageDlg('Записать изменения в БД?', mtWarning, mbYesNoCancel, 0);
          CanClose:= mr <> mrCancel;
          if mr = mrYes then
            trnWrite.Commit
          else
            trnWrite.Rollback;
        end
    end;
  end;
end;

procedure TFormWizardOrder.wzIPageAdressNextButtonClick(Sender: TObject;
  var Stop: Boolean);
begin
//  frmAdress.Write;
  Stop:= not ndAdress.HasAttribute('ID');
end;

procedure TFormWizardOrder.wzIPageClientNextButtonClick(Sender: TObject;
  var Stop: Boolean);
begin
//  frmClient.Write;
  Stop:= not ndClient.HasAttribute('ID');
end;

procedure TFormWizardOrder.wzIPageOrderNextButtonClick(Sender: TObject;
  var Stop: Boolean);
begin
//  frmOrder.Write;
end;

procedure TFormWizardOrder.wzIPageOrderItemsNextButtonClick(
  Sender: TObject; var Stop: Boolean);
begin
//  frmOrderItems.Write;
end;

procedure TFormWizardOrder.wzIPageAdressEnterPage(Sender: TObject;
  const FromPage: TJvWizardCustomPage);
begin
///  frmAdress.FormShow(sender);
end;

procedure TFormWizardOrder.wzIPageClientEnterPage(Sender: TObject;
  const FromPage: TJvWizardCustomPage);
begin
//  frmClient.FormShow(sender);
end;

procedure TFormWizardOrder.wzIPageOrderSummaryEnterPage(Sender: TObject;
  const FromPage: TJvWizardCustomPage);
begin
//  frmOrderSummary.FormShow(sender);
end;

procedure TFormWizardOrder.wzIPageOrderEnterPage(Sender: TObject;
  const FromPage: TJvWizardCustomPage);
begin
//  frmOrder.FormShow(sender);
end;

end.
