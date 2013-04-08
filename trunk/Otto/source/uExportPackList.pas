unit uExportPackList;

interface
uses
  Classes, NativeXml, FIBDatabase, pFIBDatabase, DB;

procedure ExportPackList(aTransaction: TpFIBTransaction);

implementation
uses
  SysUtils, GvNativeXml, udmOtto, GvStr, Dbf, GvFile, uMain, Dialogs, GvVariant,
  frxClass, frxExportXLS, GvMath, GvVars, Variants;

function GetPlace(ndPlace: TXmlNode): string;
begin
  if GetXmlAttrValue(ndPlace, 'PLACETYPE_CODE', '4') = 4 then
    Result:= GetXmlAttr(ndPlace, 'PLACE_NAME')
  else
    Result:= GetXmlAttr(ndPlace, 'PLACETYPE_NAME', ' ', '.') +
             GetXmlAttr(ndPlace, 'PLACE_NAME', ' ');
end;

function GetStreet(ndAdress: TXmlNode): string;
begin
   if GetXmlAttrValue(ndAdress, 'STREETTYPE_CODE', '1') > 1 then
     Result:= GetXmlAttr(ndAdress, 'STREETTYPE_NAME', ' ', '. ') +
             GetXmlAttr(ndAdress, 'STREET_NAME')
   else
     Result:= GetXmlAttr(ndAdress, 'STREET_NAME');
end;

function GetHome(ndAdress: TXmlNode): string;
begin
   Result:= GetXmlAttr(ndAdress, 'HOUSE') +
           GetXmlAttr(ndAdress, 'BUILDING', '/') +
           GetXmlAttr(ndAdress, 'FLAT', '-');

end;

function GetAdress(ndAdress: TXmlNode): string;
begin
  Result:= GetStreet(ndAdress) + ', ' + GetHome(ndAdress);
end;


function GetMobilePhone(aPhone: string): string;
begin
  Result:= replaceAll(aPhone, '+3750', '+375');
  Result:= ReplaceAll(Result, '+37580', '+375');
  Result:= ReplaceAll(Result, '+', '');
end;

procedure ExportOrderItem(aTransaction: TpFIBTransaction;
  ndProduct, ndOrder, ndOrderItems, ndOrderTaxs, ndClient, ndAdress, ndPlace: TXmlNode;
  tblCons, tblConsPi3: TDataSet; aOrderItemId: variant);
var
  ndOrderItem, ndTaxSSbor: TXmlNode;
  ShortClientName: string;
  St: string;
begin
  ndOrderItem:= ndOrderItems.NodeByAttributeValue('ORDERITEM', 'ID', aOrderItemId);
  try
    ndTaxSSbor:= ndOrderTaxs.NodeByAttributeValue('ORDERTAX', 'TAXSERV_ID', '1');
    if not Assigned(ndTaxSSbor) then
    begin
      ShowMessage(GetXmlAttr(ndOrder, 'ORDER_CODE', 'Отсутствует сервисный сбор на заявке '));
    end;

//    ndProduct.Document.XmlFormat:= xfReadable;
//    ndProduct.Document.SaveToFile('order.xml');
    tblCons.Append;
    BatchMoveFields2(tblCons, ndProduct, 'KTPART=PARTNER_NUMBER');
    BatchMoveFields2(tblCons, ndOrder,
      'KTKUNDE=ORDER_CODE;NRSENDUNG=PACKLIST_NO;NRKARTON=PALETTE_NO;'+
      'DATEEXCH=CREATE_DTM;RATEEXCH=BYR2EUR;USEXCH="0";VIDPLAT="0";'+
      'CONTR_ID=ID;COSTALL=ITEMSCOST_EUR;BARKOD=BAR_CODE');
    BatchMoveFields2(tblCons, ndOrderItem,
      'NRART=ARTICLE_CODE;BZARTORG=DESCRIPTION;MENGE=AMOUNT;PRVK=PRICE_EUR;'+
      'NREGWG;ZNAK="1";INSUM="1";NRAUFPOS=ORDERITEM_INDEX');
    BatchMoveFields2(tblCons, ndTaxSSbor,
        'SBOR=COST_EUR');
    BatchMoveFields2(tblCons, ndAdress,
      'GOSNUM=POSTINDEX');
    BatchMoveFields2(tblCons, ndClient,
      'BLACKLIST="0"');
    tblCons['NEWICHT']:= GetXmlAttrValue(ndOrder, 'WEIGHT', 0)/1000;

    tblCons['KTNAME']:= Translit(
      GetXmlAttr(ndClient, 'FIRST_NAME') + ' '+
      Copy(GetXmlAttr(ndClient, 'MID_NAME'), 1, 1) + ' ' +
      nvl(GetXmlAttrValue(ndOrder, 'LAST_NAME'), GetXmlAttrValue(ndClient, 'LAST_NAME')));
    tblCons['AUFEXT']:= CopyLast(GetXmlAttr(ndOrder, 'ORDER_CODE'), 5);
    tblCons['GRART']:= dmOtto.Recode('ARTICLE', 'DIMENSION_ENCODE', GetXmlAttr(ndOrderItem, 'DIMENSION'));
    tblCons['NAMEZAK']:= GetXmlAttr(ndOrderItem, 'NAME_RUS') + GetXmlAttr(ndOrderItem, 'KIND_RUS', ' ');
    tblCons['FAMILY']:= nvl(GetXmlAttrValue(ndOrder, 'LAST_NAME'), GetXmlAttrValue(ndClient, 'LAST_NAME'))+
                        GetXmlAttr(ndClient, 'FIRST_NAME', ' ') +
                        GetXmlAttr(ndClient, 'MID_NAME', ' ');
    tblCons['STREETRUS']:= GetAdress(ndAdress);
    tblCons['CITYRUS']:= GetPlace(ndPlace);
    tblCons['REGIONRUS']:= GetXmlAttr(ndPlace, 'AREA_NAME', '', ' р-н., ')+
                           GetXmlAttr(ndPlace, 'REGION_NAME', '', ' обл.');
    tblCons['STREET']:= Translit(GetAdress(ndAdress));
    tblCons['CITY']:= Translit(GetPlace(ndPlace));
    tblCons['REGION']:= Translit(GetXmlAttr(ndPlace, 'AREA_NAME', '', ' р-н., ')+
                           GetXmlAttr(ndPlace, 'REGION_NAME', '', ' обл.'));

    tblCons['TEL']:= GetMobilePhone(GetXmlAttr(ndClient, 'MOBILE_PHONE', '+375'));
    tblCons['COSTBYR']:= aTransaction.DefaultDatabase.QueryValue(
      'select round(cast(:cost_eur as money_eur) * cast(:byr2eur as value_integer), -1) from rdb$database',
      0, [GetXmlAttrValue(ndOrderItem, 'COST_EUR'), GetXmlAttrValue(ndOrder, 'BYR2EUR')], aTransaction);
    tblCons['SBORBYR']:= aTransaction.DefaultDatabase.QueryValue(
      'select round(cast(:cost_eur as money_eur) * cast(:byr2eur as value_integer), -1) from rdb$database',
      0, [GetXmlAttrValue(ndTaxSSbor, 'COST_EUR'), GetXmlAttrValue(ndOrder, 'BYR2EUR')], aTransaction);

    if GetXmlAttrValue(ndProduct, 'PAYTYPE_SIGN') = 'POSTPAY' then // Наложенный платеж
    begin
      BatchMoveFields2(tblCons, ndOrder,
        'VIDPLAT="1";INFOP=PACKLIST_NO;INFOPDATE=INVOICE_DT_0;COSTALLN=INVOICE_BYR_0');
    end;
    tblCons.Post;
    tblConsPi3.Append;
    BatchMoveFields2(tblConsPi3, tblCons,
      'KTPART;X211=NRSENDUNG;NZAK=KTKUNDE;EXP_3="300";NAMEZAK;NRART;GRART;KOL="1";'+
      'PRICE=PRVK;PRICEBEL=COSTBYR;SERVBEL=SBORBYR;DATEPOST=DATEEXCH;NREGWG;'+
      'FAMILY;PARTOBL=REGIONRUS;TELEPHONE=TEL;NORG="1";INDEXCITY=GOSNUM;'+
      'CITYRUS;N14=NRPALETTE');
    BatchMoveFields2(tblConsPi3, ndOrderItem,
      'NRAUFPOS=ORDERITEM_INDEX');
    tblConsPi3['STREET']:= GetStreet(ndAdress);
    tblConsPi3['HOME']:= GetHome(ndAdress);
    tblConsPi3['NEWICHT']:= GetXmlAttrValue(ndOrderItem, 'WEIGHT', 0)/1000;
    tblConsPi3.Post;
    SetXmlAttr(ndOrderItem, 'NEW.STATUS_SIGN', 'DELIVERING');
    dmOtto.ActionExecute(aTransaction, ndOrderItem);
  finally
    ndOrderItem.Clear;
  end;
end;

procedure ExportOrder(aTransaction: TpFIBTransaction;
  ndProduct, ndOrders: TXmlNode; tblCons, tblConsPi3: TDataSet;
  aOrderId: integer; var BelPostLine: string);
var
  ndOrder, ndOrderItems, ndOrderItem, ndOrderTaxs, ndClient, ndAdress, ndPlace: TXmlNode;
  OrderItemList: string;
  OrderItemId: Variant;
  i: integer;
  sl: TStringList;
begin
  sl:= TStringList.Create;
  try
    ndOrder:= ndOrders.NodeNew('ORDER');
    ndOrderItems:= ndOrder.NodeFindOrCreate('ORDERITEMS');
    ndOrderTaxs:= ndOrder.NodeFindOrCreate('ORDERTAXS');
    ndClient:= ndOrder.NodeFindOrCreate('CLIENT');
    ndAdress:= ndOrder.NodeFindOrCreate('ADRESS');
    ndPlace:= ndAdress.NodeFindOrCreate('PLACE');

    dmOtto.ObjectGet(ndOrder, aOrderId, aTransaction);
    dmOtto.OrderItemsGet(ndOrderItems, aOrderId, aTransaction);
    dmOtto.OrderTaxsGet(ndOrderTaxs, aOrderId, aTransaction);
    dmOtto.ObjectGet(ndClient, GetXmlAttrValue(ndOrder, 'CLIENT_ID'), aTransaction);
    dmOtto.AdressRead(ndAdress, GetXmlAttrValue(ndOrder, 'ADRESS_ID'), aTransaction);

    SetXmlAttr(ndOrder, 'NEW.STATUS_SIGN', 'DELIVERING');
    dmOtto.ActionExecute(aTransaction, ndOrder);

    OrderItemList:= aTransaction.DefaultDatabase.QueryValue(
      'select list(oi.orderitem_id) '+
      'from orderitems oi '+
      'inner join statuses s on (s.status_id = oi.status_id and s.status_sign in (''PACKED'', ''DELIVERING'')) '+
      'where oi.order_id = :order_id',
      0, [aOrderId], aTransaction);
    while OrderItemList <> '' do
    begin
      OrderItemId:= TakeFront5(OrderItemList, ',');
      ExportOrderItem(aTransaction, ndProduct, ndOrder, ndOrderItems, ndOrderTaxs, ndClient, ndAdress, ndPlace,
        tblCons, tblConsPi3, OrderItemId);
    end;
    BelPostLine:= '[BAR_CODE];[COST_BYR];[EXPN];[ITEMSCOST_EUR];[WEIGHT];'+
      '[CLIENT_FIO];[AREA_NAME];[REGION_NAME];[PLACE_NAME];[STREETTYPE_SIGN] [STREET_NAME];[HOUSE];[BUILD];[FLAT];[POSTINDEX];'+
      '[NUMDEP];[MOBILE_PHONE];[REMK];0';

    if GetXmlAttrValue(ndOrder, 'WEIGHT') <> null then
      BelPostLine:= FillPattern(BelPostLine,
        Value2Vars(GetXmlAttrValue(ndOrder, 'WEIGHT')/1000, 'WEIGHT'
        ), false);
    if GetXmlAttrValue(ndProduct, 'PAYTYPE_SIGN') <> 'POSTPAY' then
      BelPostLine:= FillPattern(BelPostLine,
        Value2Vars('0', 'COST_BYR'), false);

    BelPostLine:= FillPattern(BelPostLine,
      XmlAttrs2Vars(ndOrder, 'BAR_CODE;ITEMSCOST_EUR;CLIENT_FIO;COST_BYR',
      XmlAttrs2Vars(ndClient, 'MOBILE_PHONE',
      XmlAttrs2Vars(ndPlace, 'AREA_NAME;REGION_NAME;PLACE_NAME',
      XmlAttrs2Vars(ndAdress, 'STREET_NAME;STREETTYPE_SIGN;HOUSE;BUILD;FLAT;POSTINDEX'
      )))), true);

  finally
    sl.Free;
  end;
end;

procedure MakeXls(aPacklistNo: Integer; aFileName: string);
begin
  with dmOtto do
  begin
    frxExportXLS.DefaultPath:= Path['DbfPackLists'];
    frxExportXLS.FileName:= aFileName;
    frxExportXLS.Background:= True;
    frxExportXLS.OverwritePrompt:= False;
    frxExportXLS.ShowDialog:= False;
    frxExportXLS.ShowProgress:= True;
    frxExportXLS.ExportPageBreaks:= True;

    frxReport.LoadFromFile(Path['FastReport'] + 'packlistpi3.fr3');
    frxReport.Variables.Variables['PackList_No']:= Format('''%u''', [aPacklistNo]);
    frxReport.PrepareReport(true);
    frxReport.Export(frxExportXLS);
  end;
end;


procedure ExportPack(aTransaction: TpFIBTransaction;
  ndProduct, ndOrders: TXmlNode; aPacklistNo: integer);
const
  HeaderText = 'Формирование паклиста';
var
  ConsName, ConsPi3Name: string;
  OrderList, BelPostLine: string;
  OrderId: variant;
  dbfCons, dbfConsPi3: TDbf;
  BelPostLines: TStringList;
begin
  SetXmlAttr(ndOrders, 'PACKLIST_NO', aPackListNo);
  dbfCons:= TDbf.Create(nil);
  dbfConsPi3:= TDbf.Create(nil);
  ForceDirectories(Path['DbfPackLists']);
  ConsName:= Format('t-cons_%s_%uv.dbf',
      [GetXmlAttr(ndProduct, 'PARTNER_NUMBER'), aPacklistNo]);
  copyFile(Path['Stru']+'tcons.dbf', Path['DbfPackLists'] + ConsName);
  ConsPi3Name:= Format('t-cons_%s_%uvpi3',
      [GetXmlAttr(ndProduct, 'PARTNER_NUMBER'), aPacklistNo]);
  copyFile(Path['Stru']+'tconspi3.dbf', Path['DbfPackLists'] + ConsPi3Name+'.dbf');

  MakeXls(aPacklistNo, ConsPi3Name+'.xls');

  dbfCons.FilePath:= Path['DbfPackLists'];
  dbfCons.TableName:= ConsName;
  dbfConsPi3.FilePath:= Path['DbfPackLists'];
  dbfConsPi3.TableName:= ConsPi3Name+'.dbf';
  BelPostLines:= TStringList.Create;
  try
    dbfCons.Open;
    dbfConsPi3.Open;
    try
      OrderList:= aTransaction.DefaultDatabase.QueryValue(
        'select list(distinct o.order_id) '+
        'from orders o '+
        'inner join statuses s on (s.status_id = o.status_id and s.status_sign = ''PACKED'') '+
        'where o.packlist_no = :packlist_no',
        0, [aPacklistNo], aTransaction);
      dmOtto.InitProgress(WordCount(OrderList, ','), Format('Формирование паклиста %u', [aPacklistNo]));
      while OrderList <> '' do
      begin
        OrderId:= TakeFront5(OrderList, ',');
        ExportOrder(aTransaction, ndProduct, ndOrders, dbfCons, dbfConsPi3, OrderId, BelPostLine);
        BelPostLines.Add(BelPostLine);
        dmOtto.StepProgress;
      end;
      BelPostLines.SaveToFile(Format(
        '%sBaltPost_%s_%u.txt',
        [Path['DbfPackLists'],
         GetXmlAttr(ndProduct, 'PARTNER_NUMBER'),
         aPacklistNo]));
    finally
      dmOtto.InitProgress;
      dbfCons.Close;
      dbfConsPi3.Close;
    end;
  finally
    dbfConsPi3.Free;
    dbfCons.Free;
    BelPostLines.Free;
  end;
  dmOtto.CreateAlert(HeaderText, Format('Сформирован паклист %u', [aPacklistNo]), mtInformation);
end;

procedure ExportProduct(aTransaction: TpFIBTransaction;
  ndProducts: TXmlNode; aProductId: integer);
var
  ndProduct, ndOrders: TXmlNode;
  PackList, FileName, OrderText: string;
  PacklistNo: variant;
begin
  ndProduct:= ndProducts.NodeFindOrCreate('PRODUCT');
  ndOrders:= ndProduct.NodeNew('ORDERS');

  dmOtto.ObjectGet(ndProduct, aProductId, aTransaction);
  PackList:= aTransaction.DefaultDatabase.QueryValue(
    'select list(distinct o.packlist_no) '+
    'from orders o '+
    'inner join statuses s on (s.status_id = o.status_id and s.status_sign = ''PACKED'') '+
    'where o.product_id = :product_id',
    0, [aProductId], aTransaction);
  while PackList <> '' do
  begin
    PacklistNo:= TakeFront5(PackList, ',');
    ExportPack(aTransaction, ndProduct, ndOrders, PacklistNo);
  end;
end;

procedure ExportPackList(aTransaction: TpFIBTransaction);
var
  Xml: TNativeXml;
  ndProducts: TXmlNode;
  ProductId: Variant;
  ProductList: string;
begin
  aTransaction.StartTransaction;
  try
    xml:= TNativeXml.CreateName('PRODUCTS');
    try
      ndProducts:= Xml.Root;
      ProductList:= aTransaction.DefaultDatabase.QueryValue(
        'select list(distinct o.product_id) '+
        'from orders o '+
        'inner join statuses s on (s.status_id = o.status_id and s.status_sign = ''PACKED'') ',
        0, aTransaction);
      while ProductList <> '' do
      begin
        ProductId:= TakeFront5(ProductList, ',');
        ExportProduct(aTransaction, ndProducts, ProductId);
      end;
      dmOtto.ExportCommitRequest(ndProducts, aTransaction);
    finally
      Xml.Free;
    end;
  except
    on E: Exception do
    begin
      aTransaction.Rollback;
      ShowMessage('Ошибка при формировании файлов: '+e.Message);
    end;
  end;
end;

end.
