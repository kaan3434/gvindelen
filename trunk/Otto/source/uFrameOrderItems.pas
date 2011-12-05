unit uFrameOrderItems;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrameBase0, ImgList, PngImageList, ActnList, FIBDatabase,
  pFIBDatabase, TBXStatusBars, TB2Dock, TB2Toolbar, TBX, DBGridEhGrouping,
  MemTableDataEh, Db, FIBDataSet, pFIBDataSet, MemTableEh, ExtCtrls,
  JvExExtCtrls, JvImage, GridsEh, DBGridEh, NativeXml, JvComponentBase,
  JvProgressComponent, TB2Item, StdCtrls, JvExStdCtrls, JvGroupBox,
  JvEmbeddedForms, JvFormAutoSize, JvExtComponent, JvPanel;

type
  TFrameOrderItems = class(TFrameBase0)
    mtblOrderItems: TMemTableEh;
    fldOrderItems_ORDERITEM_ID: TIntegerField;
    fldOrderItems_MAGAZINE_ID: TIntegerField;
    fldOrderItems_MAGAZINE_NAME: TStringField;
    fldOrderItems_PAGE_NO: TIntegerField;
    fldOrderItems_POSITION_SIGN: TStringField;
    fldOrderItems_ARTICLE_ID: TIntegerField;
    fldOrderItems_ARTICLE_CODE: TStringField;
    fldOrderItems_DIMENSION: TStringField;
    fldOrderItems_PRICE_EUR: TFloatField;
    fldOrderItems_WEIGHT: TIntegerField;
    fldOrderItems_COST_EUR: TFloatField;
    fldOrderItems_NAME_RUS: TStringField;
    fldOrderItems_KIND_RUS: TStringField;
    fldOrderItems_STATUS_ID: TIntegerField;
    fldOrderItems_STATUS_NAME: TStringField;
    fldOrderItems_COUNT_WEIGHT: TIntegerField;
    fldOrderItems_STATUS_SIGN: TStringField;
    fldOrderItems_FLAG_SIGN_LIST: TStringField;
    fldOrderItems_AMOUNT: TSmallintField;
    fldOrderItems_STATUS_DTM: TDateTimeField;
    fldOrderItems_STATE_ID: TIntegerField;
    fldOrderItems_STATE_NAME: TStringField;
    dsOrderItems: TDataSource;
    dsArticles: TDataSource;
    qryArticles: TpFIBDataSet;
    qryMagazines: TpFIBDataSet;
    qryStatuses: TpFIBDataSet;
    ProgressCheckAvail: TJvProgressComponent;
    actCheckAvailable: TAction;
    btnCheckAvailable: TTBXItem;
    fldOrderItems_ORDER_ID: TIntegerField;
    fldOrderItems_ARTICLE_SIGN: TStringField;
    grBoxOrderItems: TJvGroupBox;
    grdOrderItems: TDBGridEh;
    grdArticles: TDBGridEh;
    actCancelRequest: TAction;
    actReturnRequest: TAction;
    btn1: TTBXItem;
    btn2: TTBXItem;
    actDublicate: TAction;
    btn3: TTBXItem;
    actApprove: TAction;
    btn4: TTBXItem;
    procedure ProgressCheckAvailShow(Sender: TObject);
    procedure actCheckAvailableExecute(Sender: TObject);
    procedure grdOrderItemsColEnter(Sender: TObject);
    procedure grdArticlesDblClick(Sender: TObject);
    procedure grdOrderItemsRowDetailPanelShow(Sender: TCustomDBGridEh;
      var CanShow: Boolean);
    procedure grdArticlesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure grdOrderItemsRowDetailPanelHide(Sender: TCustomDBGridEh;
      var CanHide: Boolean);
    procedure mtblOrderItemsSetFieldValue(MemTable: TCustomMemTableEh;
      Field: TField; var Value: Variant);
    procedure mtblOrderItemsBeforeEdit(DataSet: TDataSet);
    procedure mtblOrderItemsBeforeInsert(DataSet: TDataSet);
    procedure mtblOrderItemsCalcFields(DataSet: TDataSet);
    procedure mtblOrderItemsBeforePost(DataSet: TDataSet);
    procedure actCancelRequestExecute(Sender: TObject);
    procedure actCancelRequestUpdate(Sender: TObject);
    procedure actReturnRequestExecute(Sender: TObject);
    procedure actReturnRequestUpdate(Sender: TObject);
    procedure actCheckAvailableUpdate(Sender: TObject);
    procedure grdOrderItemsEnter(Sender: TObject);
    procedure actDublicateExecute(Sender: TObject);
    procedure actApproveExecute(Sender: TObject);
    procedure actApproveUpdate(Sender: TObject);
  private
    { Private declarations }
    FQryStatuses: Pointer;
    function GetOrderId: Integer;
    procedure qryArticles2OrderItems;
  public
    { Public declarations }
    ndOrder: TXmlNode;
    ndOrderItems: TXmlNode;
    ndOrderItem: TXmlNode;
    procedure InitData; override;
    procedure FreeData; override;
    procedure OpenTables; override;
    procedure Read; override;
    procedure Write; override;
    property OrderId: Integer read GetOrderId;
  end;

var
  FrameOrderItems: TFrameOrderItems;

implementation

{$R *.dfm}

Uses
  GvNativeXml, udmOtto, GvStr;
{ TFrameOrderItems }

procedure TFrameOrderItems.FreeData;
begin
  inherited;
  qryStatuses:= RestoreComponent(qryStatuses, FqryStatuses);
end;

procedure TFrameOrderItems.InitData;
begin
  inherited;
  qryStatuses:= StoreComponent(qryStatuses, FqryStatuses);
end;

function TFrameOrderItems.GetOrderId: Integer;
begin
  Result:= ndOrder.ReadAttributeInteger('ID', 0)
end;

procedure TFrameOrderItems.Write;
var
  OrderItemId: Integer;
  
begin
  with mtblOrderItems do
  begin
    First;
    while not Eof do
    begin
      OrderItemId:= mtblOrderItems['ORDERITEM_ID'];
      ndOrderItem:= ndOrderItems.NodeByAttributeValue('ORDERITEM', 'ID', mtblOrderItems['ORDERITEM_ID']);
      if ndOrderItem = nil then
        ndOrderItem:= ndOrderItems.NodeNew('ORDERITEM');
      BatchMoveFields2(ndOrderItem, mtblOrderItems,
        'ID=ORDERITEM_ID;ORDER_ID;MAGAZINE_ID;ARTICLE_CODE;DIMENSION;'+
        'PRICE_EUR;COST_EUR;NAME_RUS;STATUS_ID', true);
      BatchMoveFields2(ndOrderItem, mtblOrderItems,
        'ARTICLE_ID;PAGE_NO;POSITION_SIGN;STATUS_SIGN;KIND_RUS;STATE_ID;WEIGHT', false);
      dmOtto.ActionExecute(trnWrite, ndOrderItem);
      dmOtto.ObjectGet(ndOrderItem, OrderItemId, trnWrite);
      mtblOrderItems.Next;
    end;
  end;
end;

procedure TFrameOrderItems.Read;
begin
  BatchMoveXMLNodes2Dataset(mtblOrderItems, ndOrderItems,
    'ORDERITEM_ID=ID;ORDER_ID;MAGAZINE_ID;PAGE_NO;POSITION_SIGN;ARTICLE_ID;ARTICLE_CODE;'+
    'DIMENSION;PRICE_EUR;WEIGHT;NAME_RUS;KIND_RUS;STATUS_ID;STATE_ID', cmReplace);
  if mtblOrderItems.State <> dsBrowse then
    mtblOrderItems.Post;
end;

procedure TFrameOrderItems.ProgressCheckAvailShow(Sender: TObject);
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
      except
      end;

      if GetXmlAttrValue(ndOrderItem, 'MAGAZINE_ID') = 1 then
      begin
        PluginName:= 'otto_get_article';
        Url:= dmOtto.dbOtto.QueryValue('select o_value from plugin_value(:plugin_sign, :param_sign)',
           0, [PluginName, 'URL']);
        handle := LoadLibrary('request_xml.plg');
        xmlArticle:= TNativeXml.Create;
        try
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
                ForceDirectories(Path['Articles']);
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
                  if GetXmlAttrAsMoney(nl[j], 'price_eur') <> GetXmlAttrAsMoney(ndOrderItem, 'PRICE_EUR') then
                    SetXmlAttr(ndOrderItem, 'STATUS_ID', dmOtto.GetStatusBySign(ndOrderItem, 'WRONGPRICE'));
                end;
              end;
            finally
              nl.Free;
            end;
          finally
            xmlArticle.Free;
          end;
        except
        end;
      end;

      aWeight:= trnWrite.DefaultDatabase.QueryValue(
        'select max(a.weight) from v_articles a where a.article_sign = :article_sign and a.dimension = :dimension',
        0, [nArticleSign, nDimension], trnWrite);
      if aWeight <> null then
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

procedure TFrameOrderItems.actCheckAvailableExecute(Sender: TObject);
begin
  Write;
  ProgressCheckAvail.Execute;
  qryArticles.CloseOpen(true);
end;

procedure TFrameOrderItems.grdOrderItemsColEnter(Sender: TObject);
var
  Column: TColumnEh;
begin
  Column:= grdOrderItems.Columns[grdOrderItems.col-1];
  dmOtto.SetKeyLayout(Column.Tag);
end;

procedure TFrameOrderItems.qryArticles2OrderItems;
begin
  if Pos(',DRAFT,', mtblOrderItems['FLAG_SIGN_LIST']) > 0 then
  begin
    if not qryArticles.Eof then
    begin
      if mtblOrderItems.State = dsBrowse then
        mtblOrderItems.Edit;
      BatchMoveFields2(mtblOrderItems, qryArticles,
        'MAGAZINE_ID;MAGAZINE_NAME;ARTICLE_ID;ARTICLE_CODE;DIMENSION;PRICE_EUR;WEIGHT');
      if mtblOrderItems['NAME_RUS'] = null then
        mtblOrderItems['NAME_RUS']:= qryArticles['DESCRIPTION'];
      mtblOrderItems['STATE_ID']:= null;
    end;
  end;
end;

procedure TFrameOrderItems.grdArticlesDblClick(Sender: TObject);
begin
  qryArticles2OrderItems;
  grdOrderItems.SetFocus;
  grdOrderItems.RowDetailPanel.Visible:= False;
end;


procedure TFrameOrderItems.grdOrderItemsRowDetailPanelShow(
  Sender: TCustomDBGridEh; var CanShow: Boolean);
begin
  CanShow:= Trim(mtblOrderItems.FieldByName('ARTICLE_CODE').AsString) <> '';
  if CanShow then
  begin
    if mtblOrderItems['ARTICLE_SIGN'] <> null then
      qryArticles.Open;
  end;
end;

procedure TFrameOrderItems.grdArticlesKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = vk_Return then
    grdArticlesDblClick(Self);
end;

procedure TFrameOrderItems.grdOrderItemsRowDetailPanelHide(
  Sender: TCustomDBGridEh; var CanHide: Boolean);
begin
  CanHide:= True;
  qryArticles.Close;
end;

procedure TFrameOrderItems.mtblOrderItemsSetFieldValue(
  MemTable: TCustomMemTableEh; Field: TField; var Value: Variant);
var
  ArticleSign: Variant;
begin
  inherited;
  if Field.FieldName = 'ARTICLE_CODE' then
  begin
    ArticleSign:= trnWrite.DefaultDatabase.QueryValue(
      'select o_article_sign from articlesign_detect(:article_code, :magazine_id)',
      0, [Value, mtblOrderItems['MAGAZINE_ID']],
      trnWrite);
    MemTable['ARTICLE_SIGN']:= ArticleSign;
    if (ArticleSign <> null) and (MemTable['NAME_RUS'] = null) then
    begin
      MemTable['NAME_RUS']:= trnWrite.DefaultDatabase.QueryValue(
        'select first 1 ac.description from articlecodes ac where ac.article_sign = :article_sign',
        0, [ArticleSign], trnWrite);
    end;
  end
end;

procedure TFrameOrderItems.mtblOrderItemsBeforeEdit(DataSet: TDataSet);
begin
  if Pos(',EDITABLE,', DataSet['FLAG_SIGN_LIST']) = 0 then
    Abort;
end;

procedure TFrameOrderItems.mtblOrderItemsBeforeInsert(DataSet: TDataSet);
var
  FlagList: string;
begin
  FlagList:= dmOtto.GetFlagListById(GetXmlAttrValue(ndOrder, 'STATUS_ID'));
  if Pos(',APPENDABLE,', FlagList) = 0 then
    Abort;
end;

procedure TFrameOrderItems.mtblOrderItemsCalcFields(DataSet: TDataSet);
var
  FlagSignList: string;
begin
  if DataSet['STATUS_ID'] = null then
    DataSet['STATUS_ID']:= dmOtto.GetDefaultStatusId('ORDERITEM');

  FlagSignList:= dmOtto.GetFlagListById(DataSet['STATUS_ID']);
  if Pos(',DEBIT,', FlagSignList) > 0 then
    DataSet['AMOUNT']:= 0
  else
  if Pos(',CREDIT,', FlagSignList) > 0 then
    DataSet['AMOUNT']:= 1;
  DataSet['COST_EUR']:= DataSet['PRICE_EUR']*DataSet['AMOUNT'];
end;

procedure TFrameOrderItems.OpenTables;
begin
  inherited;
  mtblOrderItems.Open;
  qryMagazines.Open;
end;

procedure TFrameOrderItems.mtblOrderItemsBeforePost(DataSet: TDataSet);
begin
  inherited;
  if DataSet['ORDERITEM_ID'] = null then
    DataSet['ORDERITEM_ID']:= dmOtto.GetNewObjectId('ORDERITEM');
  DataSet['ORDER_ID']:= OrderId;
  if DataSet['ARTICLE_CODE']=null then
    abort;
end;

procedure TFrameOrderItems.actCancelRequestExecute(Sender: TObject);
begin
  ndOrderItem:= ndOrderItems.NodeByAttributeValue('ORDERITEM','ID', mtblOrderItems['ORDERITEM_ID']);
  if ndOrderItem <> nil then
  begin
    if Pos(',DELETEABLE,', mtblOrderItems['FLAG_SIGN_LIST']) > 0 then
    begin
      ndOrderItem.Delete;
      mtblOrderItems.Delete;
    end
    else
    begin
      SetXmlAttr(ndOrderItem, 'NEW.STATUS_SIGN', 'CANCELREQUEST');
      ndOrderItem.ValueAsBool:= True;
      dmOtto.ActionExecute(trnWrite, ndOrderItem);
      dmOtto.ObjectGet(ndOrderItem, mtblOrderItems['ORDERITEM_ID'], trnWrite);
      Read;
    end;
  end;
end;

procedure TFrameOrderItems.actCancelRequestUpdate(Sender: TObject);
var
  OrderFlagList, ItemFlagList: string;
  Cancelable: boolean;
begin
  if not mtblOrderItems.Eof then
  begin
    OrderFlagList:= dmOtto.GetFlagListById(GetXmlAttrValue(ndOrder, 'STATUS_ID'));
    ItemFlagList:= mtblOrderItems['FLAG_SIGN_LIST'];
    Cancelable:= (Pos(',CANCELABLE,', OrderFlagList) > 0)
      and (Pos(',DELETEABLE,', ItemFlagList)+Pos(',CANCELABLE,', ItemFlagList) > 0);
  end
  else
    Cancelable:= false;
  actCancelRequest.Enabled:= Cancelable;
end;

procedure TFrameOrderItems.actReturnRequestExecute(Sender: TObject);
begin
  ndOrderItem:= ndOrderItems.NodeByAttributeValue('ORDERITEM','ID', mtblOrderItems['ORDERITEM_ID']);
  if ndOrderItem <> nil then
    dmOtto.ActionExecute(trnWrite, ndOrderItem, 0, 'RETURNING');
end;

procedure TFrameOrderItems.actReturnRequestUpdate(Sender: TObject);
begin
  actReturnRequest.Enabled:= mtblOrderItems['STATUS_SIGN'] = 'DELIVERING';
end;

procedure TFrameOrderItems.actCheckAvailableUpdate(Sender: TObject);
begin
  actCheckAvailable.Enabled:= XmlAttrIn(ndOrder, 'STATUS_SIGN', 'NEW,DRAFT,APPROVED,ACCEPTREQUEST,ACCEPTED');
end;

procedure TFrameOrderItems.grdOrderItemsEnter(Sender: TObject);
var
  Column: TColumnEh;
begin
  inherited;
  grdOrderItems.Col:= 0;
end;

procedure TFrameOrderItems.actDublicateExecute(Sender: TObject);
begin
  ndOrderItem:= ndOrderItems.NodeNew('ORDERITEM');
  SetXmlAttr(ndOrderItem, 'ID', dmOtto.GetNewObjectId('ORDERITEM'));
  BatchMoveFields2(ndOrderItem, mtblOrderItems,
    'ORDER_ID;MAGAZINE_ID;ARTICLE_CODE;DIMENSION;PRICE_EUR;COST_EUR;NAME_RUS;'+
    'ARTICLE_ID;PAGE_NO;POSITION_SIGN;STATUS_SIGN;KIND_RUS;WEIGHT');
  mtblOrderItems.Append;
  BatchMoveFields2(mtblOrderItems, ndOrderItem,
    'ORDERITEM_ID=ID;ORDER_ID;MAGAZINE_ID;ARTICLE_CODE;DIMENSION;PRICE_EUR;COST_EUR;NAME_RUS;'+
    'ARTICLE_ID;PAGE_NO;POSITION_SIGN;STATUS_SIGN;KIND_RUS;WEIGHT');
  mtblOrderItems.Post;
  Write;
  Read;
end;

procedure TFrameOrderItems.actApproveExecute(Sender: TObject);
begin
  ndOrderItem:= ndOrderItems.NodeByAttributeValue('ORDERITEM','ID', mtblOrderItems['ORDERITEM_ID']);
  if ndOrderItem <> nil then
  begin
    Write;
    SetXmlAttr(ndOrderItem, 'NEW.STATUS_SIGN', 'APPROVED');
    dmOtto.ActionExecute(trnWrite, ndOrderItem);
    dmOtto.ObjectGet(ndOrderItem, mtblOrderItems['ORDERITEM_ID'], trnWrite);
    Read;
  end;
end;

procedure TFrameOrderItems.actApproveUpdate(Sender: TObject);
begin
  actApprove.Enabled:= mtblOrderItems['STATUS_SIGN'] = 'NEW';
end;

end.
