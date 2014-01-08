unit uParseOrder;

interface

uses
  GvXml, FIBDatabase, pFIBDatabase;

procedure ParseFileOrder(aFileName: string; ndOrder: TGvXmlNode; aTransaction: TpFIBTransaction);

implementation

uses
  Classes, SysUtils, GvStr, udmOtto, Variants, GvXmlUtils, GvMath,
  Dialogs, Controls;

function ToFloat(aStr: string): Double;
begin
  if DecimalSeparator = ',' then
    result:= StrToFloat(ReplaceAll(aStr, '.', DecimalSeparator))
  else
    result:= StrToFloat(ReplaceAll(aStr, ',', DecimalSeparator));
end;


procedure ParseOrderHeaderXml(aLine: string; ndOrder: TGvXmlNode; aTransaction: TpFIBTransaction);
var
  sl: TStringList;
  strStream: TStringStream;
  St: string;
  ndClient, ndAdress, ndPlace: TGvXmlNode;
  ProductId: Integer;
begin
  sl:= TStringList.Create;
  ndAdress:= ndOrder.FindOrCreate('ADRESS');
  ndClient:= ndOrder.FindOrCreate('CLIENT');
  ndPlace:= ndAdress.FindOrCreate('PLACE');

  try
    sl.Delimiter:= ';';
    sl.DelimitedText:= '"'+ReplaceAll(aLine, ';', '";"')+'"';
    ndClient['LAST_NAME']:= UpCaseFirst(EscapeString(sl[0]));
    ndClient['FIRST_NAME']:= UpCaseFirst(EscapeString(sl[1]));
    ndClient['MID_NAME']:= UpCaseFirst(EscapeString(sl[2]));
    ndClient['EMAIL']:= EscapeString(sl[3]);
    ndClient['STATIC_PHONE']:= EscapeString(DeleteChars(sl[11], ' -()'));
    ndClient['MOBILE_PHONE']:= EscapeString(DeleteChars(sl[13]+sl[12], ' -()'));

    if WordCount(sl[4]) = 1 then
    begin
      ndAdress['STREETTYPE_NAME']:= 'ул';
      ndAdress['STREET_NAME']:= UpCaseFirst(EscapeString(sl[4]));
    end
    else
    begin
      St:= sl[4];
      ndAdress['STREETTYPE_NAME']:= TakeFront5(st);
      ndAdress['STREET_NAME']:= UpCaseFirst(EscapeString(st));
    end;
    ndAdress['HOUSE']:= EscapeString(sl[5]);
    ndAdress['BUILDING']:= EscapeString(sl[6]);
    ndAdress['FLAT']:= EscapeString(sl[7]);
    ndAdress['POSTINDEX']:= EscapeString(sl[8]);

    if WordCount(sl[9]) = 1 then
    begin
      ndPlace['PLACETYPE_NAME']:= 'г';
      ndPlace['PLACE_NAME']:= UpCaseFirst(EscapeString(sl[9]));
    end
    else
    begin
      St:= sl[9];
      ndPlace['PLACETYPE_NAME']:= takefront5(st);
      ndPlace['PLACE_NAME']:= UpCaseFirst(EscapeString(st));
    end;

    // разбираем Область, район
    if WordCount(sl[10]) = 2 then
    begin
      St:= sl[10];
      ndPlace['REGION_NAME']:=  UpCaseFirst(takefront5(St));
      ndPlace['AREA_NAME']:= UpCaseFirst(EscapeString(St));
    end
    else
    if WordCount(sl[10]) = 1 then
    begin
      ndPlace['REGION_NAME']:= UpCaseFirst(EscapeString(sl[10]));
    end;
    try
      ProductId:= dmOtto.Recode('ORDER', 'PRODUCT_NAME2ID', EscapeString(sl[14]));
      ndOrder['PRODUCT_ID']:= ProductId;
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

procedure ParseOrderItemXml(aLine: string; ndOrderItems: TGvXmlNode; aTransaction: TpFIBTransaction);
var
  sl: TStringList;
  st: string;
  strStream: TStringStream;
  OrderItemId: Integer;
  ndOrderItem: TGvXmlNode;
  CatalogId, CatalogName, MagazineId: variant;
  ArticleCode: Variant;
  StatusId: Integer;

begin
  sl:= TStringList.Create;
  ndOrderItem:= ndOrderItems.AddChild('ORDERITEM');
  try
    sl.Delimiter:= ';';
    sl.DelimitedText:= '"'+ReplaceAll(aLine, ';', '";"')+'"';
    ndOrderItem['ID']:= dmOtto.GetNewObjectId('ORDERITEM');
    st:= FilterString(sl[1], '0123456789');
    CatalogId:= null;
    if st='' then
      CatalogId:= CatalogDetect('Internet', aTransaction);
    ndOrderItem['PAGE_NO']:= st;
    ndOrderItem['POSITION_SIGN']:= FilterString(sl[2], '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
    ndOrderItem['ARTICLE_CODE']:= FilterString(UpperCase(sl[3]), '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
    st:= FilterString(UpperCase(sl[4]), '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
    if st='' then st:= '0';
    ndOrderItem['DIMENSION']:= st;
    ndOrderItem['PRICE_EUR']:= StrToCurr(EscapeString(sl[5]));
    ndOrderItem['AMOUNT']:= 1;
    ndOrderItem['COST_EUR']:= StrToCurr(EscapeString(sl[5]));
    ndOrderItem['NAME_RUS']:= EscapeString(sl[6]);

    // Validate OrderItem

    CatalogId:= CatalogDetect('Internet', aTransaction);
    // Ищем действующий каталог
    MagazineId:= MagazineDetect(CatalogId, aTransaction);
    ndOrderItem['MAGAZINE_ID']:= MagazineId;
  finally
    sl.Free;
  end;
end;

procedure DetectClient(ndClient: TGvXmlNode; aTransaction: TpFIBTransaction);
var
  Phone: String;
begin
  Phone:= FilterString(ndClient['MOBILE_PHONE'], '0123456789');
  if Copy(Phone, 1, 3) = '375' then
    Phone:= Recode(Phone, '+[1][2][3]([4][5])[6][7][8]-[9][10][11][12]')
  else
  if Copy(Phone, 1, 2) = '80' then
    Phone:= Recode(Phone, '+375([3][4])[5][6][7]-[8][9][10][11]');
  ndClient['MOBILE_PHONE']:= Phone;

  Phone:= FilterString(ndClient['STATIC_PHONE'], '0123456789');
  if Copy(Phone, 1, 3) = '375' then
    Phone:= Recode(Phone, '8-0[4][5][6][7][8][9][10][11][12]')
  else
  if Copy(Phone, 1, 2) = '80' then
    Phone:= Recode(Phone, '8-0[3][4][5][6][7][8][9][10][11]');
  ndClient['STATIC_PHONE']:= Phone;
end;

procedure DetectProduct(ndProduct: TGvXmlNode; aTransaction: TpFIBTransaction);
begin
  ndProduct['ID']:= aTransaction.DefaultDatabase.QueryValue(
    'select pa.object_id from v_product_attrs pa where pa.attr_sign = ''PARTNER_NUMBER'' and pa.attr_value = :partner_number',
    0, [ndProduct['PARTNER_NUMBER']], aTransaction);
end;

procedure DetectOrderItem(ndOrderItem: TGvXmlNode; aTransaction: TpFIBTransaction);
var
  OrderItemId: Variant;
  StatusId: Integer;
begin
  ndOrderItem['ID']:= dmOtto.GetNewObjectId('ORDERITEM');
  ndOrderItem['CATALOG_ID']:= CatalogDetect('Internet', aTransaction);
  ndOrderItem['MAGAZINE_ID']:= MagazineDetect(ndOrderItem['CATALOG_ID'], aTransaction);
  ndOrderItem['AMOUNT']:= 1;
  ndOrderItem['STATUS_ID']:= dmOtto.GetDefaultStatusId('ORDERITEM');
  ndOrderItem['STATUS_FLAG_LIST']:= dmOtto.GetFlagListById(ndOrderItem['STATUS_ID']);
  BatchMoveFields(ndOrderItem, ndOrderItem, 'COST_EUR=PRICE_EUR');
end;

procedure ParseXmlOrder(aFileName: string; ndOrder: TGvXmlNode; aTransaction: TpFIBTransaction);
var
  xml: TGvXml;
  i: Integer;
  nd, ndOrderItems: TGvXmlNode;
begin
  xml:= TGvXml.Create;
  try
    xml.LoadFromFile(aFileName);
//    TranscodeXmlUtf2Ansi(xml);
//    MergeNode(ndOrder, xml.Root);
    DetectClient(ndOrder.Find('CLIENT'), aTransaction);
    DetectProduct(ndOrder.Find('PRODUCT'), aTransaction);
    BatchMoveFields(ndOrder, ndOrder.Find('PRODUCT'), 'PRODUCT_ID=ID');
    ndOrderItems:= ndOrder.Find('ORDERITEMS');
    for i:= 0 to ndOrderItems.ChildNodes.Count-1 do
      DetectOrderItem(ndOrderItems.Nodes[i], aTransaction);
  finally
    xml.Free;
  end;
end;

procedure ParseFileOrder(aFileName: string; ndOrder: TGvXmlNode; aTransaction: TpFIBTransaction);
var
  Lines: TStringList;
  i: Integer;
  ndOrderItems: TGvXmlNode;

begin
  if LowerCase(ExtractFileExt(aFileName)) = '.xml' then
    ParseXmlOrder(aFileName, ndOrder, aTransaction)
  else
  begin
    Lines:= TStringList.Create;
    try
      Lines.LoadFromFile(aFileName);
      ParseOrderHeaderXml(Lines[0], ndOrder, aTransaction);
      ndOrderItems:= ndOrder.FindOrCreate('ORDERITEMS');
      for i:= 1 to lines.count-1 do
        ParseOrderItemXml(Lines[i], ndOrderItems, aTransaction);
    finally
      Lines.Free;
    end;
  end;
end;

end.
