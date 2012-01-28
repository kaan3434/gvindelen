unit uFrameOrderItems;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrameBase0, ImgList, PngImageList, ActnList, FIBDatabase,
  pFIBDatabase, TBXStatusBars, TB2Dock, TB2Toolbar, TBX, DBGridEhGrouping,
  MemTableDataEh, Db, FIBDataSet, pFIBDataSet, MemTableEh, ExtCtrls,
  JvExExtCtrls, JvImage, GridsEh, DBGridEh, NativeXml, JvComponentBase,
  JvProgressComponent, TB2Item, StdCtrls, JvExStdCtrls, JvGroupBox,
  JvEmbeddedForms, JvFormAutoSize, JvExtComponent, uFrameBase1;

type
  TFrameOrderItems = class(TFrameBase1)
    mtblOrderItems: TMemTableEh;
    fldOrderItems_ORDERITEM_ID: TIntegerField;
    fldOrderItems_MAGAZINE_ID: TIntegerField;
    fldOrderItems_MAGAZINE_NAME: TStringField;
    fldOrderItems_ARTICLE_ID: TIntegerField;
    fldOrderItems_ARTICLE_CODE: TStringField;
    fldOrderItems_DIMENSION: TStringField;
    fldOrderItems_PRICE_EUR: TFloatField;
    fldOrderItems_WEIGHT: TIntegerField;
    fldOrderItems_NAME_RUS: TStringField;
    fldOrderItems_KIND_RUS: TStringField;
    fldOrderItems_STATUS_ID: TIntegerField;
    fldOrderItems_STATUS_NAME: TStringField;
    fldOrderItems_COUNT_WEIGHT: TIntegerField;
    fldOrderItems_STATUS_SIGN: TStringField;
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
    fldOrderItems_ORDERITEM_INDEX: TIntegerField;
    actSetStatus: TAction;
    subSetStatuses: TTBXSubmenuItem;
    qryNextStatus: TpFIBDataSet;
    fldOrderItemsFLAG_SIGN_LIST: TStringField;
    fldOrderItems_COST_EUR: TFloatField;
    fldOrderItems_AMOUNT: TIntegerField;
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
    procedure grdOrderItemsGetCellParams(Sender: TObject;
      Column: TColumnEh; AFont: TFont; var Background: TColor;
      State: TGridDrawState);
    procedure actSetStatusExecute(Sender: TObject);
    procedure mtblOrderItemsAfterScroll(DataSet: TDataSet);
    procedure mtblOrderItemsAfterInsert(DataSet: TDataSet);
    procedure grdOrderItemsKeyPress(Sender: TObject; var Key: Char);
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
  GvNativeXml, udmOtto, GvStr, GvColor, GvVariant;
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
  OrderItemId, i: Integer;
begin
  inherited;
  if mtblOrderItems.State <> dsBrowse then
    mtblOrderItems.Post;
  mtblOrderItems.Tag:= 1;
  try
    For i:= 0 to ndOrderItems.NodeCount - 1 do
    begin
      ndOrderItem:= ndOrderItems[i];
      OrderItemId:= GetXmlAttrValue(ndOrderItem, 'ID');
      mtblOrderItems.Locate('ORDERITEM_ID', OrderItemId, []);
      BatchMoveFields2(ndOrderItem, mtblOrderItems,
        'MAGAZINE_ID;ARTICLE_CODE;DIMENSION;PRICE_EUR;COST_EUR;NAME_RUS;STATUS_ID', true);
      BatchMoveFields2(ndOrderItem, mtblOrderItems,
        'ARTICLE_ID;KIND_RUS;STATE_ID;WEIGHT', false);
      dmOtto.ActionExecute(trnWrite, ndOrderItem);
      dmOtto.ObjectGet(ndOrderItem, OrderItemId, trnWrite);
    end;
  finally
    mtblOrderItems.Tag:= 0;
  end;
end;

procedure TFrameOrderItems.Read;
begin
  mtblOrderItems.Tag:= 1;
  try
    BatchMoveXMLNodes2Dataset(mtblOrderItems, ndOrderItems,
      'ORDERITEM_ID=ID;ORDER_ID;MAGAZINE_ID;ARTICLE_ID;ARTICLE_CODE;DIMENSION;'+
      'PRICE_EUR;WEIGHT;NAME_RUS;KIND_RUS;STATUS_ID;STATE_ID;FLAG_SIGN_LIST=STATUS_FLAG_LIST;'+
      'AMOUNT;COST_EUR;ORDERITEM_INDEX',
      cmReplace);
    if mtblOrderItems.State <> dsBrowse then
      mtblOrderItems.Post;
  finally
    mtblOrderItems.Tag:= 0;
  end;
  mtblOrderItemsAfterScroll(mtblOrderItems);
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
  OrderItemId: Integer;
begin
  ProgressCheckAvail.ProgressMax:= ndOrderItems.NodeCount;
  ProgressCheckAvail.ProgressPosition:= 0;

  ndOrder.Document.XmlFormat:= xfReadable;
  ndOrder.Document.SaveToFile('Order.xml');
  for i:= 0 to ndOrderItems.NodeCount - 1 do
  begin
    ndOrderItem:= ndOrderItems[i];
    OrderItemId:= GetXmlAttrValue(ndOrderItem, 'ID');
    if FlagPresent('DELETEABLE', ndOrderItem, 'STATUS_FLAG_LIST') then
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
                  SetXmlAttr(ndOrderItem, 'NEW.STATE_SIGN', 'UNAVAILABLE');
                  SetXmlAttr(ndOrderItem, 'NEW.STATUS_SIGN', 'SOLD');
                end;
             1: SetXmlAttr(ndOrderItem, 'NEW.STATE_SIGN', 'AVAILABLE');
             2: SetXmlAttr(ndOrderItem, 'NEW.STATE_SIGN', 'DELAY3WEEK');
             21: SetXmlAttr(ndOrderItem, 'NEW.STATE_SIGN', 'DELAY3WEEK');
            end;
          end;
          xmlAvail.XmlFormat:= xfReadable;
          ForceDirectories(Path['Articles']);
          xmlAvail.SaveToFile(GetXmlAttr(ndOrderItem, 'ARTICLE_CODE', Path['Articles'], '_avail.xml'));
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
                    SetXmlAttrAsMoney(ndOrderItem, 'PRICE_EUR', GetXmlAttrAsMoney(nl[j], 'price_eur'));
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
      dmOtto.ActionExecute(trnWrite, ndOrderItem);
      dmOtto.ObjectGet(ndOrderItem, OrderItemId, trnWrite);
    end
  end;
end;

procedure TFrameOrderItems.actCheckAvailableExecute(Sender: TObject);
begin
  Write;
  ProgressCheckAvail.Execute;
  Read;
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


procedure TFrameOrderItems.mtblOrderItemsBeforeEdit(DataSet: TDataSet);
begin
  if DataSet.Tag = 1 then Exit;
  if not FlagPresent('EDITABLE', ndOrderItem, 'STATUS_FLAG_LIST') then
    Abort;
end;

procedure TFrameOrderItems.mtblOrderItemsBeforeInsert(DataSet: TDataSet);
begin
  if DataSet.Tag = 1 then Exit;
  if not FlagPresent('APPENDABLE', ndOrder, 'STATUS_FLAG_LIST') then
    Abort;
end;

procedure TFrameOrderItems.OpenTables;
begin
  inherited;
  mtblOrderItems.Open;
  qryMagazines.Open;
  qryNextStatus.open;
end;

procedure TFrameOrderItems.mtblOrderItemsBeforePost(DataSet: TDataSet);
var
  Weight: variant;
begin
  if DataSet['ARTICLE_CODE']=null then
    abort;

  ndOrderItem:= ndOrderItems.NodeByAttributeValue('ORDERITEM', 'ID', DataSet['ORDERITEM_ID']);
  if ndOrderItem = nil then
  begin
    ndOrderItem:= ndOrderItems.NodeNew('ORDERITEM');
    BatchMoveFields2(ndOrderItem, DataSet,
      'ID=ORDERITEM_ID;MAGAZINE_ID;ARTICLE_CODE;DIMENSION;'+
      'PRICE_EUR;COST_EUR;NAME_RUS;STATUS_ID', true);
    BatchMoveFields2(ndOrderItem, DataSet,
      'ARTICLE_ID;STATUS_SIGN;KIND_RUS;STATE_ID;WEIGHT', false);
  end;
  SetXmlAttr(ndOrderItem, 'ORDER_ID', OrderId);

  if DataSet['WEIGHT'] = null then
  try
    SetXmlAttr(ndOrderItem, 'WEIGHT', DataSet['WEIGHT']);
  except
  end;
end;

procedure TFrameOrderItems.actCancelRequestExecute(Sender: TObject);
begin
  ndOrderItem:= ndOrderItems.NodeByAttributeValue('ORDERITEM','ID', mtblOrderItems['ORDERITEM_ID']);
  if ndOrderItem <> nil then
  begin
    if Pos(',DELETEABLE,', mtblOrderItems['FLAG_SIGN_LIST']) > 0 then
    begin
      mtblOrderItems.Delete;
      trnWrite.ExecSQLImmediate(Format(
        'delete from orderitems where orderitem_id = %u',
        [Integer(GetXmlAttrValue(ndOrderItem, 'ID'))]));
      ndOrderItem.Delete;
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
    ItemFlagList:= mtblOrderItems.FieldByName('FLAG_SIGN_LIST').AsString;
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
    dmOtto.ActionExecute(trnWrite, ndOrderItem, 'RETURNING');
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
    'ARTICLE_ID;STATUS_SIGN;KIND_RUS;WEIGHT');
  mtblOrderItems.Append;
  BatchMoveFields2(mtblOrderItems, ndOrderItem,
    'ORDERITEM_ID=ID;ORDER_ID;MAGAZINE_ID;ARTICLE_CODE;DIMENSION;PRICE_EUR;COST_EUR;NAME_RUS;'+
    'ARTICLE_ID;STATUS_SIGN;KIND_RUS;WEIGHT');
  mtblOrderItems.Post;
  Write;
  Read;
end;

procedure TFrameOrderItems.actApproveExecute(Sender: TObject);
var
  OrderItemId: variant;
begin
  OrderItemId:= mtblOrderItems['ORDERITEM_ID'];
  Write;
  try
    ndOrderItem:= ndOrderItems.NodeByAttributeValue('ORDERITEM','ID', OrderItemId);
    if ndOrderItem <> nil then
    begin
      SetXmlAttr(ndOrderItem, 'NEW.STATUS_SIGN', 'APPROVED');
      dmOtto.ActionExecute(trnWrite, ndOrderItem);
      dmOtto.ObjectGet(ndOrderItem, OrderItemId, trnWrite);
    end;
  finally
    Read;
  end;
end;



procedure TFrameOrderItems.actApproveUpdate(Sender: TObject);
begin
  actApprove.Enabled:= mtblOrderItems['STATUS_SIGN'] = 'NEW';
end;

procedure TFrameOrderItems.grdOrderItemsGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  if Column.ReadOnly then
    Background:= GvColor.Lighter(clSilver, 50)
  else
    Background:= clWindow;
end;

procedure TFrameOrderItems.actSetStatusExecute(Sender: TObject);
var
  StatusId: Integer;
  StatusSign: String;
  OrderItemId: variant;
begin
  OrderItemId:= mtblOrderItems['ORDERITEM_ID'];
  Write;
  try
    ndOrderItem:= ndOrderItems.NodeByAttributeValue('ORDERITEM','ID', OrderItemId);
    if ndOrderItem <> nil then
    begin
      StatusId:= TAction(Sender).ActionComponent.Tag;
      StatusSign:= qryStatuses.Lookup('STATUS_ID', StatusId, 'STATUS_SIGN');
      SetXmlAttr(ndOrderItem, 'NEW.STATUS_SIGN', StatusSign);
      dmOtto.ActionExecute(trnWrite, ndOrderItem);
      dmOtto.ObjectGet(ndOrderItem, OrderItemId, trnWrite);
    end;
  finally
    read;
  end
end;

procedure TFrameOrderItems.mtblOrderItemsAfterScroll(DataSet: TDataSet);
var
  btnSetStatus: TTBXItem;
  CompName: string;
  i: Integer;
begin
  for i:= 0 to subSetStatuses.Count - 1 do
    subSetStatuses.Items[i].Visible:= False;
  if qryNextStatus.Active then
  begin
    qryNextStatus.First;
    while not qryNextStatus.Eof do
    begin
      CompName:= Format('btnSetStatus_%s', [qryNextStatus['STATUS_SIGN']]);
      btnSetStatus:= TTBXItem(subSetStatuses.FindComponent(CompName));
      if btnSetStatus = nil then
      begin
        btnSetStatus:= TTBXItem.Create(subSetStatuses);
        btnSetStatus.Action:= actSetStatus;
        btnSetStatus.Name:= CompName;
        btnSetStatus.Tag:= qryNextStatus['STATUS_ID'];
        btnSetStatus.Caption:= qryNextStatus['STATUS_NAME'];
        subSetStatuses.Add(btnSetStatus);
      end
      else
        btnSetStatus.Visible:= True;
      qryNextStatus.Next;
    end;
  end;
end;

procedure TFrameOrderItems.mtblOrderItemsSetFieldValue(
  MemTable: TCustomMemTableEh; Field: TField; var Value: Variant);
var
  FlagSignList: Variant;
begin
  if MemTable.Tag = 1 then Exit;
  if (Field.FieldName = 'DIMENSION') and IsNotNull(Value) then
  begin
    if IsNotNull(MemTable['ARTICLE_SIGN']) and
       (MemTable['PRICE_EUR'] <> Value)  then
    begin
      MemTable['PRICE_EUR']:= dmOtto.GetMinPrice(MemTable['ARTICLE_SIGN'], Value, trnWrite);
      MemTable['WEIGHT']:= dmOtto.GetWeight(MemTable['ARTICLE_SIGN'], Value, trnWrite);
    end;
  end
  else
  if (Field.FieldName = 'PRICE_EUR') and IsNotNull(Value) then
  begin
    MemTable['COST_EUR']:= MemTable['AMOUNT']*Value;
  end
  else
  if Field.FieldName = 'AMOUNT' then
  begin
    if (Value = 1) and IsNotNull(MemTable['ARTICLE_SIGN']) and IsNotNull(MemTable['DIMENSION']) then
      MemTable['WEIGHT']:= dmOtto.GetWeight(MemTable['ARTICLE_SIGN'], MemTable['DIMENSION'], trnWrite)
    else
      MemTable['WEIGHT']:= null;
    if (Value = 1) and IsNotNull(MemTable['PRICE_EUR']) then
      MemTable['COST_EUR']:= MemTable['PRICE_EUR']*Value
    else
      MemTable['COST_EUR']:= null;
  end
  else
  if Field.FieldName = 'ARTICLE_CODE' then
  begin
    MemTable['ARTICLE_SIGN']:= dmOtto.GetArticleSign(Value, nvl(MemTable['MAGAZINE_ID'], 1));
  end
  else
  if Field.FieldName = 'ARTICLE_SIGN' then
  begin
    MemTable['NAME_RUS']:= trnWrite.DefaultDatabase.QueryValue(
      'select first 1 ac.description from articlecodes ac where ac.article_sign = :article_sign',
      0, [Value], trnWrite);
  end;
end;

procedure TFrameOrderItems.mtblOrderItemsAfterInsert(DataSet: TDataSet);
begin
  if DataSet.Tag = 1 then Exit;
  DataSet['ORDERITEM_ID']:= dmOtto.GetNewObjectId('ORDERITEM');
  DataSet['STATUS_ID']:= dmOtto.GetDefaultStatusId('ORDERITEM');
  DataSet['FLAG_SIGN_LIST']:= dmOtto.GetFlagListById(DataSet['STATUS_ID']);
  DataSet['AMOUNT']:= 1;
end;

procedure TFrameOrderItems.grdOrderItemsKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  with grdOrderItems do
  begin
    if Columns[Col].FieldName = 'DIMENSION' then
      if not (Key in ['0'..'9', 'A'..'Z']) then Key:= #0;
  end;
end;

end.
