unit uParseOrder;

interface

uses
  NativeXml, FIBDatabase, pFIBDatabase;

procedure ParseFileOrder(aFileName: string; ndOrder: TXmlNode; aTransaction: TpFIBTransaction);

implementation

uses
  Classes, SysUtils, GvStr, udmOtto, Variants, GvNativeXml, GvMath,
  Dialogs, Controls;

function ToFloat(aStr: string): Double;
begin
  if DecimalSeparator = ',' then
    result:= StrToFloat(ReplaceAll(aStr, '.', DecimalSeparator))
  else
    result:= StrToFloat(ReplaceAll(aStr, ',', DecimalSeparator));
end;


procedure ParseOrderHeaderXml(aLine: string; ndOrder: TXmlNode; aTransaction: TpFIBTransaction);
var
  sl: TStringList;
  strStream: TStringStream;
  St: string;
  ndClient, ndAdress, ndPlace: TXmlNode;
  ProductId: Integer;
begin
  sl:= TStringList.Create;
  ndAdress:= ndOrder.NodeFindOrCreate('ADRESS');
  ndClient:= ndOrder.NodeFindOrCreate('CLIENT');
  ndPlace:= ndAdress.NodeFindOrCreate('PLACE');

  try
    sl.Delimiter:= ';';
    sl.DelimitedText:= '"'+ReplaceAll(aLine, ';', '";"')+'"';
    st:= UpCaseFirst(EscapeString(sl[0]));
    SetXmlAttr(ndClient, 'LAST_NAME', st);
    st:= UpCaseFirst(EscapeString(sl[1]));
    SetXmlAttr(ndClient, 'FIRST_NAME', st);
    st:= UpCaseFirst(EscapeString(sl[2]));
    SetXmlAttr(ndClient, 'MID_NAME', st);
    SetXmlAttr(ndClient, 'EMAIL', EscapeString(sl[3]));
    SetXmlAttr(ndClient, 'STATIC_PHONE', EscapeString(DeleteChars(sl[11], ' -()')));
    SetXmlAttr(ndClient, 'MOBILE_PHONE', EscapeString(DeleteChars(sl[13]+sl[12], ' -()')));

    if WordCount(sl[4]) = 1 then
    begin
      SetXmlAttr(ndAdress, 'STREETTYPE_NAME', 'ул');
      SetXmlAttr(ndAdress, 'STREET_NAME', UpCaseFirst(EscapeString(sl[4])));
    end
    else
    begin
      St:= sl[4];
      SetXmlAttr(ndAdress, 'STREETTYPE_NAME',TakeFront5(st));
      SetXmlAttr(ndAdress, 'STREET_NAME', UpCaseFirst(EscapeString(st)));
    end;
    SetXmlAttr(ndAdress, 'HOUSE', EscapeString(sl[5]));
    SetXmlAttr(ndAdress, 'BUILDING', EscapeString(sl[6]));
    SetXmlAttr(ndAdress, 'FLAT', EscapeString(sl[7]));
    SetXmlAttr(ndAdress, 'POSTINDEX', EscapeString(sl[8]));

    if WordCount(sl[9]) = 1 then
    begin
      SetXmlAttr(ndPlace, 'PLACETYPE_NAME', 'г');
      SetXmlAttr(ndPlace, 'PLACE_NAME', UpCaseFirst(EscapeString(sl[9])));
    end
    else
    begin
      St:= sl[9];
      SetXmlAttr(ndPlace, 'PLACETYPE_NAME', takefront5(st));
      SetXmlAttr(ndPlace, 'PLACE_NAME', UpCaseFirst(EscapeString(st)));
    end;

    // разбираем Область, район
    if WordCount(sl[10]) = 2 then
    begin
      SetXmlAttr(ndPlace, 'REGION_NAME', UpCaseFirst(EscapeString(sl[10])));
      SetXmlAttr(ndPlace, 'AREA_NAME', UpCaseFirst(EscapeString(sl[10])));
    end
    else
    if WordCount(sl[10]) = 1 then
    begin
      SetXmlAttr(ndPlace, 'REGION_NAME', UpCaseFirst(EscapeString(sl[10])));
    end;
    try
      ProductId:= dmOtto.Recode('ORDER', 'PRODUCT_NAME2ID', EscapeString(sl[14]));
      SetXmlAttr(ndOrder, 'PRODUCT_ID', ProductId)
    except
      ShowMessage(Format('Неизвеcтный тип продукта. Выставьте правильный тип. В заявке указан "%s"',
       [sl[14]]));
    end;
  finally
    sl.Free;
  end;
end;

function CatalogDetect(aCatalogName: string; aTransaction: TpFIBTransaction): Variant;
begin
  Result:= aTransaction.DefaultDatabase.QueryValue(
      'select catalog_id from catalogs where upper(catalog_name)=upper(:catalog_name)',
      0, [aCatalogName]);
end;

function MagazineDetect(aCatalogId: Integer; aTransaction: TpFIBTransaction): variant;
begin
  Result:= aTransaction.DefaultDatabase.QueryValue(
      'select first 1 magazine_id from magazines '+
      'where catalog_id = :catalog_id '+
      ' and valid_date > current_date '+
      'order by valid_date', 0,
      [aCatalogId]);
end;

procedure ParseOrderItemXml(aLine: string; ndOrderItems: TXmlNode; aTransaction: TpFIBTransaction);
var
  sl: TStringList;
  st: string;
  strStream: TStringStream;
  OrderItemId: Integer;
  ndOrderItem: TXmlNode;
  CatalogId, CatalogName, MagazineId: variant;
  ArticleCode: Variant;
  StatusId: Integer;

begin
  sl:= TStringList.Create;
  ndOrderItem:= ndOrderItems.NodeNew('ORDERITEM');
  try
    sl.Delimiter:= ';';
    sl.DelimitedText:= '"'+ReplaceAll(aLine, ';', '";"')+'"';
    SetXmlAttr(ndOrderItem, 'ID', dmOtto.GetNewObjectId('ORDERITEM'));
    st:= FilterString(sl[1], '0123456789');
    CatalogId:= null;
    if st='' then
      CatalogId:= CatalogDetect('Internet', aTransaction);
    SetXmlAttr(ndOrderItem, 'PAGE_NO', st);
    st:= FilterString(sl[2], '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
    SetXmlAttr(ndOrderItem, 'POSITION_SIGN', st);
    st:= FilterString(UpperCase(sl[3]), '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
    SetXmlAttr(ndOrderItem, 'ARTICLE_CODE', st);
    st:= FilterString(UpperCase(sl[4]), '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
    if st='' then st:= '0';
    SetXmlAttr(ndOrderItem, 'DIMENSION', st);
    SetXmlAttr(ndOrderItem, 'PRICE_EUR', ToFloat(EscapeString(sl[5])));
    SetXmlAttr(ndOrderItem, 'AMOUNT', 1);
    SetXmlAttr(ndOrderItem, 'COST_EUR', ToFloat(EscapeString(sl[5])));
    st:= sl[6];
    SetXmlAttr(ndOrderItem, 'NAME_RUS', EscapeString(TakeFront5(st)));
    SetXmlAttr(ndOrderItem, 'KIND_RUS', EscapeString(st));

    // Validate OrderItem

    CatalogId:= CatalogDetect('Internet', aTransaction);
    // Ищем действующий каталог
    MagazineId:= MagazineDetect(CatalogId, aTransaction);
    SetXmlAttr(ndOrderItem, 'MAGAZINE_ID', MagazineId);
  finally
    sl.Free;
  end;
end;

procedure DetectClient(ndClient: TXmlNode; aTransaction: TpFIBTransaction);
var
  Phone: String;
begin
  Phone:= FilterString(GetXmlAttr(ndClient, 'MOBILE_PHONE'), '0123456789');
  if Copy(Phone, 1, 3) = '375' then
    Phone:= Recode(Phone, '+[1][2][3]([4][5])[6][7][8]-[9][10][11][12]')
  else
  if Copy(Phone, 1, 2) = '80' then
    Phone:= Recode(Phone, '+375([3][4])[5][6][7]-[8][9][10][11]');
  SetXmlAttr(ndClient, 'MOBILE_PHONE', Phone);

  Phone:= FilterString(GetXmlAttr(ndClient, 'STATIC_PHONE'), '0123456789');
  if Copy(Phone, 1, 3) = '375' then
    Phone:= Recode(Phone, '8-0[4][5][6][7][8][9][10][11][12]')
  else
  if Copy(Phone, 1, 2) = '80' then
    Phone:= Recode(Phone, '8-0[3][4][5][6][7][8][9][10][11]');
  SetXmlAttr(ndClient, 'STATIC_PHONE', Phone);
end;

procedure DetectProduct(ndProduct: TXmlNode; aTransaction: TpFIBTransaction);
var
  ProductId: Variant;
begin
  ProductId:= aTransaction.DefaultDatabase.QueryValue(
    'select pa.object_id from v_product_attrs pa where pa.attr_sign = ''PARTNER_NUMBER'' and pa.attr_value = :partner_number',
    0, [GetXmlAttrValue(ndProduct, 'PARTNER_NUMBER')], aTransaction);
  SetXmlAttr(ndProduct, 'ID', ProductId);
end;

procedure DetectOrderItem(ndOrderItem: TXmlNode; aTransaction: TpFIBTransaction);
var
  OrderItemId: Variant;
  StatusId: Integer;
begin
  SetXmlAttr(ndOrderItem, 'ID', dmOtto.GetNewObjectId('ORDERITEM'));
  SetXmlAttr(ndOrderItem, 'CATALOG_ID', CatalogDetect('Internet', aTransaction));
  SetXmlAttr(ndOrderItem, 'MAGAZINE_ID', MagazineDetect(GetXmlAttrValue(ndOrderItem, 'CATALOG_ID'), aTransaction));
  SetXmlAttr(ndOrderItem, 'AMOUNT', 1);
  StatusId:= dmOtto.GetDefaultStatusId('ORDERITEM');
  SetXmlAttr(ndOrderItem, 'STATUS_ID', StatusId);
  SetXmlAttr(ndOrderItem, 'STATUS_FLAG_LIST', dmOtto.GetFlagListById(StatusId));
  BatchMoveFields2(ndOrderItem, ndOrderItem, 'COST_EUR=PRICE_EUR');
end;

procedure ParseXmlOrder(aFileName: string; ndOrder: TXmlNode; aTransaction: TpFIBTransaction);
var
  xml: TNativeXml;
  i: Integer;
  nd, ndOrderItems: TXmlNode;
begin
  xml:= TNativeXml.Create;
  try
    xml.LoadFromFile(aFileName);
    TranscodeXmlUtf2Ansi(xml);
    MergeNode(ndOrder, xml.Root);
    DetectClient(ndOrder.NodeByName('CLIENT'), aTransaction);
    DetectProduct(ndOrder.NodeByName('PRODUCT'), aTransaction);
    BatchMoveFields2(ndOrder, ndOrder.NodeByName('PRODUCT'), 'PRODUCT_ID=ID');
    ndOrderItems:= ndOrder.NodeByName('ORDERITEMS');
    for i:= 0 to ndOrderItems.NodeCount-1 do
      DetectOrderItem(ndOrderItems[i], aTransaction);
  finally
    xml.Free;
  end;
end;

procedure ParseFileOrder(aFileName: string; ndOrder: TXmlNode; aTransaction: TpFIBTransaction);
var
  Lines: TStringList;
  i: Integer;
  ndOrderItems: TXmlNode;

begin
  if LowerCase(ExtractFileExt(aFileName)) = '.xml' then
    ParseXmlOrder(aFileName, ndOrder, aTransaction)
  else
  begin
    Lines:= TStringList.Create;
    try
      Lines.LoadFromFile(aFileName);
      ParseOrderHeaderXml(Lines[0], ndOrder, aTransaction);
      ndOrderItems:= ndOrder.NodeFindOrCreate('ORDERITEMS');
      for i:= 1 to lines.count-1 do
        ParseOrderItemXml(Lines[i], ndOrderItems, aTransaction);
    finally
      Lines.Free;
    end;
  end;
end;

end.
