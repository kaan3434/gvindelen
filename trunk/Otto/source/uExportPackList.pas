unit uExportPackList;

interface
uses
  Classes, GvXml, FIBDatabase, pFIBDatabase, DB;

procedure ExportPackList(aTransaction: TpFIBTransaction);

implementation
uses
  SysUtils, GvXmlUtils, udmOtto, GvStr, Dbf, GvFile, uMain, Dialogs, GvVariant,
  frxClass, frxExportXLS, GvMath, GvVars, Variants;

function GetPlace(ndPlace: TGvXmlNode): string;
begin
  Result:= FillPattern(
    '{PLACETYPE_CODE <> "4" THEN [PLACETYPE_SIGN]. }[PLACE_NAME]',
    XmlAttrs2Attr(ndPlace, 'PLACETYPE_CODE;PLACETYPE_SIGN;PLACE_NAME'));
end;

function GetStreet(ndAdress: TGvXmlNode): string;
begin
  Result:= FillPattern(
    '{STREETTYPE_CODE > "1" THEN  [STREETTYPE_NAME]. }[STREET_NAME]',
    XmlAttrs2Attr(ndAdress, 'STREETTYPE_CODE;STREETTYPE_NAME;STREET_NAME'));
end;

function GetHome(ndAdress: TGvXmlNode): string;
begin
  Result:= FillPattern(
    '{HOUSE THEN [HOUSE]}{BUILDING THEN /[BUILDING]}{FLAT THEN -[FLAT]}',
    XmlAttrs2Attr(ndAdress, 'HOUSE;BUILDING;FLAT'));
end;

function GetAdress(ndAdress: TGvXmlNode): string;
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
  ndProduct, ndOrder, ndOrderItems, ndOrderTaxs, ndClient, ndAdress, ndPlace: TGvXmlNode;
  tblCons, tblConsPi3: TDataSet; aOrderItemId: variant);
var
  ndOrderItem, ndTaxSSbor: TGvXmlNode;
  ShortClientName: string;
  St: string;
begin
  ndOrderItem:= ndOrderItems.Find('ORDERITEM', 'ID', aOrderItemId);
  try
    ndTaxSSbor:= ndOrderTaxs.Find('ORDERTAX', 'TAXSERV_ID', '1');
    if not Assigned(ndTaxSSbor) then
    begin
      ShowMessage('Отсутствует сервисный сбор на заявке '+ndOrder['ORDER_CODE']);
    end;

//    ndProduct.Document.XmlFormat:= xfReadable;
//    ndProduct.Document.SaveToFile('order.xml');
    tblCons.Append;
    BatchMoveFields(tblCons, ndProduct, 'KTPART=PARTNER_NUMBER');
    BatchMoveFields(tblCons, ndOrder,
      'KTKUNDE=ORDER_CODE;NRSENDUNG=PACKLIST_NO;NRKARTON=PALETTE_NO;'+
      'DATEEXCH=CREATE_DTM;RATEEXCH=BYR2EUR;USEXCH="0";VIDPLAT="0";'+
      'CONTR_ID=ID;COSTALL=ITEMSCOST_EUR;BARKOD=BAR_CODE');
    BatchMoveFields(tblCons, ndOrderItem,
      'NRART=ARTICLE_CODE;BZARTORG=DESCRIPTION;MENGE=AMOUNT;PRVK=PRICE_EUR;'+
      'NREGWG;ZNAK="1";INSUM="1";NRAUFPOS=ORDERITEM_INDEX');
    BatchMoveFields(tblCons, ndTaxSSbor,
        'SBOR=COST_EUR');
    BatchMoveFields(tblCons, ndAdress,
      'GOSNUM=POSTINDEX');
    BatchMoveFields(tblCons, ndClient,
      'BLACKLIST="0"');
    tblCons['NEWICHT']:= ndOrder.Attr['WEIGHT'].AsIntegerDef(0)/1000;

    tblCons['KTNAME']:= FillPattern(
      '[FIRST_NAME|TRANSLIT]{MID_NAME THEN  [MID_NAME|SUBSTR=1,1|TRANSLIT]}[{ORDER_LAST_NAME THEN ORDER_LAST_NAME ELSE LAST_NAME}|TRANSLIT]',
      XmlAttrs2Attr(ndClient, 'FIRST_NAME;MID_NAME;LAST_NAME',
      XmlAttrs2Attr(ndOrder, 'ORDER_LAST_NAME=LAST_NAME')));
    tblCons['AUFEXT']:= CopyLast(ndOrder['ORDER_CODE'], 5);
    tblCons['GRART']:= dmOtto.Recode('ORDERITEM', 'DIMENSION_ENCODE', ndOrderItem['DIMENSION']);
    tblCons['NAMEZAK']:= ndOrderItem['NAME_RUS'];
    tblCons['FAMILY']:= FillPattern(
      '{ORDER_LAST_NAME THEN [ORDER_LAST_NAME] ELSE [LAST_NAME]} [FIRST_NAME]{MID_NAME THEN  [MID_NAME]}',
      XmlAttrs2Attr(ndClient, 'FIRST_NAME;LAST_NAME;MID_NAME',
      XmlAttrs2Attr(ndOrder, 'ORDER_LAST_NAME=LAST_NAME')));
    tblCons['STREETRUS']:= GetAdress(ndAdress);
    tblCons['CITYRUS']:= GetPlace(ndPlace);
    tblCons['REGIONRUS']:= FillPattern(
      '{AREA_NAME THEN [AREA_NAME] р-н., }{REGION_NAME THEN [REGION_NAME] обл.}',
      XmlAttrs2Attr(ndPlace, 'AREA_NAME;REGION_NAME'));
    tblCons['STREET']:= Translit(GetAdress(ndAdress));
    tblCons['CITY']:= Translit(GetPlace(ndPlace));
    tblCons['REGION']:= Translit(tblCons['REGIONRUS']);

    tblCons['TEL']:= GetMobilePhone('+375'+ndClient['MOBILE_PHONE']);
    tblCons['COSTBYR']:= ndOrder.Attr['COST_BYR'].AsMoney;
    tblCons['SBORBYR']:= ndTaxSSbor.Attr['COST_BYR'].AsMoney;

    if ndProduct.Attr['PAYTYPE_SIGN'].ValueIn(['POSTPAY']) then // Наложенный платеж
    begin
      BatchMoveFields(tblCons, ndOrder,
        'VIDPLAT="1";INFOP=PACKLIST_NO;INFOPDATE=INVOICE_DT_0;COSTALLN=INVOICE_BYR_0');
    end;
    tblCons.Post;
    tblConsPi3.Append;
    BatchMoveFields(tblConsPi3, tblCons,
      'KTPART;X211=NRSENDUNG;NZAK=KTKUNDE;EXP_3="300";NAMEZAK;NRART;GRART;KOL="1";'+
      'PRICE=PRVK;PRICEBEL=COSTBYR;SERVBEL=SBORBYR;DATEPOST=DATEEXCH;NREGWG;'+
      'FAMILY;PARTOBL=REGIONRUS;TELEPHONE=TEL;NORG="1";INDEXCITY=GOSNUM;'+
      'CITYRUS;N14=NRPALETTE');
    BatchMoveFields(tblConsPi3, ndOrderItem,
      'NRAUFPOS=ORDERITEM_INDEX');
    tblConsPi3['STREET']:= GetStreet(ndAdress);
    tblConsPi3['HOME']:= GetHome(ndAdress);
    tblConsPi3['NEWICHT']:= ndOrderItem.Attr['WEIGHT'].AsIntegerDef(0)/1000;
    tblConsPi3.Post;
    ndOrderItem['NEW.STATUS_SIGN']:= 'DELIVERING';
    dmOtto.ActionExecute(aTransaction, ndOrderItem);
  finally
    ndOrderItem.Clear;
  end;
end;

procedure ExportOrder(aTransaction: TpFIBTransaction;
  ndProduct, ndOrders: TGvXmlNode; tblCons, tblConsPi3: TDataSet;
  aOrderId: integer; var BelPostLine: string);
var
  ndOrder, ndOrderItems, ndOrderItem, ndOrderTaxs, ndClient, ndAdress, ndPlace: TGvXmlNode;
  OrderItemList: string;
  OrderItemId: Variant;
  i: integer;
  sl: TStringList;
begin
  sl:= TStringList.Create;
  try
    ndOrder:= ndOrders.AddChild('ORDER');
    ndOrderItems:= ndOrder.FindOrCreate('ORDERITEMS');
    ndOrderTaxs:= ndOrder.FindOrCreate('ORDERTAXS');
    ndClient:= ndOrder.FindOrCreate('CLIENT');
    ndAdress:= ndOrder.FindOrCreate('ADRESS');
    ndPlace:= ndAdress.FindOrCreate('PLACE');

    dmOtto.ObjectGet(ndOrder, aOrderId, aTransaction);
    dmOtto.OrderItemsGet(ndOrderItems, aOrderId, aTransaction);
    dmOtto.OrderTaxsGet(ndOrderTaxs, aOrderId, aTransaction);
    dmOtto.ObjectGet(ndClient, ndOrder['CLIENT_ID'], aTransaction);
    dmOtto.AdressRead(ndAdress, ndOrder['ADRESS_ID'], aTransaction);

    ndOrder['NEW.STATUS_SIGN']:= 'DELIVERING';
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

    BelPostLine:= FillPattern(
      '[BAR_CODE];{PAYTYPE_SIGN <> "POSTPAY" THEN 0 ELSE [COST_BYR]};[EXPN];[ITEMSCOST_EUR];[WEIGHT];'+
      '[CLIENT_FIO];[AREA_NAME];[REGION_NAME];[PLACE_NAME];[STREETTYPE_SIGN] [STREET_NAME];[HOUSE];[BUILD];[FLAT];[POSTINDEX];'+
      '[NUMDEP];[MOBILE_PHONE];[REMK];0',
      XmlAttrs2Attr(ndProduct, 'PAYTYPE_SIGN',
      XmlAttrs2Attr(ndOrder, 'BAR_CODE;ITEMSCOST_EUR;CLIENT_FIO;COST_BYR',
      XmlAttrs2Attr(ndClient, 'MOBILE_PHONE',
      XmlAttrs2Attr(ndPlace, 'AREA_NAME;REGION_NAME;PLACE_NAME',
      XmlAttrs2Attr(ndAdress, 'STREET_NAME;STREETTYPE_SIGN;HOUSE;BUILD;FLAT;POSTINDEX',
      Value2Attr(ndOrder.Attr['WEIGHT'].AsIntegerDef(0)/1000, 'WEIGHT'
      )))))));

  finally
    sl.Free;
  end;
end;

procedure MakeXls(aPacklistNo: Integer; aFileName: string);
begin
  with dmOtto, MainForm do
  begin
    frxExportXLS.DefaultPath:= Path['DbfPackLists'];
    frxExportXLS.FileName:= aFileName;
    frxExportXLS.ShowDialog := False;
    frxExportXLS.Background:= True;
    frxExportXLS.OverwritePrompt:= False;
    frxExportXLS.ShowDialog:= False;
    frxExportXLS.ShowProgress:= True;
    frxExportXLS.ExportPageBreaks:= True;

    frxReport.LoadFromFile(Path['FastReport'] + 'packlistpi3.fr3');
    frxReport.Variables.Variables['PackList_No']:= Format('''%u''', [aPacklistNo]);
    frxReport.PrepareReport(true);
    frxReport.Export(frxExportXLS);
    frxExportXLS.ShowDialog := true;
  end;
end;


procedure ExportPack(aTransaction: TpFIBTransaction;
  ndProduct, ndOrders: TGvXmlNode; aPacklistNo: integer);
const
  HeaderText = 'Формирование паклиста';
var
  ConsName, ConsPi3Name: string;
  OrderList, BelPostLine: string;
  OrderId: variant;
  dbfCons, dbfConsPi3: TDbf;
  BelPostLines: TStringList;
begin
  ndOrders['PACKLIST_NO']:= aPackListNo;
  dbfCons:= TDbf.Create(nil);
  dbfConsPi3:= TDbf.Create(nil);
  ForceDirectories(Path['DbfPackLists']);
  ConsName:= Format('t-cons_%s_%uv.dbf',
      [ndProduct['PARTNER_NUMBER'], aPacklistNo]);
  copyFile(Path['Stru']+'tcons.dbf', Path['DbfPackLists'] + ConsName);
  ConsPi3Name:= Format('t-cons_%s_%uvpi3',
      [ndProduct['PARTNER_NUMBER'], aPacklistNo]);
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
         ndProduct['PARTNER_NUMBER'],
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
  ndProducts: TGvXmlNode; aProductId: integer);
var
  ndProduct, ndOrders: TGvXmlNode;
  PackList, FileName, OrderText: string;
  PacklistNo: variant;
begin
  ndProduct:= ndProducts.FindOrCreate('PRODUCT');
  ndOrders:= ndProduct.AddChild('ORDERS');

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
  Xml: TGvXml;
  ndProducts: TGvXmlNode;
  ProductId: Variant;
  ProductList: string;
begin
  aTransaction.StartTransaction;
  try
    xml:= TGvXml.Create('PRODUCTS');
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
