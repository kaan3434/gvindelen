unit uWzOrderOtto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uBaseWizardForm, ActnList, JvWizard, JvWizardRouteMapNodes,
  JvExControls, DBGridEhGrouping, GridsEh, DBGridEh, ExtCtrls,
  JvExExtCtrls, JvNetscapeSplitter, JvImage, JvExtComponent, JvPanel,
  MemTableDataEh, Db, MemTableEh, FIBDataSet, pFIBDataSet, NativeXml,
  FIBDatabase, StdCtrls, Mask, DBCtrlsEh, DBLookupEh, JvExMask, JvToolEdit,
  JvMaskEdit, JvGroupHeader, JvExStdCtrls, JvGroupBox, JvValidators,
  JvErrorIndicator, JvComponentBase, JvRollOut, JvButton, JvCtrls, JvFooter,
  JvEdit, JvValidateEdit, JvCheckBox, ImgList, PngImageList, TB2Item, TBX,
  TB2Dock, TB2Toolbar, JvBaseDlg, JvProgressDialog, JvProgressComponent,
  pFIBDatabase;

type
  TWzOrderOtto = class(TBaseWizardForm)
    wzIPageOrderItems: TJvWizardInteriorPage;
    mtblOrderItems: TMemTableEh;
    dsOrderItems: TDataSource;
    fldOrderItems_ORDERITEM_ID: TIntegerField;
    fldOrderItems_MAGAZINE_ID: TIntegerField;
    fldOrderItems_PAGE_NO: TIntegerField;
    fldOrderItems_POSITION_SIGN: TStringField;
    fldOrderItems_ARTICLE_CODE: TStringField;
    fldOrderItems_DIMENSION: TStringField;
    fldOrderItems_PRICE_EUR: TFloatField;
    fldOrderItems_NAME_RUS: TStringField;
    fldOrderItems_KIND_RUS: TStringField;
    fldOrderItems_ARTICLE_ID: TIntegerField;
    qryArticles: TpFIBDataSet;
    dsArticles: TDataSource;
    qryMagazines: TpFIBDataSet;
    fldOrderItems_STATUS_ID: TIntegerField;
    wzIPageOrder: TJvWizardInteriorPage;
    qryProducts: TpFIBDataSet;
    dsProducts: TDataSource;
    qryVendors: TpFIBDataSet;
    dsVendors: TDataSource;
    wzWPageWelcome: TJvWizardWelcomePage;
    wzIPageClient: TJvWizardInteriorPage;
    qryClient: TpFIBDataSet;
    dsClients: TDataSource;
    fldOrderItems_COST_EUR: TFloatField;
    vldEdits: TJvValidators;
    erIndEdits: TJvErrorIndicator;
    vldRequireLastName: TJvRequiredFieldValidator;
    vldRequireFirstName: TJvRequiredFieldValidator;
    vldRequiredPlaceName: TJvRequiredFieldValidator;
    wzIPageAdress: TJvWizardInteriorPage;
    pnlCenterOnAdress: TPanel;
    split1: TJvNetscapeSplitter;
    gb1: TJvGroupBox;
    gb2: TJvGroupBox;
    grdPlaces: TDBGridEh;
    qryPlaces: TpFIBDataSet;
    dsPlaces: TDataSource;
    grdAdresses: TDBGridEh;
    qryAdresses: TpFIBDataSet;
    dsAdresses: TDataSource;
    qryTaxPlans: TpFIBDataSet;
    dsTaxPlans: TDataSource;
    vldRequiredPlaceType: TJvRequiredFieldValidator;
    vldRequiredAreaName: TJvRequiredFieldValidator;
    vldRequiredStreetType: TJvRequiredFieldValidator;
    vldRequiredStreetName: TJvRequiredFieldValidator;
    wzIPageFinal: TJvWizardInteriorPage;
    mtblOrderTaxs: TMemTableEh;
    dsOrderTaxs: TDataSource;
    fldOrderTaxs_ORDERTAX_ID: TIntegerField;
    fldOrderTaxs_TAXSERV_ID: TIntegerField;
    fldOrderTaxs_TAXRATE_ID: TIntegerField;
    fldOrderTaxs_COST_EUR: TFloatField;
    fldOrderTaxs_TAXSERV_NAME: TStringField;
    fldOrderTaxs_STATUS_ID: TIntegerField;
    fldOrderTaxsSTATUS_NAME: TStringField;
    fldOrderTaxs_TAXPLAN_ID: TIntegerField;
    pnlCenterOnClient: TPanel;
    grdClient: TDBGridEh;
    splitClient: TJvNetscapeSplitter;
    grdClientOrders: TDBGridEh;
    fldOrderItems_COUNT_WEIGHT: TIntegerField;
    actClientPageFirst: TAction;
    btnClientPageFirst: TButton;
    qryClientOrders: TpFIBDataSet;
    dsClientOrders: TDataSource;
    qryClientOrderItems: TpFIBDataSet;
    dsClientOrderItems: TDataSource;
    grdClientOrderItems: TDBGridEh;
    grBoxSummaryOrderItems: TJvGroupBox;
    JvFooter1: TJvFooter;
    dsOrderFullSpecifications: TDataSource;
    btnFtCommit: TJvFooterBtn;
    btnFtDraft: TJvFooterBtn;
    vldCustomProduct: TJvCustomValidator;
    vldCustomTaxPlan: TJvCustomValidator;
    vldCompareBYR2EUR: TJvCompareValidator;
    btnFtBack: TJvFooterBtn;
    btnFtStore: TJvFooterBtn;
    btnFtCancel: TJvFooterBtn;
    actOrderCreate: TAction;
    actOrderDraft: TAction;
    actOrderError: TAction;
    actOrderStore: TAction;
    pnlRightOnClient: TPanel;
    grBoxClientOnClient: TJvGroupBox;
    lblLastName: TLabel;
    lblFirstName: TLabel;
    lblMidName: TLabel;
    lblMobilePhone: TLabel;
    lbl1: TLabel;
    lblStacionarPhone: TLabel;
    medMobilePhone: TJvMaskEdit;
    dedLastName: TDBEditEh;
    dedFirstName: TDBEditEh;
    dedMidName: TDBEditEh;
    dedEmail: TDBEditEh;
    dedStaticPhone: TDBEditEh;
    grBoxAdressOnClient: TJvGroupBox;
    txtAdress: TStaticText;
    pnlRightOnAdress: TJvPanel;
    grBoxAdressOnAdress: TJvGroupBox;
    lblPostIndex: TLabel;
    lblStreetType: TLabel;
    lblFlat: TLabel;
    lblBuilding: TLabel;
    lblHouse: TLabel;
    medPostIndex: TJvMaskEdit;
    cbStreetType: TDBComboBoxEh;
    dedStreetName: TDBEditEh;
    dedFlat: TDBEditEh;
    dedBuilding: TDBEditEh;
    dedHouse: TDBEditEh;
    grBoxPlaceOnAdress: TJvGroupBox;
    lbl2: TLabel;
    lblPlace: TLabel;
    lblArea: TLabel;
    lblRegion: TLabel;
    cbPlaceType: TDBComboBoxEh;
    dedPlaceName: TDBEditEh;
    cbAreaName: TDBComboBoxEh;
    dedRegionName: TDBEditEh;
    grBoxClientOnAdress: TJvGroupBox;
    txtClientName: TStaticText;
    pnlCenterOnOrderItems: TJvPanel;
    grdOrderItems: TDBGridEh;
    imgArticle: TJvImage;
    grdArticles: TDBGridEh;
    pnlLeftOnOrder: TJvPanel;
    grBoxProductOnOrder: TJvGroupBox;
    lblVendor: TLabel;
    lblOrderProduct: TLabel;
    lbl3: TLabel;
    lblCreateDate: TLabel;
    lblExchEUR: TLabel;
    lbl4: TLabel;
    lcbVendor: TDBLookupComboboxEh;
    lcbProduct: TDBLookupComboboxEh;
    lcbTaxPlan: TDBLookupComboboxEh;
    dtedCreateDate: TDBDateTimeEditEh;
    edtBYR2EUR: TJvValidateEdit;
    edtOrderWeight: TJvValidateEdit;
    pnlCenterOnOrder: TJvPanel;
    grBoxOrderTaxs: TJvGroupBox;
    grd1: TDBGridEh;
    pnlTopOnFinal: TJvPanel;
    pnlClientOnFinal: TJvPanel;
    grBoxClientOfFinal: TJvGroupBox;
    lblClientFIO: TLabel;
    lbl5: TLabel;
    txtClientFioOnFinal: TStaticText;
    txtAdressOnFinal: TStaticText;
    pnlOrderOnFinal: TJvPanel;
    grBoxSummaryOrder: TJvGroupBox;
    lblPhonesOnFinal: TLabel;
    txtClientPhoneOnFinal: TStaticText;
    lbl6: TLabel;
    txtClientGsmOnFinal: TStaticText;
    lbl7: TLabel;
    txtClientEmailOnFinal: TStaticText;
    actOrderCancel: TAction;
    actClientSearch: TAction;
    actPlaceSearch: TAction;
    chkUseRest: TJvCheckBox;
    fldOrderItems_WEIGHT: TIntegerField;
    fldOrderItems_STATUS_NAME: TStringField;
    imgListOrderItems: TPngImageList;
    actOrderItemDelete: TAction;
    actOrderItemDublicate: TAction;
    fldOrderItems_MAGAZINE_NAME: TStringField;
    dck1: TTBXDock;
    tbrBarOrderItems: TTBXToolbar;
    btnOrderItemDublicate: TTBXItem;
    btnOrderItemDelete: TTBXItem;
    lbl8: TLabel;
    txtAccountRest: TStaticText;
    actCheckAvailable: TAction;
    btnCheckAvailable: TTBXItem;
    fldOrderItems_STATUS_SIGN: TStringField;
    fldOrderItems_FLAG_SIGN_LIST: TStringField;
    qryStatuses: TpFIBDataSet;
    fldOrderItems_AMOUNT: TSmallintField;
    qryOrderFullSpecification: TpFIBDataSet;
    grdOrderFullSpecification: TDBGridEh;
    ProgressCheckAvail: TJvProgressComponent;
    lblOrderCode: TLabel;
    txtOrderCode: TStaticText;
    fldOrderItems_STATUS_DTM: TDateTimeField;
    fldClientCLIENT_ID: TFIBIntegerField;
    fldClientFIO_TEXT: TFIBStringField;
    fldClientLAST_NAME: TFIBStringField;
    fldClientFIRST_NAME: TFIBStringField;
    fldClientMID_NAME: TFIBStringField;
    fldClientSTATUS_ID: TFIBIntegerField;
    fldClientMOBILE_PHONE: TFIBStringField;
    fldClientEMAIL: TFIBStringField;
    fldClientPLACE_ID: TFIBIntegerField;
    fldClientPLACE_TEXT: TFIBStringField;
    fldClientADRESS_ID: TFIBIntegerField;
    fldClientADRESS_TEXT: TFIBStringField;
    fldClientSTATUS_NAME: TFIBStringField;
    fldOrderItems_STATE_ID: TIntegerField;
    actOrderItemAnnul: TAction;
    btn1: TTBXItem;
    fldOrderItems_STATE_NAME: TStringField;
    procedure wzIPageOrderItemsEnterPage(Sender: TObject;
      const FromPage: TJvWizardCustomPage);
    procedure grdOrderItemsRowDetailPanelShow(Sender: TCustomDBGridEh;
      var CanShow: Boolean);
    procedure wzIPageOrderEnterPage(Sender: TObject;
      const FromPage: TJvWizardCustomPage);
    procedure lcbVendorChange(Sender: TObject);
    procedure wzIPageOrderItemsNextButtonClick(Sender: TObject;
      var Stop: Boolean);
    procedure mtblOrderItemsCalcFields(DataSet: TDataSet);
    procedure wzIPageClientEnterPage(Sender: TObject;
      const FromPage: TJvWizardCustomPage);
    procedure wzIPageClientNextButtonClick(Sender: TObject;
      var Stop: Boolean);
    procedure wzIPageAdressEnterPage(Sender: TObject;
      const FromPage: TJvWizardCustomPage);
    procedure wzIPageAdressNextButtonClick(Sender: TObject;
      var Stop: Boolean);
    procedure cbPlaceTypeChange(Sender: TObject);
    procedure grdClientDblClick(Sender: TObject);
    procedure grdAdressesDblClick(Sender: TObject);
    procedure grdPlacesDblClick(Sender: TObject);
    procedure actClientPageFirstExecute(Sender: TObject);
    procedure wzIPageOrderNextButtonClick(Sender: TObject;
      var Stop: Boolean);
    procedure vldCustomProductValidate(Sender: TObject;
      ValueToValidate: Variant; var Valid: Boolean);
    procedure vldCustomTaxPlanValidate(Sender: TObject;
      ValueToValidate: Variant; var Valid: Boolean);
    procedure wzIPageFinalEnterPage(Sender: TObject;
      const FromPage: TJvWizardCustomPage);
    procedure btnFtBackClick(Sender: TObject);
    procedure actListWzrdBtnUpdate(Action: TBasicAction;
      var Handled: Boolean);
    procedure actOrderCreateExecute(Sender: TObject);
    procedure actOrderDraftExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure actClientSearchExecute(Sender: TObject);
    procedure actPlaceSearchExecute(Sender: TObject);
    procedure dedLastNameExit(Sender: TObject);
    procedure grdArticlesDblClick(Sender: TObject);
    procedure mtblOrderItemsBeforePost(DataSet: TDataSet);
    procedure grdArticlesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mtblOrderTaxItemsCalcFields(DataSet: TDataSet);
    procedure actCheckAvailableExecute(Sender: TObject);
    procedure mtblOrderItemsSetFieldValue(MemTable: TCustomMemTableEh;
      Field: TField; var Value: Variant);
    procedure grdOrderItemsColEnter(Sender: TObject);
    procedure ProgressCheckAvailShow(Sender: TObject);
    procedure EditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditEnter(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actOrderCancelExecute(Sender: TObject);
    procedure xNameExit(Sender: TObject);
    procedure dedPlaceNameExit(Sender: TObject);
    procedure mtblOrderItemsBeforeDelete(DataSet: TDataSet);
    procedure dedPlaceNameChange(Sender: TObject);
    procedure actOrderStoreExecute(Sender: TObject);
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
    function mtblOrderItemsToXML: Boolean;
    function FullAdress: String;
    function ClientToXml: Boolean;
    function Adress2Xml: Boolean;
    function Order2Xml: Boolean;
    function Place2Xml: Boolean;
    procedure qryArticles2OrderItems;
    procedure XmlTomtblOrderItems;

  public
    { Public declarations }
    OrderId: Integer;
    MessageId: Integer;
    FileName: String;
    constructor CreateBlank(aOwner: TComponent);
    constructor CreateFromMessage(aOwner: TComponent; aMessageId: Integer);
    procedure BuildXml; override;
    procedure GetFromDB; override;
    procedure UpdateCaptions; override;
  end;

implementation

uses
  udmOtto, uOttoArticleUpdate, GvNativeXml, GvStr, GvVars, EhlibFIB, Math,
  GvKbd, uParseOrder;

{$R *.dfm}

constructor TWzOrderOtto.CreateBlank(aOwner: TComponent);
begin
  inherited Create(aOwner, 'ORDER');
  trnWrite.StartTransaction;
  OrderId:= dmOtto.GetNewObjectId('ORDER');
  SetXmlAttr(ndOrder, 'ID', OrderId);
  SetXmlAttr(ndOrder, 'BYR2EUR', dmOtto.SettingGet(trnRead, 'BYR2EUR'));
  SetXmlAttr(ndOrder, 'CREATE_DTM', Now);
  dmOtto.ActionExecute(trnWrite, 'ORDER_CREATE', ndOrder);
end;

constructor TWzOrderOtto.CreateFromMessage(aOwner: TComponent;
  aMessageId: Integer);
begin
  inherited Create(aOwner, 'ORDER');
  MessageId:= aMessageId;
//  ParseOrderXml(MessageId, ndOrder, trnWrite);
  OrderId:= dmOtto.GetNewObjectId('ORDER');
  SetXmlAttr(ndOrder, 'ID', OrderId);
  SetXmlAttr(ndOrder, 'BYR2EUR', dmOtto.SettingGet(trnRead, 'BYR2EUR'));
  SetXmlAttr(ndOrder, 'CREATE_DTM', Now);
  dmOtto.ActionExecute(trnWrite, 'ORDER_CREATE', ndOrder);
  Caption:= GetXmlAttr(ndOrder, 'FILE_NAME');
end;

procedure TWzOrderOtto.GetFromDB;
var
  OrderStatusId: Integer;
  FlagList: variant;
begin
  dmOtto.ObjectGet(ndOrder, ObjectId, trnRead);
  dmOtto.OrderItemsGet(ndOrderItems, ObjectId, trnRead);
  dmOtto.OrderTaxsGet(ndOrderTaxs, ObjectId, trnRead);
  dmOtto.ObjectGet(ndClient, GetXmlAttrValue(ndOrder, 'CLIENT_ID'), trnRead);
  dmOtto.ObjectGet(ndAdress, GetXmlAttrValue(ndOrder, 'ADRESS_ID'), trnRead);
  dmOtto.ObjectGet(ndPlace, GetXmlAttrValue(ndAdress, 'PLACE_ID'), trnRead);
  dmOtto.ObjectGet(ndAccount, GetXmlAttrValue(ndClient, 'ACCOUNT_ID'), trnRead);
  qryStatuses.Open;
  FlagList:= qryStatuses.Lookup('STATUS_ID', GetXmlAttrValue(ndOrder, 'STATUS_ID'), 'FLAG_SIGN_LIST');
  if FlagList = null then FlagList:= '';

  grBoxClientOnClient.Enabled:= Pos(',EDITABLE,', FlagList) > 0;
  grBoxPlaceOnAdress.Enabled:= Pos(',EDITABLE,', FlagList) > 0;
  grBoxAdressOnAdress.Enabled:= Pos(',EDITABLE,', FlagList) > 0;
  grBoxProductOnOrder.Enabled:= Pos(',EDITABLE,', FlagList) > 0;
  wzWPageWelcome.Hide;
  wzForm.ActivePage:= wzIPageOrderItems;
end;

procedure TWzOrderOtto.BuildXml;
begin
  inherited;
  ndOrder:= Root;
  ndOrder.WriteAttributeDateTime('CREATE_DTM', now);
  ndAdress:= ndOrder.NodeFindOrCreate('ADRESS');
  ndPlace:= ndAdress.NodeFindOrCreate('PLACE');
  ndClient:= ndAdress.NodeFindOrCreate('CLIENT');
  ndOrderItems:= ndOrder.NodeFindOrCreate('ORDERITEMS');
  ndOrderTaxs:= ndOrder.NodeFindOrCreate('ORDERTAXS');
  ndAccount:= ndClient.NodeFindOrCreate('ACCOUNT');
end;

procedure TWzOrderOtto.FormDestroy(Sender: TObject);
begin
  inherited;
  mtblOrderItems.Close;
  mtblOrderTaxs.Close;
  qryOrderFullSpecification.Close;
  qryMagazines.Close;
  qryArticles.Close;
  qryPlaces.Close;
  qryAdresses.Close;
  qryProducts.Close;
  qryVendors.Close;
  qryClient.Close;
  qryTaxPlans.Close;
  qryClientOrders.Close;
  qryClientOrderItems.Close;
end;

// WizardPage OrderItems

procedure TWzOrderOtto.wzIPageOrderItemsEnterPage(Sender: TObject;
  const FromPage: TJvWizardCustomPage);
begin
  if not mtblOrderItems.Active then mtblOrderItems.Open;
  if not qryMagazines.Active then qryMagazines.Open;
  if not qryArticles.Active then qryArticles.Open;

  XmlTomtblOrderItems;
end;

procedure TWzOrderOtto.grdOrderItemsRowDetailPanelShow(
  Sender: TCustomDBGridEh; var CanShow: Boolean);
var
  ArticleSign: variant;
begin
  CanShow:= False;
  if (mtblOrderItems['ARTICLE_CODE'] <> null) then
  begin
    ArticleSign:= dmOtto.dbOtto.QueryValue(
      'select o_article_sign from articlesign_detect(:article_code, :magazine_id)',
      0, [mtblOrderItems['ARTICLE_CODE'], mtblOrderItems['MAGAZINE_ID']],
      dmOtto.dbOtto.DefaultUpdateTransaction);
    if not VarIsNull(ArticleSign) then
    begin
      if qryArticles.Active then qryArticles.Close;
      qryArticles.OpenWP([ArticleSign]);
      CanShow:= True;
    end;
  end;
end;

procedure TWzOrderOtto.XmlTomtblOrderItems;
begin
  BatchMoveXMLNodes2Dataset(mtblOrderItems, ndOrderItems,
    'ORDERITEM_ID=ID;MAGAZINE_ID;PAGE_NO;POSITION_SIGN;ARTICLE_ID;ARTICLE_CODE;'+
    'DIMENSION;PRICE_EUR;WEIGHT;NAME_RUS;KIND_RUS;STATUS_ID;STATE_ID', cmReplace);
  if mtblOrderItems.State <> dsBrowse then
    mtblOrderItems.Post;
end;

function TWzOrderOtto.mtblOrderItemsToXML: Boolean;
var
  OrderItemId: Integer;
begin
  ndOrderItems.NodesClear;
  with mtblOrderItems do
  begin
    First;
    while not Eof do
    begin
      ndOrderItem:= ndOrderItems.NodeNew('ORDERITEM');
      OrderItemId:= mtblOrderItems['ORDERITEM_ID'];
      BatchMoveFields2(ndOrderItem, mtblOrderItems,
        'ID=ORDERITEM_ID;MAGAZINE_ID;ARTICLE_CODE;DIMENSION;'+
        'PRICE_EUR;COST_EUR;NAME_RUS;STATUS_ID', true);
      BatchMoveFields2(ndOrderItem, mtblOrderItems,
        'ARTICLE_ID;PAGE_NO;POSITION_SIGN;STATUS_SIGN;KIND_RUS;STATE_ID;WEIGHT', false);
      BatchMoveFields2(ndOrderItem, ndOrder, 'ORDER_ID=ID');
      dmOtto.ActionExecute(trnWrite, ndOrderItem);
      dmOtto.ObjectGet(ndOrderItem, OrderItemId, trnWrite);
      mtblOrderItems.Next;
    end;
  end;
  result:= true
end;

procedure TWzOrderOtto.wzIPageOrderItemsNextButtonClick(Sender: TObject;
  var Stop: Boolean);
begin
  Stop:= not mtblOrderItemsToXML;
end;

// mtblOrderItems

procedure TWzOrderOtto.mtblOrderItemsCalcFields(DataSet: TDataSet);
var
  FlagSignList: string;
  CostSign: ShortInt;
begin
  FlagSignList:= DataSet.FieldByName('FLAG_SIGN_LIST').AsString;
  if Pos(',DEBIT,', FlagSignList) > 0 then
    CostSign:= -1
  else
  if Pos(',CREDIT,', FlagSignList) > 0 then
    CostSign:= 1
  else
    CostSign:= 0;
  DataSet['AMOUNT']:= Abs(CostSign);
  Dataset['COST_EUR']:= DataSet['PRICE_EUR']*DataSet['AMOUNT']*CostSign;
end;

procedure TWzOrderOtto.mtblOrderItemsSetFieldValue(
  MemTable: TCustomMemTableEh; Field: TField; var Value: Variant);
begin
  if (Field.FieldName = 'ARTICLE_CODE') and (Value <> '') then
  begin
    if MemTable['STATUS_ID'] = null then
      MemTable['STATUS_ID']:= dmOtto.GetDefaultStatusId('ORDERITEM');
  end;
end;

procedure TWzOrderOtto.ProgressCheckAvailShow(Sender: TObject);
var
  PluginExec: procedure (URL, RootNodeName: WideString; var aParams: WideString); stdcall;
  PluginName: String;
  URL: WideString;
  handle: THandle;
  XmlText: UTF8String;
  WXml: WideString;
  xmlAvail, xmlArticle: TNativeXml;
  i, j: Integer;
  nl: TXmlNodeList;
  ArticleId: variant;
  aWeight: variant;
  nArticleSign, aArticleSign: string;
  aDimension, nDimension, aColor, aDescription: string;
begin
  ProgressCheckAvail.ProgressMax:= ndOrderItems.NodeCount;
  ProgressCheckAvail.ProgressPosition:= 0;

  for i:= 0 to ndOrderItems.NodeCount - 1 do
  begin
    ndOrderItem:= ndOrderItems[i];
    if Pos(',DELETEABLE,', dmOtto.GetFlagListById(GetXmlAttrValue(ndOrderItem, 'STATUS_ID'))) > 0 then
    begin
      nDimension:= GetXmlAttrValue(ndOrderItem, 'DIMENSION');
      nArticleSign:= dmOtto.GetArticleSign(GetXmlAttrValue(ndOrderItem, 'ARTICLE_CODE'),
                           GetXmlAttrValue(ndOrderItem, 'MAGAZINE_ID'));
      ProgressCheckAvail.ProgressStepIt;

      PluginName:= 'otto_check_available';
      Url:= dmOtto.dbOtto.QueryValue('select o_value from plugin_value(:plugin_sign, :param_sign)',
          0, [PluginName, 'URL']);

      handle := LoadLibrary('request_xml.plg');
      xmlAvail:= TNativeXml.Create;
      try
        if handle > 0 then
        try
          @PluginExec := GetProcAddress(handle,'Execute');
          XmlText:= ndOrderItem.WriteToString;
          WXml:= XmlText;
          PluginExec(url, 'availability', WXml);
          if WXml <> '' then
            xmlAvail.ReadFromString(WXml);
        finally
          FreeLibrary(handle);
        end;
        BatchMoveFields2(ndOrderItem, xmlAvail.Root, 'AVAILABLE=available;AVAILABILITY_CODE=availability_code');
        if AttrExists(ndOrderItem, 'AVAILABLE') then
        begin
          Case GetXmlAttrValue(ndOrderItem, 'AVAILABLE') of
           0: begin
                SetXmlAttr(ndOrderItem, 'STATE_ID', dmOtto.GetStatusBySign(ndOrderItem, 'UNAVAILABLE'));
                SetXmlAttr(ndOrderItem, 'STATUS_ID', dmOtto.GetStatusBySign(ndOrderItem, 'SOLD'));
              end;
           1: SetXmlAttr(ndOrderItem, 'STATE_ID', dmOtto.GetStatusBySign(ndOrderItem, 'AVAILABLE'));
           2: SetXmlAttr(ndOrderItem, 'STATE_ID', dmOtto.GetStatusBySign(ndOrderItem, 'DELAY3WEEK'));
           21: SetXmlAttr(ndOrderItem, 'STATE_ID', dmOtto.GetStatusBySign(ndOrderItem, 'DELAY3WEEK'));
          end;
        end;
      finally
        xmlAvail.Free;
      end;

      if GetXmlAttrValue(ndOrderItem, 'MAGAZINE_ID') = 1 then
      begin
        PluginName:= 'otto_get_article';
        Url:= dmOtto.dbOtto.QueryValue('select o_value from plugin_value(:plugin_sign, :param_sign)',
           0, [PluginName, 'URL']);
        handle := LoadLibrary('request_xml.plg');
        xmlArticle:= TNativeXml.Create;
        try
          if handle > 0 then
          try
            @PluginExec := GetProcAddress(handle,'Execute');
            XmlText:= ndOrderItem.WriteToString;
            WXml:= XmlText;
            PluginExec(url, 'ArticleSign', WXml);
            if WXml <> '' then
            begin
              xmlArticle.ReadFromString(WXml);
              xmlArticle.XmlFormat:= xfReadable;
              xmlArticle.SaveToFile(GetXmlAttr(ndOrderItem, 'ARTICLE_CODE', Path['Articles'], '.xml'));
            end;
          finally
            FreeLibrary(handle);
          end;
          nl:= TXmlNodeList.Create;
          try
            xmlArticle.Root.FindNodes('Article', nl);
            For j:= 0 to nl.Count-1 do
            begin
              aArticleSign:= dmOtto.GetArticleSign(GetXmlAttrValue(nl[j], 'article_code'),
                GetXmlAttrValue(ndOrderItem, 'MAGAZINE_ID'));
              aDimension:= CopyFront4(GetXmlAttrValue(nl[j], 'dimension', '0'), '(');
              aWeight:= trnRead.DefaultDatabase.QueryValue(
                'select max(weight) from v_articles where article_sign = :article_sign and dimension = :dimension',
                0, [aArticleSign, aDimension]);
              aColor:= dmOtto.Recode('ARTICLECODE', 'DIMENSION', GetXmlAttrValue(nl[j].Parent, 'DIMENSION'));
              aDescription:= dmOtto.Recode('ARTICLECODE', 'NAME', GetXmlAttrValue(nl[j].Parent, 'name'));
              ArticleId:= trnWrite.DefaultDatabase.QueryValue(
                'select o_article_id from article_goc(:magazine_id,:article_code, :color, :dimension, :price_eur, :weight, :description, :image)',
                0, [GetXmlAttrValue(ndOrderItem, 'MAGAZINE_ID'),
                    GetXmlAttrValue(nl[j], 'article_code'),
                    aColor,
                    aDimension,
                    GetXmlAttrValue(nl[j], 'price_eur'),
                    aWeight,
                    aDescription,
                    GetXmlAttrValue(nl[j].Parent, 'image_link')]);
              trnWrite.DefaultDatabase.QueryValue(
                'update articlecodes set color = :color where article_sign = :article_sign',
                0, [aColor, aArticleSign], trnWrite);

              if (aArticleSign = nArticleSign) and (aDimension = nDimension) then
              begin
                SetXmlAttr(ndOrderItem, 'ARTICLE_ID', ArticleId);
                if GetXmlAttrValue(nl[j], 'price_eur') <> GetXmlAttrValue(ndOrderItem, 'PRICE_EUR') then
                  SetXmlAttr(ndOrderItem, 'STATUS_ID', dmOtto.GetStatusBySign(ndOrderItem, 'WRONGPRICE'));
              end;
            end;
          finally
            nl.Free;
          end;
        finally
          xmlArticle.Free;
        end;
      end;

      aWeight:= trnWrite.DefaultDatabase.QueryValue(
        'select max(a.weight) from v_articles a where a.article_sign = :article_sign and a.dimension = :dimension',
        0, [nArticleSign, nDimension], trnWrite);
      SetXmlAttr(ndOrderItem, 'WEIGHT', aWeight);
      if mtblOrderItems.Locate('ORDERITEM_ID', GetXmlAttrValue(ndOrderItem, 'ID'), []) then
      begin
        if mtblOrderItems.State = dsBrowse then
            mtblOrderItems.Edit;
        BatchMoveFields2(mtblOrderItems, ndOrderItem,
          'ARTICLE_ID;STATUS_ID;STATE_ID;WEIGHT');
        mtblOrderItems.Post;
      end;
    end
  end;
end;

procedure TWzOrderOtto.actCheckAvailableExecute(Sender: TObject);
begin
  mtblOrderItemsToXML;
  ProgressCheckAvail.Execute;
  qryArticles.CloseOpen(true);
end;

procedure TWzOrderOtto.grdOrderItemsColEnter(Sender: TObject);
var
  Column: TColumnEh;
begin
  Column:= grdOrderItems.Columns[grdOrderItems.col-1];
  dmOtto.SetKeyLayout(Column.Tag);
end;







// WizardPage Order

procedure TWzOrderOtto.vldCustomProductValidate(Sender: TObject;
  ValueToValidate: Variant; var Valid: Boolean);
begin
  Valid:= not VarIsNull(lcbProduct.Value);
end;

procedure TWzOrderOtto.vldCustomTaxPlanValidate(Sender: TObject;
  ValueToValidate: Variant; var Valid: Boolean);
begin
  Valid:= not VarIsNull(lcbTaxPlan.Value);
end;

procedure TWzOrderOtto.lcbVendorChange(Sender: TObject);
begin
  lcbProduct.Enabled:= lcbVendor.Value <> null;
end;

procedure TWzOrderOtto.wzIPageOrderEnterPage(Sender: TObject;
  const FromPage: TJvWizardCustomPage);
begin
  if not qryVendors.Active then qryVendors.Open;
  if not qryProducts.Active then qryProducts.Open;
  if not qryTaxPlans.Active then qryTaxPlans.Open;
  lcbVendor.Value:= GetXmlAttrValue(ndOrder, 'VENDOR_ID');
  lcbProduct.Value:= GetXmlAttrValue(ndOrder, 'PRODUCT_ID');
  lcbTaxPlan.Value:= GetXmlAttrValue(ndOrder, 'TAXPLAN_ID');
  dtedCreateDate.Value:= GetXmlAttrValue(ndOrder, 'CREATE_DTM');
  if Not AttrExists(ndOrder, 'BYR2EUR') then
    SetXmlAttr(ndOrder, 'BYR2EUR', dmOtto.SettingGet(trnRead, 'BYR2EUR'));
  edtBYR2EUR.Value:= GetXmlAttrValue(ndOrder, 'BYR2EUR');

  if AttrExists(ndOrder, 'WEIGHT') then
    edtOrderWeight.Value:= GetXmlAttrValue(ndOrder, 'WEIGHT')
end;

procedure TWzOrderOtto.wzIPageOrderNextButtonClick(Sender: TObject;
  var Stop: Boolean);
begin
  Stop:= not (vldEdits.Validate('Order') and Order2Xml);
end;

function TWzOrderOtto.Order2Xml: Boolean;

begin
  Result:= False;
  try
    SetXmlAttr(ndOrder, 'VENDOR_ID', lcbVendor.Value);
    SetXmlAttr(ndOrder, 'PRODUCT_ID', lcbProduct.Value);
    SetXmlAttr(ndOrder, 'TAXPLAN_ID', lcbTaxPlan.Value);
    SetXmlAttr(ndOrder, 'CHANGED', 1);
    dmOtto.ActionExecute(trnWrite, ndOrder);
    dmOtto.ActionExecute(trnWrite, 'ORDER_FOREACH_TAXRATE', ndOrder);
    Result:= True;
  except
  end;
end;









// ClientAdress

function TWzOrderOtto.FullAdress: String;
begin
  result:= GetXmlAttr(ndAdress, 'POSTINDEX', '', '. ') +
    GetXmlAttr(ndPlace, 'PLACE_NAME', ' '+ndPlace.ReadAttributeString('PLACETYPE_SIGN', 'г')+'. ') +
    GetXmlAttr(ndPlace, 'AREA_NAME', ' ', ' р-н. ') +
    GetXmlAttr(ndPlace, 'REGION_NAME', ' ', ' обл.') +
    GetXmlAttr(ndAdress, 'STREET_NAME', ndAdress.ReadAttributeString('STREETTYPE_SIGN', ', ул.')+' ')+
    GetXmlAttr(ndAdress, 'HOUSE', ', ')+
    GetXmlAttr(ndAdress, 'BUILDING', ', корп. ')+
    GetXmlAttr(ndAdress, 'FLAT', ', кв. ');
  result:= ReplaceAll(Result, '  ', ' ');
end;

procedure TWzOrderOtto.wzIPageClientEnterPage(Sender: TObject;
  const FromPage: TJvWizardCustomPage);
begin
  txtAdress.Caption:= FullAdress;
  dedLastName.Text:= GetXmlAttr(ndClient, 'LAST_NAME');
  dedFirstName.Text:= GetXmlAttr(ndClient, 'FIRST_NAME');
  dedMidName.Text:= GetXmlAttr(ndClient, 'MID_NAME');
  medMobilePhone.Text:= GetXmlAttr(ndClient, 'MOBILE_PHONE');
  dedStaticPhone.Text:= GetXmlAttr(ndClient, 'STATIC_PHONE');
  dedEmail.Text:= GetXmlAttr(ndClient, 'EMAIL');
  actClientSearch.Execute;
end;

procedure TWzOrderOtto.grdClientDblClick(Sender: TObject);
begin
  if grBoxClientOnClient.Enabled then
  begin
    dmOtto.ClientRead(ndClient, qryClient['CLIENT_ID'], trnRead);
    SetXmlAttr(ndOrder, 'CLIENT_ID', qryClient['CLIENT_ID']);
    SetXmlAttr(ndClient, 'CHANGED', 0);
    UpdateCaptions;
    wzForm.SelectNextPage;
  end;
end;

function TWzOrderOtto.ClientToXml: Boolean;
begin
  Result:= False;
  try
    SetXmlAttr(ndClient, 'LAST_NAME', dedLastName.Text);
    SetXmlAttr(ndClient, 'FIRST_NAME', dedFirstName.Text);
    SetXmlAttr(ndClient, 'MID_NAME', dedMidName.Text);
    SetXmlAttr(ndClient, 'MOBILE_PHONE', medMobilePhone.Text);
    SetXmlAttr(ndClient, 'STATIC_PHONE', dedStaticPhone.Text);
    SetXmlAttr(ndClient, 'EMAIL', dedEmail.Text);
    if not AttrExists(ndClient, 'ID') then
    begin
      if MessageDlg(Format('Зарегистрировать клиента %s %s %s?',
                    [dedLastName.Text, dedFirstName.Text, dedMidName.Text]),
                    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        SetXmlAttr(ndAccount, 'ID', dmOtto.GetNewObjectId('ACCOUNT'));
        SetXmlAttr(ndClient, 'ID', dmOtto.GetNewObjectId('CLIENT'));
        BatchMoveFields2(ndClient, ndAccount, 'ACCOUNT_ID=ID');
        dmOtto.ActionExecute(trnWrite, 'ACCOUNT_CREATE', ndAccount);
        dmOtto.ActionExecute(trnWrite, 'CLIENT_CREATE', ndClient);
        UpdateCaptions;
      end
      else
        Exit;
    end;
    dmOtto.ActionExecute(trnWrite, ndClient);
    dmOtto.ObjectGet(ndAccount, GetXmlAttrValue(ndAccount, 'ID'), trnWrite);
    Result:= true;
  except
  end;
end;

procedure TWzOrderOtto.wzIPageClientNextButtonClick(Sender: TObject;
  var Stop: Boolean);
begin
  Stop:= not (vldEdits.Validate('Client') and ClientToXml);
end;

procedure TWzOrderOtto.actClientSearchExecute(Sender: TObject);
begin
  SetXmlAttr(ndClient, 'LAST_NAME', dedLastName.Text);
  if ndClient.ReadAttributeString('LAST_NAME', '') <> '' then
  begin
    qryClient.DisableControls;
    qryClientOrders.DisableControls;
    try
      if qryClient.Active then qryClient.Close;
      qryClient.OpenWP([dedLastName.Text]);
      qryClientOrders.CloseOpen(True);
      qryClientOrderItems.CloseOpen(True);
    finally
      qryClient.EnableControls;
      qryClientOrders.EnableControls;
    end;
  end;
end;















// wzPagePlaces

function TWzOrderOtto.Place2Xml: Boolean;
begin
  Result:= false;
  try
    Combo2XmlAttr(cbPlaceType, ndPlace, 'PLACETYPE_CODE', 'PLACETYPE_SIGN');
    SetXmlAttr(ndPlace, 'PLACE_NAME', dedPlaceName.Text);
    Combo2XmlAttr(cbAreaName, ndPlace, 'AREA_ID', 'AREA_NAME');
    SetXmlAttr(ndPlace, 'REGION_NAME', dedRegionName.Text);
    if not AttrExists(ndPlace, 'ID') then
    begin
      if GetXmlAttrValue(ndPlace, 'PLACETYPE_CODE') <= 4 then
      begin
        ShowMessage('Все населенные пункты типа "город" уже зарегистрированы. Выберите из существующих или укажите другой тип населенного пункта.');
        Exit;
      end;
      if MessageDlg(Format('Зарегистрировать населенный пункт %s %s %s?',
                    [cbPlaceType.Text+'.',
                     dedPlaceName.Text,
                     cbAreaName.Text]),
                    mtConfirmation, [mbYes,mbNo], 0) = mrYes then
      begin
        SetXmlAttr(ndPlace, 'ID', dmOtto.GetNewObjectId('PLACE'));
        dmOtto.ActionExecute(trnWrite, 'PLACE_CREATE', ndPlace);
        UpdateCaptions;
      end
      else
        Exit;
    end;
    Result:= True;
  except
  end;
end;

function TWzOrderOtto.Adress2Xml: Boolean;

begin
  Result:= false;
  try
    SetXmlAttr(ndAdress, 'PLACE_ID', GetXmlAttrValue(ndPlace, 'ID'));
    SetXmlAttr(ndAdress, 'POSTINDEX', medPostIndex.Text);
    Combo2XmlAttr(cbStreetType, ndAdress, 'STREETTYPE_CODE', 'STREETTYPE_SIGN');
    SetXmlAttr(ndAdress, 'STREET_NAME', dedStreetName.Text);
    SetXmlAttr(ndAdress, 'HOUSE', dedHouse.Text);
    SetXmlAttr(ndAdress, 'BUILDING', dedBuilding.Text);
    SetXmlAttr(ndAdress, 'FLAT', dedFlat.Text);
    if not AttrExists(ndAdress, 'ID') then
    begin
      if AttrExists(ndClient, 'STATUS_ID') then
      begin
        if MessageDlg('Зарегистрировать новый адрес клиента?',
               mtConfirmation, [mbYes, mbNo], 0) = mrYes then
          SetXmlAttr(ndAdress, 'ID', dmOtto.GetNewObjectId('ADRESS'))
        else
          Exit;
      end
      else
        SetXmlAttr(ndAdress, 'ID', dmOtto.GetNewObjectId('ADRESS'));
      BatchMoveFields2(ndAdress, ndClient, 'CLIENT_ID=ID');
      dmOtto.ActionExecute(trnWrite, 'ADRESS_CREATE', ndAdress);
      UpdateCaptions;
    end
    else
      dmOtto.ActionExecute(trnWrite, ndAdress);
    Result:= True;
  except
  end;
end;

procedure TWzOrderOtto.wzIPageAdressEnterPage(Sender: TObject;
  const FromPage: TJvWizardCustomPage);
begin
  if cbPlaceType.KeyItems.Count = 0 then
    dmOtto.FillComboStrings(cbPlaceType.KeyItems, cbPlaceType.Items,
      'select placetype_code, placetype_sign from PlaceTypes order by placetype_sign', trnRead);
  if cbAreaName.KeyItems.Count = 0 then
    dmOtto.FillComboStrings(cbAreaName.KeyItems, cbAreaName.Items,
      'select place_id, place_name from Places where placetype_code = 3 order by place_name', trnRead);

  if cbStreetType.KeyItems.Count = 0 then
    dmOtto.FillComboStrings(cbStreetType.KeyItems, cbStreetType.Items,
      'select streettype_code, streettype_sign from StreetTypes order by streettype_sign', trnRead);

  qryAdresses.OpenWP([GetXmlAttrValue(ndClient, 'ID')]);
  if qryAdresses.RecordCount = 1 then
    dmOtto.AdressRead(ndAdress, qryAdresses['ADRESS_ID'], trnRead);

  txtClientName.Caption:= GetXmlAttr(ndClient, 'LAST_NAME') +
    GetXmlAttr(ndClient, 'FIRST_NAME', ' ')+
    GetXmlAttr(ndClient, 'MID_NAME', ' ');
  if not qryPlaces.Active then
    qryPlaces.OpenWP([GetXmlAttrValue(ndPlace, 'PLACE_NAME')]);

  XmlAttr2Combo(cbPlaceType, ndPlace, 'PLACETYPE_CODE', 'PLACETYPE_SIGN', 'г');
  dedPlaceName.Text:= GetXmlAttr(ndPlace, 'PLACE_NAME');
  XmlAttr2Combo(cbAreaName, ndPlace, 'AREA_ID', 'AREA_NAME');
  dedRegionName.Text:= GetXmlAttr(ndPlace, 'REGION_NAME');

  actPlaceSearch.Execute;

  medPostIndex.Text:= GetXmlAttr(ndAdress, 'POSTINDEX');
  XmlAttr2Combo(cbStreetType, ndAdress, 'STREETTYPE_CODE', 'STREETTYPE_SIGN', 'ул');
  dedStreetName.Text:= GetXmlAttr(ndAdress, 'STREET_NAME');
  dedHouse.Text:= GetXmlAttr(ndAdress, 'HOUSE');
  dedBuilding.Text:= GetXmlAttr(ndAdress, 'BUILDING');
  dedFlat.Text:= GetXmlAttr(ndAdress, 'FLAT');
  UpdateCaptions;
end;

procedure TWzOrderOtto.wzIPageAdressNextButtonClick(Sender: TObject;
  var Stop: Boolean);
begin
  Stop:= not vldEdits.Validate('Adress');
  Stop:= Stop or (not Place2Xml);
  Stop:= Stop or (not Adress2Xml);
end;

procedure TWzOrderOtto.cbPlaceTypeChange(Sender: TObject);
var
  NeedArea: Boolean;
begin
  NeedArea:= StrToInt(cbPlaceType.KeyItems[cbPlaceType.ItemIndex]) > 4;
  cbAreaName.Visible:= NeedArea;
  vldRequiredAreaName.Enabled:= NeedArea;
end;

procedure TWzOrderOtto.grdAdressesDblClick(Sender: TObject);
begin
  if grBoxAdressOnAdress.Enabled then
  begin
    dmOtto.AdressRead(ndAdress, qryAdresses['ADRESS_ID'], trnRead);
    SetXmlAttr(ndAdress, 'CHANGED', 0);
    SetXmlAttr(ndPlace, 'CHANGED', 0);
    UpdateCaptions;
  end;
end;

procedure TWzOrderOtto.grdPlacesDblClick(Sender: TObject);
begin
  if grBoxPlaceOnAdress.Enabled then
  begin
    dmOtto.PlaceRead(ndPlace, qryPlaces['PLACE_ID'], trnRead);
    SetXmlAttr(ndPlace, 'CHANGED', 0);
    UpdateCaptions;
  end;
end;

procedure TWzOrderOtto.actPlaceSearchExecute(Sender: TObject);
begin
  SetXmlAttr(ndPlace, 'PLACE_NAME', dedPlaceName.Text);
  if ndPlace.ReadAttributeString('PLACE_NAME', '') <> '' then
  begin
    qryPlaces.DisableControls;
    try
      if qryPlaces.Active then qryPlaces.Close;
      qryPlaces.OpenWP([dedPlaceName.Text]);
    finally
      qryPlaces.EnableControls;
    end;
  end;
end;







// WelcomePage

procedure TWzOrderOtto.actClientPageFirstExecute(Sender: TObject);
begin
  if wzForm.Pages[1] = wzIPageOrderItems then
  begin
    wzForm.Pages.Exchange(1, 3);
    wzForm.Pages.Exchange(2, 4);
  end;
  wzForm.SelectNextPage;
end;




// Final Page

procedure TWzOrderOtto.wzIPageFinalEnterPage(Sender: TObject;
  const FromPage: TJvWizardCustomPage);
var
  i: Integer;
begin
  BatchMoveFields2(ndOrder, ndClient, 'CLIENT_ID=ID');
  BatchMoveFields2(ndOrder, ndAdress, 'ADRESS_ID=ID');
  dmOtto.ActionExecute(trnWrite, ndOrder);

  qryOrderFullSpecification.Close;
  qryOrderFullSpecification.Transaction:= trnWrite;
  qryOrderFullSpecification.OpenWP([OrderId]);

  ndOrderTaxs.NodesClear;
  dmOtto.OrderTaxsGet(ndOrderTaxs, OrderId, trnWrite);
  wzIPageFinal.VisibleButtons:= [];

  txtClientFioOnFinal.Caption:= GetXmlAttr(ndClient, 'LAST_NAME')+
    GetXmlAttr(ndClient, 'FIRST_NAME', ' ')+
    GetXmlAttr(ndClient, 'MID_NAME', ' ');

  txtClientPhoneOnFinal.Caption:= GetXmlAttr(ndClient, 'STATIC_PHONE');
  txtClientGsmOnFinal.Caption:= GetXmlAttr(ndClient, 'MOBILE_PHONE');
  txtClientEmailOnFinal.Caption:= GetXmlAttr(ndClient, 'EMAIL');
  txtAdressOnFinal.Caption:= FullAdress;
  txtAccountRest.Caption:= GetXmlAttr(ndAccount, 'REST_EUR', '', ' EUR');
end;

procedure TWzOrderOtto.btnFtBackClick(Sender: TObject);
begin
  wzForm.SelectPriorPage;
end;

procedure TWzOrderOtto.actOrderDraftExecute(Sender: TObject);
begin
  try
    dmOtto.ActionExecute(trnWrite, ndOrder, 0, 'DRAFT');
    trnWrite.Commit;
  except
    trnWrite.Rollback;
  end;
  trnRead.Commit;
  trnRead.StartTransaction;
  dmOtto.ObjectGet(ndOrder, ObjectId, trnRead);
  qryOrderFullSpecification.Transaction:= trnRead;
  qryOrderFullSpecification.OpenWP([ObjectId]);
  ShowMessage('Заявка сохранена как черновик');
end;

procedure TWzOrderOtto.actOrderCreateExecute(Sender: TObject);
var
  OrderId: Integer;
  OrderCode: string;
begin
  SetXmlAttr(ndOrder, 'BYR2EUR', dmOtto.SettingGet(trnRead, 'BYR2EUR'));
  OrderCode:= InputBox('Создание заявки', 'Введите номер заявки без буквы', '');
  if OrderCode = '' then
    OrderCode:= dmOtto.GetNextCounterValue('PRODUCT', 'ORDER_CODE', GetXmlAttrValue(ndOrder, 'PRODUCT_ID'))
  else
    OrderCode:= 'С'+FillFront(OrderCode, 5, '0');
  SetXmlAttr(ndOrder, 'ORDER_CODE', OrderCode);
  txtOrderCode.Caption:= GetXmlAttr(ndOrder, 'ORDER_CODE');
  Caption:= txtOrderCode.Caption;
  OrderId:= GetXmlAttrValue(ndOrder, 'ID');
  try
    dmOtto.ActionExecute(trnWrite, ndOrder, 0, 'APPROVED');
    if MessageId > 0 then
      dmOtto.MessageSuccess(trnWrite, MessageId);
    trnWrite.Commit;
  except
    trnWrite.Rollback;
  end;
  trnRead.Commit;
  trnRead.StartTransaction;
  dmOtto.ObjectGet(ndOrder, OrderId, trnRead);
  qryOrderFullSpecification.Transaction:= trnRead;
  qryOrderFullSpecification.OpenWP([OrderId]);
  ShowMessage(GetXmlAttr(ndOrder, 'ORDER_CODE', 'Заявка ', ' сохранена и переведена в статус "Оформлена"'));
end;






// Form

procedure TWzOrderOtto.actListWzrdBtnUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  actOrderDraft.Visible:= not AttrExists(ndOrder, 'ORDER_CODE');
  actOrderCreate.Visible:= not AttrExists(ndOrder, 'ORDER_CODE');
  actOrderError.Visible:= not AttrExists(ndOrder, 'ORDER_CODE');
  actOrderStore.Visible:= AttrExists(ndOrder, 'ORDER_CODE');
  btnFtBack.Visible:= not AttrExists(ndOrder, 'ORDER_CODE');
end;

procedure TWzOrderOtto.UpdateCaptions;
var
  CaptionText: string;
  Clr: TColor;
begin
  CaptionText:= DetectCaption(ndClient, 'Клиент');
  grBoxClientOnClient.Caption:= CaptionText;
  grBoxClientOnAdress.Caption:= CaptionText;
  grBoxClientOfFinal.Caption:= CaptionText;

  CaptionText:= DetectCaption(ndAdress, 'Адрес');
  grBoxAdressOnClient.Caption:= CaptionText;
  grBoxAdressOnAdress.Caption:= CaptionText;

  CaptionText:= DetectCaption(ndPlace, 'Населенный пункт');
  grBoxPlaceOnAdress.Caption:= CaptionText;

  CaptionText:= DetectCaption(ndOrder, 'Заявка');
  grBoxProductOnOrder.Caption:= CaptionText;
end;



procedure TWzOrderOtto.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  mr: Word;
begin
  if (ModalResult = mrCancel) or (ModalResult = mrNone) then
  begin
    if MessageId > 0 then
    begin
      mr:= MessageDlg('Забраковать интернет-заявку?', mtWarning, mbYesNoCancel, 0);
      CanClose:= mr <> mrCancel;
      if CanClose then
      begin
        if trnWrite.Active then trnWrite.Rollback;
        if mr = mrYes then dmOtto.MessageError(trnWrite, MessageId);
      end
    end
    else
    begin
      mr:= MessageDlg('Прекратить создание заявки?', mtWarning, mbYesNoCancel, 0);
      CanClose:= mr = mrYes;
      if CanClose and trnWrite.Active then
        trnWrite.Rollback;
    end;
  end
  else
  if trnWrite.Active then
  begin
    mr:= MessageDlg('Записать изменения в БД?', mtWarning, mbYesNoCancel, 0);
    CanClose:= mr <> mrCancel;
    if mr = mrYes then
      trnWrite.Commit
    else
      trnWrite.Rollback;
  end
end;


procedure TWzOrderOtto.dedLastNameExit(Sender: TObject);
begin
  TDBEditEh(Sender).Text:= UpCaseWord(TDBEditEh(Sender).Text);
  actClientSearch.Execute;
end;

procedure TWzOrderOtto.qryArticles2OrderItems;
var
  FlagSignList: Variant;
begin
  FlagSignList:= mtblOrderItems['FLAG_SIGN_LIST'];
  if Pos(',DRAFT,', mtblOrderItems['FLAG_SIGN_LIST']) > 0 then
  begin
    if not qryArticles.Eof then
    begin
      if mtblOrderItems.State = dsBrowse then
        mtblOrderItems.Edit;
      BatchMoveFields2(mtblOrderItems, qryArticles,
        'MAGAZINE_ID;MAGAZINE_NAME;ARTICLE_ID;ARTICLE_CODE;DIMENSION;PRICE_EUR;WEIGHT');
      mtblOrderItems['STATUS_ID']:= dmOtto.GetDefaultStatusId('ORDERITEM');
    end;
  end;
  grdOrderItems.RowDetailPanel.Visible:= False;
  grdOrderItems.SetFocus;
end;

procedure TWzOrderOtto.grdArticlesDblClick(Sender: TObject);
begin
  qryArticles2OrderItems;
end;

procedure TWzOrderOtto.grdArticlesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = vk_Return then
    qryArticles2OrderItems;
end;


procedure TWzOrderOtto.mtblOrderItemsBeforePost(DataSet: TDataSet);
begin
  if mtblOrderItems['ORDERITEM_ID'] = null then
    mtblOrderItems['ORDERITEM_ID']:= dmOtto.GetNewObjectId('ORDERITEM');
end;


procedure TWzOrderOtto.mtblOrderTaxItemsCalcFields(DataSet: TDataSet);
begin
  DataSet['BYR2EUR']:= GetXmlAttrValue(ndOrder, 'BYR2EUR');
  DataSet['COST_BYR']:= DataSet['COST_EUR']*DataSet['BYR2EUR'];
end;

procedure TWzOrderOtto.EditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  KeyReturn(Sender, Key, Shift);
end;

procedure TWzOrderOtto.EditEnter(Sender: TObject);
begin
  dmOtto.SetKeyLayout(TControl(Sender).Tag);
end;

procedure TWzOrderOtto.actOrderCancelExecute(Sender: TObject);
begin
  ModalResult:= mrIgnore;
  Close;
end;

procedure TWzOrderOtto.xNameExit(Sender: TObject);
begin
  TDBEditEh(Sender).Text:= UpCaseWord(TDBEditEh(Sender).Text);
end;

procedure TWzOrderOtto.dedPlaceNameExit(Sender: TObject);
begin
  xNameExit(Sender);
  actPlaceSearch.Execute;
end;

procedure TWzOrderOtto.mtblOrderItemsBeforeDelete(DataSet: TDataSet);
begin
  inherited;
  if Pos(',DELETABLE,', DataSet['FLAG_SIGN_LIST']) = 0 then
    Abort;
end;

procedure TWzOrderOtto.dedPlaceNameChange(Sender: TObject);
begin
  inherited;
  if AttrExists(ndPlace, 'ID') then
  begin
    if GetXmlAttrValue(ndPlace, 'PLACE_NAME') <> UpCaseWord(dedPlaceName.Text) then
    begin
      SetXmlAttr(ndPlace, 'ID', null);
      UpdateCaptions;
    end;
  end;
end;

procedure TWzOrderOtto.actOrderStoreExecute(Sender: TObject);
begin
  inherited;
  if trnWrite.Active then trnWrite.Commit;
  trnRead.Commit;
  trnRead.StartTransaction;
  dmOtto.ObjectGet(ndOrder, ObjectId, trnRead);
  qryOrderFullSpecification.Transaction:= trnRead;
  qryOrderFullSpecification.OpenWP([ObjectId]);
end;

end.
